---
name: proofread
description: Read-only proofreading pass over lecture `.tex` or `.qmd` files. Checks grammar, typos, overflow, terminology consistency, and academic writing quality; produces a report without editing. Use when user says "proofread", "check for typos", "look for grammar issues", "copy-edit this", "any writing errors?", or before a lecture release.
argument-hint: "[filename or 'all']"
allowed-tools: ["Read", "Grep", "Glob", "Write", "Agent", "Task"]
disallowed-tools: ["Edit", "MultiEdit"]
---

# Proofread Lecture Files

Run the proofreading protocol on lecture files. This produces a report of all issues found WITHOUT editing any source files.

## Steps

1. **Identify files to review:**
   - If `$ARGUMENTS` is a specific filename: review that file only
   - If `$ARGUMENTS` is "all": review all `.qmd` files in `rapport/`, `fiche/`, `slides/` and `tp/`

2. **For each file, launch the proofreader agent** that checks for:

   **GRAMMAR (French):** accords (sujet-verbe, participes passés, genre/nombre), prépositions, concordance des temps
   **TYPOS:** fautes d'orthographe, accents, typographie française (espaces insécables avant ; : ! ? et dans « »), mots doublés
   **OVERFLOW:** Overfull hbox (LaTeX), content exceeding slide boundaries (Quarto)
   **CONSISTENCY:** Citation format, notation, terminology
   **ACADEMIC QUALITY:** registre familier, mots manquants, tournures maladroites, affirmations sans citation. Write the report in French.

3. **Produce a detailed report** for each file listing every finding with:
   - Location (line number or slide title)
   - Current text (what's wrong)
   - Proposed fix (what it should be)
   - Category and severity

4. **Save each report** to `quality_reports/`:
   - For `.tex` files: `quality_reports/FILENAME_report.md`
   - For `.qmd` files: `quality_reports/FILENAME_qmd_report.md`

5. **Leave source files unchanged** — fixes are applied after the user reviews the report.
   Only produce the report. Fixes are applied separately after user review.

6. **Present summary** to the user:
   - Total issues found per file
   - Breakdown by category
   - Most critical issues highlighted
