#!/usr/bin/env python3
"""Compare research docs against plugin inventory to find gaps and staleness.

Scans research docs for feature recommendations and CC version references,
then compares against existing plugins/skills to identify gaps and staleness.

Exit code 0 = no actionable findings, exit code 1 = findings exist.

Usage:
    python research-compare.py --research-dir .research-docs --plugins-dir plugins
"""

import argparse
import json
import re
import sys
from pathlib import Path


# Patterns for extraction
_VERSION_RE = re.compile(r"v(\d+\.\d+\.\d+)")
_HEADING_RE = re.compile(r"^#{2,3}\s+(.+)", re.MULTILINE)
_RECOMMEND_RE = re.compile(
    r"^#{1,4}\s+.*(recommendation|action|adoption).*$",
    re.IGNORECASE | re.MULTILINE,
)
_SECTION_RE = re.compile(
    r"(recommendation|action|adoption)",
    re.IGNORECASE,
)


def _parse_research_doc(path: Path) -> dict:
    """Extract headings, versions, and recommendation sections from a research doc."""
    text = path.read_text(encoding="utf-8")
    headings = [h.strip() for h in _HEADING_RE.findall(text)]
    versions = _VERSION_RE.findall(text)

    # Extract paragraphs/sections that contain recommendation keywords
    recommendations = []
    for line in text.splitlines():
        if _SECTION_RE.search(line):
            recommendations.append(line.strip())

    return {
        "path": str(path),
        "headings": headings,
        "versions": versions,
        "recommendations": recommendations,
    }


def _scan_research_dir(research_dir: Path) -> list[dict]:
    """Scan all markdown docs under research_dir/docs/."""
    docs_path = research_dir / "docs"
    if not docs_path.exists():
        # Fallback: scan root of research_dir
        docs_path = research_dir
    results = []
    for md in sorted(docs_path.rglob("*.md")):
        results.append(_parse_research_doc(md))
    return results


def _scan_plugins(plugins_dir: Path) -> dict:
    """Scan plugins directory for plugin metadata and skill descriptions."""
    plugins = {}
    for plugin_dir in sorted(plugins_dir.iterdir()):
        if not plugin_dir.is_dir():
            continue
        name = plugin_dir.name
        manifest_path = plugin_dir / ".claude-plugin" / "plugin.json"
        metadata = {}
        if manifest_path.exists():
            try:
                metadata = json.loads(manifest_path.read_text(encoding="utf-8"))
            except json.JSONDecodeError:
                pass

        skills = {}
        skills_dir = plugin_dir / "skills"
        if skills_dir.exists():
            for skill_dir in sorted(skills_dir.iterdir()):
                if not skill_dir.is_dir():
                    continue
                skill_md = skill_dir / "SKILL.md"
                if skill_md.exists():
                    skill_text = skill_md.read_text(encoding="utf-8")
                    skill_versions = _VERSION_RE.findall(skill_text)
                    skill_headings = _HEADING_RE.findall(skill_text)
                    skills[skill_dir.name] = {
                        "versions": skill_versions,
                        "headings": skill_headings,
                    }

        plugins[name] = {
            "metadata": metadata,
            "skills": skills,
        }
    return plugins


def _find_gaps(research_docs: list[dict], plugins: dict) -> list[dict]:
    """Find research recommendations with no corresponding plugin or skill."""
    # Build a searchable set of plugin/skill names and keywords
    plugin_names = set(plugins.keys())
    plugin_keywords: set[str] = set()
    for p in plugins.values():
        meta = p.get("metadata", {})
        for kw in meta.get("keywords", []):
            plugin_keywords.add(kw.lower())
        desc = meta.get("description", "").lower()
        plugin_keywords.update(desc.split())
        for skill_name in p.get("skills", {}).keys():
            plugin_keywords.update(skill_name.lower().replace("-", " ").split())

    gaps = []
    for doc in research_docs:
        for rec in doc["recommendations"]:
            rec_lower = rec.lower()
            # Check if any plugin name or keyword appears in the recommendation
            matched = any(name in rec_lower for name in plugin_names)
            if not matched:
                matched = any(kw in rec_lower for kw in plugin_keywords if len(kw) > 3)
            if not matched:
                gaps.append({"recommendation": rec, "source": doc["path"]})

    return gaps


