# Chunking Strategies

Reference for document chunking in RAG pipelines.

## Heading-Boundary Chunking (Primary)

Split documents at heading boundaries to preserve semantic coherence.

### Algorithm

1. Parse document into a flat list of sections (heading + body)
2. Walk sections top-down; each heading starts a new chunk
3. Attach heading hierarchy as metadata (`H1 > H2 > H3`)
4. If section body exceeds `max_tokens`, apply max-token split (below)

### Heading Detection

```python
HEADING_PATTERN = re.compile(r"^(#{1,6})\s+(.+)$", re.MULTILINE)
```

For non-Markdown sources, map structural elements to heading levels:

| Source | H1 | H2 | H3+ |
|--------|----|----|-----|
| Markdown | `#` | `##` | `###`-`######` |
| HTML | `<h1>` | `<h2>` | `<h3>`-`<h6>` |
| PDF (parsed) | Large bold text | Section headers | Sub-headers |

### Metadata Preservation

Each chunk carries its heading path:

```python
@dataclass
class Chunk:
    content: str
    heading_path: list[str]  # ["Introduction", "Background", "Prior Work"]
    page_number: int | None
    token_count: int
```

## Max-Token Splits (Fallback)

When a single section exceeds the token budget, split further.

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `max_tokens` | 512 | Maximum tokens per chunk |
| `overlap_tokens` | 64 | Overlap between consecutive splits |
| `min_chunk_tokens` | 32 | Minimum viable chunk size |

### Algorithm

1. Tokenize section content
2. If `token_count <= max_tokens`, emit as single chunk
3. Otherwise, find sentence boundaries within the token window
4. Split at the last sentence boundary before `max_tokens`
5. Start next chunk `overlap_tokens` before the split point
6. Repeat until content exhausted
7. If final chunk < `min_chunk_tokens`, merge with previous

### Sentence Boundary Detection

```python
SENTENCE_END = re.compile(r"(?<=[.!?])\s+(?=[A-Z])")
```

Never split:

- Mid-sentence
- Inside code blocks (fenced or indented)
- Inside tables

## Token Counting

Use the embedding model's tokenizer for accurate counts:

```python
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("all-MiniLM-L6-v2")
tokenizer = model.tokenizer

def count_tokens(text: str) -> int:
    return len(tokenizer.encode(text, add_special_tokens=False))
```

## Anti-Patterns

- **Fixed-size character splits**: Ignores semantic boundaries, breaks mid-word
- **Paragraph-only splits**: Paragraphs vary wildly in size
- **No overlap**: Loses context at boundaries
- **Splitting code blocks**: Breaks syntax, makes chunks unusable
