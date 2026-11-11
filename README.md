# Writing with AI — Markdown + BibTeX + Pandoc Template

A small, reusable template for writing documents (papers, reports, extended
abstracts) in **Markdown**, managing citations in a **BibTeX** file, and
generating a **PDF** (or LaTeX) with **Pandoc**. You keep a single source of
truth in plain text; the PDF is always regenerated from it.

This README explains the setup step by step for **macOS** and **Windows**.

---

## 1. What is in this template

```
writing-with-ai/
├── README.md                 ← this file
├── .gitignore
├── document/
│   ├── paper.md              ← your text (edit this)
│   ├── references.bib        ← your bibliography (edit this)
│   └── numeric.csl           ← citation style (numbered [1], [2], …)
├── generated/                ← output goes here (paper.pdf)
└── scripts/
    ├── build.sh              ← build command for macOS / Linux
    └── build.ps1             ← build command for Windows (PowerShell)
```

- **`document/paper.md`** — your document. The block at the very top (between the
  `---` lines) is *metadata*: title, authors, page margins, font size. Below it
  comes your text.
- **`document/references.bib`** — your sources in BibTeX format. Each entry has a
  *key* (e.g. `glinz2015`) that you cite from the text.
- **`document/numeric.csl`** — the *citation style*. This one produces numbered
  citations like `[1]` and a matching numbered reference list. You can swap it
  for another style later (see section 7).
- **`generated/paper.pdf`** — the result. This folder is recreated on every build.

---

## 2. Install the tools

You need two things: **Pandoc** (converts Markdown to PDF) and a **LaTeX engine**
(Pandoc uses it internally to make the PDF). Install both once; after that you
only edit text and run the build command.

### macOS