def _find_staleness(research_docs: list[dict], plugins: dict) -> list[dict]:
    """Find plugins referencing older CC versions than latest in research docs."""

    def _parse_semver(v: str) -> tuple[int, int, int]:
        parts = v.split(".")
        try:
            return (int(parts[0]), int(parts[1]), int(parts[2]))
        except (ValueError, IndexError):
            return (0, 0, 0)

    # Collect all versions from research docs
    all_research_versions = []
    for doc in research_docs:
        all_research_versions.extend(doc["versions"])

    if not all_research_versions:
        return []

    latest_version = max(all_research_versions, key=_parse_semver)

    stale = []
    for plugin_name, plugin_data in plugins.items():
        for skill_name, skill_data in plugin_data["skills"].items():
            skill_versions = skill_data.get("versions", [])
            if not skill_versions:
                continue
            skill_latest = max(skill_versions, key=_parse_semver)
            if _parse_semver(skill_latest) < _parse_semver(latest_version):
                stale.append(
                    {
                        "plugin": plugin_name,
                        "skill": skill_name,
                        "skill_version": skill_latest,
                        "research_latest": latest_version,
                    }
                )

    return stale


def _suggest_plugins(gaps: list[dict]) -> list[str]:
    """Generate suggested plugin names from gap recommendations."""
    suggestions = []
    for gap in gaps[:10]:  # Cap at 10 suggestions
        rec = gap["recommendation"]
        # Extract capitalized words as potential plugin concepts
        words = re.findall(r"\b[A-Z][a-z]+\b", rec)
        if words:
            slug = "-".join(w.lower() for w in words[:3])
            suggestions.append(f"`{slug}` — from: {rec[:80]}")
    return suggestions


def _render_markdown(gaps: list[dict], stale: list[dict], suggestions: list[str]) -> str:
    """Render findings as structured markdown."""
    lines = ["# Research Monitor Findings", ""]

    # Gap table
    lines.append("## Gaps: Research Recommendations Without Plugin Coverage")
    lines.append("")
    if gaps:
        lines.append("| Recommendation | Source |")
        lines.append("|---|---|")
        for g in gaps[:20]:  # Cap table at 20 rows
            rec = g["recommendation"].replace("|", "\\|")[:100]
            src = Path(g["source"]).name
            lines.append(f"| {rec} | {src} |")
    else:
        lines.append("No gaps found.")
    lines.append("")

    # Staleness warnings
    lines.append("## Staleness: Skills Referencing Outdated CC Versions")
    lines.append("")
    if stale:
        lines.append("| Plugin | Skill | Skill Version | Research Latest |")
        lines.append("|---|---|---|---|")
        for s in stale:
            lines.append(
                f"| {s['plugin']} | {s['skill']} | v{s['skill_version']} | v{s['research_latest']} |"
            )
    else:
        lines.append("No staleness issues found.")
    lines.append("")

    # Suggested new plugins
    lines.append("## Suggested New Plugins")
    lines.append("")
    if suggestions:
        for sug in suggestions:
            lines.append(f"- {sug}")
    else:
        lines.append("No new plugins suggested.")
    lines.append("")

    return "\n".join(lines)


def main() -> int:
    """Run the research comparison and print findings markdown."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--research-dir",
        required=True,
        type=Path,
        help="Path to the cloned claude-code-research repo",
    )
    parser.add_argument(
        "--plugins-dir",
        required=True,
        type=Path,
        help="Path to the plugins/ directory in this repo",
    )
    args = parser.parse_args()

    if not args.research_dir.exists():
        print(f"Error: research-dir not found: {args.research_dir}", file=sys.stderr)
        return 1
    if not args.plugins_dir.exists():
        print(f"Error: plugins-dir not found: {args.plugins_dir}", file=sys.stderr)
        return 1

    research_docs = _scan_research_dir(args.research_dir)
    plugins = _scan_plugins(args.plugins_dir)

    gaps = _find_gaps(research_docs, plugins)
    stale = _find_staleness(research_docs, plugins)
    suggestions = _suggest_plugins(gaps)

    report = _render_markdown(gaps, stale, suggestions)
    print(report)

    has_findings = bool(gaps or stale)
    return 1 if has_findings else 0


if __name__ == "__main__":
    sys.exit(main())
