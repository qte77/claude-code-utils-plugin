# Retrieval Patterns

Reference for document retrieval in RAG pipelines.

## PageIndex-Style Tree Construction

Build a hierarchical tree from document headings for structural filtering.

### TreeNode Structure

```python
@dataclass
class TreeNode:
    heading: str
    level: int          # 0=root, 1=H1, 2=H2, ...
    content: str        # text under this heading (before next heading)
    children: list[TreeNode]

    def filter(self, predicate: Callable[[TreeNode], bool]) -> TreeNode | None:
        """Return subtree where predicate matches, preserving ancestors."""
        filtered_children = [
            c for child in self.children
            if (c := child.filter(predicate)) is not None
        ]
        if predicate(self) or filtered_children:
            return TreeNode(
                heading=self.heading,
                level=self.level,
                content=self.content if predicate(self) else "",
                children=filtered_children,
            )
        return None
```

### Building the Tree

```python
def build_tree(pages: list[Page]) -> TreeNode:
    root = TreeNode(heading="root", level=0, content="", children=[])
    stack: list[TreeNode] = [root]

    for page in pages:
        for heading, level, content in parse_sections(page):
            node = TreeNode(heading=heading, level=level, content=content, children=[])
            # Pop stack to find parent (first node with lower level)
            while len(stack) > 1 and stack[-1].level >= level:
                stack.pop()
            stack[-1].children.append(node)
            stack.append(node)

    return root
```

### Tree Operations

| Operation | Description | Use Case |
|-----------|-------------|----------|
| `filter(predicate)` | Return matching subtree | Narrow results to relevant sections |
| `flatten()` | Return all leaf content | Full-text extraction |
| `path_to(node)` | Return heading ancestry | Source citations |
| `depth()` | Max tree depth | Complexity assessment |

## FAISS Vector Store

Use FAISS `IndexFlatIP` (inner product) with normalized vectors for cosine similarity.

### Setup

```python
import faiss
import numpy as np

dimension = 384  # all-MiniLM-L6-v2 output dimension
index = faiss.IndexFlatIP(dimension)
```

### Operations

```python
# Add vectors (must be L2-normalized for cosine similarity)
def add(vectors: np.ndarray) -> None:
    faiss.normalize_L2(vectors)
    index.add(vectors)

# Search top-k
def search(query_vector: np.ndarray, k: int = 10) -> tuple[np.ndarray, np.ndarray]:
    faiss.normalize_L2(query_vector)
    scores, indices = index.search(query_vector, k)
    return scores, indices

# Persist to disk
def save(path: str) -> None:
    faiss.write_index(index, path)

def load(path: str) -> faiss.IndexFlatIP:
    return faiss.read_index(path)
```

### Metadata Mapping

FAISS stores only vectors. Maintain a parallel metadata store:

```python
@dataclass
class ChunkMetadata:
    chunk_id: int
    page_number: int
    heading_path: list[str]
    content: str         # original text for display
    token_count: int
```

Store as JSON lines alongside the FAISS index:

```
index.faiss          # FAISS binary index
metadata.jsonl       # one JSON object per vector, same order
```

## Hybrid Retrieval Pipeline

Combines vector similarity search with structural tree filtering.

### Pipeline Steps

```
Query
  |
  v
1. Embed query (sentence-transformers)
  |
  v
2. Vector search (FAISS top-k, k=20)
  |
  v
3. Full page fetch (expand chunks to full pages)
  |
  v
4. Tree filter (PageIndex filter to relevant sections)
  |
  v
5. Rank and return (re-rank by relevance, return top-n)
```

### Step Details

**Step 1 -- Embed query**: Use the same model and normalization as indexing.

**Step 2 -- Vector search**: Retrieve `k` candidate chunks. Use `k > n` (over-fetch)
because tree filtering will narrow results.

**Step 3 -- Full page fetch**: For each matched chunk, retrieve the full page it
belongs to. This provides surrounding context that pure chunk retrieval misses.

**Step 4 -- Tree filter**: Build predicate from matched chunk heading paths. Filter
the PageIndex tree to retain only branches containing matches. This preserves
heading hierarchy while removing irrelevant sibling sections.

**Step 5 -- Rank and return**: Score filtered sections by:

- Original vector similarity score (from step 2)
- Heading depth penalty (deeper = more specific = higher priority)
- Deduplicate overlapping content

### Result Format

```python
@dataclass
class RetrievalResult:
    content: str
    score: float
    page_number: int
    heading_path: list[str]
    source: str           # document identifier
```

## Embedding Model Selection

| Model | Dimensions | Speed | Quality | Use Case |
|-------|-----------|-------|---------|----------|
| `all-MiniLM-L6-v2` | 384 | Fast | Good | Default, general purpose |
| `all-mpnet-base-v2` | 768 | Medium | Better | Higher quality needs |
| `bge-small-en-v1.5` | 384 | Fast | Good | Alternative to MiniLM |

Default to `all-MiniLM-L6-v2` unless quality requirements demand otherwise.