The easiest way is [Homebrew](https://brew.sh/). Open the **Terminal** app and
run:

```sh
# 1. Install Homebrew (skip if you already have it)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install Pandoc
brew install pandoc

# 3. Install a LaTeX engine (BasicTeX is small; MacTeX is large but complete)
brew install --cask basictex
```

After installing BasicTeX, **close and reopen the Terminal** (so it finds the new
commands). If a build later complains about a missing LaTeX package, install it
with, for example, `sudo tlmgr install <packagename>`.

### Windows

Install each tool with its official installer:

1. **Pandoc** — download the `.msi` installer from
   <https://pandoc.org/installing.html> and run it.
2. **MiKTeX** (the LaTeX engine) — download from <https://miktex.org/download>
   and run the installer. During setup, choose **"Install missing packages on the
   fly: Yes"** so MiKTeX fetches what it needs automatically.

Alternatively, if you use the **winget** package manager (built into Windows 11):

```powershell
winget install --id JohnMacFarlane.Pandoc
winget install --id MiKTeX.MiKTeX
```

After installing, **close and reopen PowerShell** so it finds the new commands.

### Check that it worked (both systems)

```sh
pandoc --version
```

You should see a version number (e.g. `pandoc 3.x`). If the command is "not
found", the tool is not on your PATH — reopen your terminal, or re-run the
installer.

---

## 3. Generate the PDF

Open a terminal **in the project folder** (the folder that contains this
`README.md`).

### macOS

```sh
# First time only: make the script executable
chmod +x scripts/build.sh

# Build the PDF
./scripts/build.sh
```

### Windows (PowerShell)

```powershell
.\scripts\build.ps1
```

> If Windows blocks the script with a message about the *execution policy*, allow
> local scripts for the current session and try again:
>
> ```powershell
> Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
> .\scripts\build.ps1
> ```

In both cases the result is **`generated/paper.pdf`**. Open it to check the
output.

### Prefer the raw command?

The scripts just wrap a single Pandoc command. You can run it directly from the
project root instead:

```sh
pandoc document/paper.md -s --citeproc --csl=document/numeric.csl \
  --bibliography=document/references.bib -o generated/paper.pdf
```

On Windows PowerShell, use a backtick (`` ` ``) for line continuation, or write
it all on one line.

---

## 4. The normal writing loop

1. Edit `document/paper.md` (your text).
2. Add sources to `document/references.bib` when you need them.
3. Cite them in the text (see section 5).
4. Run the build command (section 3).
5. Open `generated/paper.pdf`.
6. Repeat.

> **Common pitfall:** if the PDF viewer has the file open, the build may fail to
> overwrite it. Close the PDF, then build again.

---

## 5. How to cite sources

Each BibTeX entry has a key — the first word after the `{`:

```bibtex
@article{glinz2015,
  author  = {Glinz, Martin and Fricker, Samuel A.},
  title   = {On Shared Understanding in Software Engineering: An Essay},
  journal = {Computer Science -- Research and Development},
  year    = {2015}
}
```

Here the key is `glinz2015`. In `paper.md` you cite it like this:

| You write          | You get (with the numeric style) |
|--------------------|----------------------------------|
| `[@glinz2015]`     | `[1]`                            |
| `[@a; @b]`         | `[1, 2]`                         |
| `[-@glinz2015]`    | `[1]` but **without** the author name appearing (useful mid-sentence) |

Pandoc automatically:

- numbers the citations in order of first appearance,
- builds the reference list under the `# References` heading at the bottom,
- includes **only** the sources you actually cited.

Where do BibTeX entries come from? Most tools give you BibTeX directly:
Google Scholar (the **"Cite"** link → **BibTeX**), publisher pages, DOI services
(e.g. <https://doi.org>), and reference managers like **Zotero** or **JabRef**.
Copy the entry into `references.bib` and cite its key.

---

## 6. Editing the metadata (title, authors, margins)

The top of `paper.md` controls the front matter:

```yaml
---
title: Writing with AI --- A Markdown + BibTeX + Pandoc Template
author:
  - "Your Name (Your Institution)\\\nCo-Author (Another Institution)"
date: "Draft · fill in venue or date"
geometry: margin=2.5cm
fontsize: 11pt
lang: en
---
```

- **Multiple authors on separate lines:** keep them in one quoted string and
  separate them with `\\` followed by `\n`, exactly as shown (`...Institution)\\\nCo-Author...`).
  The default LaTeX template otherwise places authors side by side.
- **`geometry: margin=2.5cm`** — page margins. Use e.g. `margin=2cm` for wider text.
- **`fontsize: 11pt`** — body font size (`10pt`, `11pt`, or `12pt`).
- **`lang: en`** — document language; use `de` for German hyphenation.

---

## 7. Optional: change the citation style

`numeric.csl` gives numbered citations. To use a different style (APA, IEEE,
Chicago, a specific journal, …):

1. Download the matching `.csl` file from the
   [Citation Style Language repository](https://github.com/citation-style-language/styles)
   or the [Zotero Style Repository](https://www.zotero.org/styles).
2. Put it in the `document/` folder.
3. Point the build at it — either edit the `CSL`/`$Csl` line in the build script,
   or change `--csl=document/numeric.csl` in the raw command.

---

## 8. Optional: produce LaTeX instead of PDF

To get a `.tex` file (for Overleaf or a LaTeX toolchain) instead of a PDF:

```sh
# macOS
./scripts/build.sh tex
```

```powershell
# Windows
.\scripts\build.ps1 tex
```

The output is `generated/paper.tex`.

---

## 9. Troubleshooting

| Symptom | Likely cause and fix |
|---------|----------------------|
| `pandoc: command not found` / `not recognized` | Pandoc not installed or not on PATH. Reopen the terminal; re-run the installer (section 2). |
| `pdflatex not found` / `xelatex not found` | No LaTeX engine. Install BasicTeX/MacTeX (macOS) or MiKTeX (Windows). |
| Citations appear as literal `[@key]` in the PDF | The `--citeproc` flag is missing, or the key is not in `references.bib`. Use the build script, which includes it. |
| A reference is missing from the list | You did not cite it. Pandoc only lists cited sources. |
| Build fails to overwrite `paper.pdf` | The PDF is open in a viewer. Close it and rebuild. |
| Windows: "running scripts is disabled" | Run `Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass` first (section 3). |
| MiKTeX pauses asking to install a package | Choose "Install", or enable install-on-the-fly in the MiKTeX Console. |

---

## 10. Quick reference

```
Edit:   document/paper.md   and   document/references.bib
Build:  ./scripts/build.sh          (macOS)
        .\scripts\build.ps1         (Windows)
Result: generated/paper.pdf
```
