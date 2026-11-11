# AGENTS.md

Guidance for AI agents working in this repository. Read this before editing any
file. The goal of this project is a single plain-text source of truth that
compiles to a PDF via Pandoc. Keep that pipeline intact.

## What this project is

A **Markdown + BibTeX + Pandoc** writing template for scholarly articles. You
write prose in Markdown, keep citations in BibTeX, and generate the PDF with a
build script. The Markdown and BibTeX files are the source of truth — never
hand-edit the PDF.

## Where things live

| Path                       | Role                                                        |
|----------------------------|-------------------------------------------------------------|
| `document/paper.md`        | The document: YAML front matter + Markdown body. **Edit this.** |
| `document/references.bib`  | Bibliography in BibTeX. **Edit this** to add sources.       |
| `document/numeric.csl`     | Citation style (numbered `[1]`, `[2]`, …). Do not edit unless changing style. |
| `generated/paper.pdf`      | Build output. **Generated — never edit by hand.**           |
| `scripts/build.sh`         | Build command for macOS/Linux.                              |
| `scripts/build.ps1`        | Build command for Windows (PowerShell).                     |
| `decision-log.md`          | Record of decisions made with the author (see below).      |
| `README.md`                | Human-facing setup, install, and usage instructions.        |

## How to build

Run the build script from the project root — `./scripts/build.sh` (add `tex` to
produce `paper.tex` for inspection). The README documents the required tools and
the underlying command; do not restate them here. After any content change,
rebuild, confirm it exits 0 with no Pandoc "unresolved citation" warnings, and
delete any inspection-only `.tex` file — the only tracked build artifact is
`generated/paper.pdf`.

## How to collaborate: co-creation, not ghost-writing

This repository is for writing scholarly articles. The human is the author and
owns every decision; the agent assists, gives feedback, and co-creates **only
with explicit approval**. Treat all agent output as proposals and findings, not
as finished text.

### Put every significant decision to the author (most important rule)

Do not silently make substantive choices — outline/structure, scope, method,
argumentation line, which sources to use, or any change that alters meaning.
Instead present each significant decision **one at a time** in this shape and
then **wait for explicit approval before acting**:

1. **Context** — the question and the concrete passages/requirements it concerns.
2. **Options** — the viable alternatives, each with pros and cons.
3. **Recommendation** — a reasoned suggestion, including open uncertainties.
4. **Decision** — leave this to the author; do not assume it.
5. **Record** — once decided, add it to the decision log (see below).

Small, non-substantive edits (typos, formatting that does not change meaning,
build fixes) do not need this ceremony. When in doubt, ask.

### Never invent facts, numbers, or sources

- Do not add any citation, DOI, figure, statistic, quotation, or claim you have
  not verified. Fabricated or unverified content is the most serious failure
  mode here.
- Mark anything unknown or unconfirmed as an **open question** rather than
  filling it in. Do not guess bibliographic metadata.

### Verify sources before citing them

Before adding or citing any entry in `references.bib`, check:

- **Existence** — the publication actually exists.
- **Metadata** — author(s), year, title, venue, and DOI/URL are correct.
- **Support** — a passage you have actually read supports the claim it backs.
- **Consistency** — in-text citations and reference-list entries match.

Flag any source you could not fully verify instead of presenting it as checked.

### Preserve meaning when reformatting or copy-editing

When formatting (e.g. to Markdown) or smoothing language, do **not** change
facts, numbers, sources, or scientific hedging/qualifications. Report any change
that could alter meaning separately instead of applying it silently.

### Reviewing a chapter or section

When asked to review, give a qualitative assessment grounded in specific
passages **plus** a 1–10 score per criterion — argumentation, scientific depth,
structure, use of sources, clarity — then the three highest-priority
improvements, and flag any unverified sources. A useful output shape per finding:
**location → observation → consequence → question for the author**.

### Keep a decision log

Record **every decision the author and the AI made together** in
`decision-log.md` in the project root, so the work stays traceable. Create the
file if it does not exist, and append a row whenever a decision is approved.
Record four fields per decision:

- **Chapter** — the chapter/section the decision concerns.
- **Question / Problem** — what was being decided and why.
- **Decision** — what the author chose.
- **Rationale** — the actual reasoning behind it.

```markdown
# Decision Log

| Chapter | Question / Problem | Decision | Rationale |
|---------|--------------------|----------|-----------|
| Method  | Explain method before or after data collection? | Before | Early rationale improves traceability |
```

Write the log in the same language as the article (see the `lang` convention
below). Do not invent rationales; mark missing information. If the author uses
this work as an assessed submission, note that use of AI assistance may need to
be disclosed per the applicable rules.

## Writing conventions

- **Keep the YAML front matter at the very top** of `paper.md` (between the `---`
  lines). It controls `title`, `author`, `date`, `geometry` (margins),
  `fontsize`, `lang`, and the Pandoc rendering options (`toc`, `toc-title`,
  `numbersections`). Do not remove it. Change behaviour here rather than in the
  build script.
- **Keep `# References` as the last heading** in the body, and leave it empty —
  citeproc fills it. It is intentionally not numbered; Pandoc marks the
  bibliography heading as unnumbered automatically, so do not force a number on it.
- **Headings:** `#` top level, `##` subsections, etc. One blank line between
  paragraphs.
- **Multiple authors:** keep them in one quoted string separated by `\\` then
  `\n`, e.g. `"First Author (Inst.)\\\nSecond Author (Inst.)"`. Otherwise LaTeX
  places them side by side.
- **Language (`lang`):** `en` for English, `de` for German hyphenation. Match the
  language the text is actually written in; the decision log follows the same
  language.
- Use standard Markdown for emphasis (`*italics*`, `**bold**`) and lists. Do not
  introduce raw LaTeX unless there is no Markdown equivalent.

## Citation conventions

- Add every source to `references.bib`, then cite it in `paper.md` with Pandoc
  syntax: single `[@key]`, multiple `[@key1; @key2]`. (The author-suppressing
  `[-@key]` has no visible effect with the numeric style, so prefer `[@key]`.)
- The numeric style (`numeric.csl`) renders citations as `[1]`, `[2]`, … numbered
  by first appearance; only cited sources appear in the reference list.
- **Key naming:** lowercase `authorYYYY` or `authorYYYYkeyword`
  (e.g. `vanheesch2026`, `theunissen2022mapping`). Keep keys unique and descriptive.
- **BibTeX form:** prefer entries with a `doi` (or `url` when no DOI exists); for
  arXiv preprints the DOI is `10.48550/arXiv.<id>`. Write names with particles in
  `Last, First` form (e.g. `van Heesch, Uwe`) so they sort correctly. Verify all
  metadata (see source verification above) — never fabricate it.

## Consistency checks before finishing

1. Every `[@key]` cited in `paper.md` has a matching entry in `references.bib`,
   with no orphan entries. (The literal `` `[@key]` `` in the template's
   explanatory prose is documentation, not a real citation.)
2. The build succeeds (see "How to build") and `generated/paper.pdf` was
   regenerated from the current source.
3. Any decision that needed the author's approval is reflected in `decision-log.md`.

## Git conventions

- Only commit when the user explicitly asks.
- Stage specific files by name rather than `git add -A`.
- Do not force-push or rewrite published history. Amend only when the user asks
  and the commit has not been pushed.
