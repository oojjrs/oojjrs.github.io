---
layout: page
lang: en
title: "Codex Common Work Guidelines"
alternate_url: /kr/codex/common-work-guidelines.html
category: "GUIDELINE"
description: "Shared operating rules for Codex work across projects. Project planning and art direction belong in each repository's Design.html; recurring work practices belong here."
permalink: /en/codex/common-work-guidelines.html
toc_items:
  - id: start
    label: "Start order"
  - id: approval
    label: "Approval boundary"
  - id: files
    label: "Files and Git"
  - id: documents
    label: "Document responsibility"
  - id: validation
    label: "Validation"
  - id: art
    label: "Art and UI"
  - id: reporting
    label: "Reporting"
---

[← Codex]({{ "/en/codex/" | relative_url }}) · [한국어]({{ "/kr/codex/common-work-guidelines.html" | relative_url }})
{: .article-backlink }

These guidelines collect operating rules that repeat across projects.
{: .article-lead }

## Start order {#start}

1. Prioritize the user's latest instruction and the active conversation scope.
2. If `Design.html` exists, read it before starting and also check the shared work-guideline link at the top.
3. Check documents needed for execution, such as `README.md`, build notes, or framework documentation.
4. Before editing, run `git status --short --branch` to understand the current branch and dirty worktree.

## Approval boundary {#approval}

Work that is hard to undo or changes external state proceeds immediately only when the immediately preceding conversation explicitly asked for it.
{: .article-principle }

**Proceed without extra approval:** general tasks already covered by custom instructions, code edits, document drafting, and local validation.

**Require an immediate explicit command:** `git push`, public deployment, permanent deletion, forced rollback, and document cleanup that cannot reasonably be restored to the previous content.

**Respect review mode:** when the user asks for review, comparison, or explanation, provide analysis and evidence first. Start implementation only when requested.

**Newest instruction wins:** if the user sends a new message while work is underway, the latest instruction takes priority over the existing plan.

## Files and Git {#files}

### Encoding and line endings

- Preserve the original encoding and line endings of existing text files.
- For new text files with no prior source, use UTF-8 No-BOM and CRLF.
- Windows PowerShell can display Korean text incorrectly, so verify through byte-level checks or explicit UTF-8 reads when needed.

### Dirty worktree

- Treat changes made by the user or another thread as intentional work.
- Do not revert unrelated changes or perform incidental style cleanup.
- If the requested work must touch a file that already has other changes, modify only the minimum requested area and preserve the existing work.

### Staging and commits

- Do not stage broadly with `git add -A` unless that exact scope is intended.
- Before committing, inspect `git diff --cached --name-status` and, where useful, `git diff --cached`.
- When multiple repositories are involved, commit each repository independently.
- Include `Design.html` and `DesignAssets` only when planning-document work was explicitly requested.

### GitHub Projects status

- For projects with a GitHub remote, derive `OWNER/REPO` from `origin` and check linked Projects with `gh repo view OWNER/REPO --json projectsV2`.
- When a repository has linked Projects, treat project-status maintenance as part of task execution: update the matching issue, pull request, or project item as work starts, changes state, or completes.
- If no Project is linked or no matching item is clear, do not invent or move items silently; note the skipped update or the mapping that needs confirmation in the work report.

## Document responsibility {#documents}

**Common work guidelines:** recurring operating rules, approval boundaries, Git rules, and validation principles are managed in this repository.

**Design.html:** project goals, planning intent, art style, UX standards, and decision rationale belong in the project document.

**Coding conventions:** language-specific style rules belong in separate convention documents. Project documents should link to them only when needed.

### Planning-document standard

- `Design.html` is not a conversation transcript. It preserves final decisions and the reasons behind them.
- If the implementation and planning document disagree after implementation, update the planning document to match the latest code and user intent.
- Temporary candidates, rejected drafts, comparison files, and intermediate artifacts should not remain in document asset folders unless the final document still references them.

## Validation {#validation}

- Run the practical validation commands whenever possible and report their result.
- For general text and documentation edits, check `git diff --check`, encoding, line endings, and trailing whitespace.
- For HTML documents, check fragile surfaces such as main anchors, links, image paths, queue markers, and collapsed-section counts.
- For Unity work, prefer real evidence: related `.meta` GUIDs, prefab YAML references, build results, and editor logs.
- If validation could not be run, state the reason plainly.

## Art and UI {#art}

- For new raster art, UI art, game assets, icon-like images, and visual references, the first visual-generation and first art-direction pass should use the imagegen workflow.
- UI work that has strict sizing is not an exception. Establish the art style, silhouette, material, mood, and overall quality through image generation first, then move into UI normalization.
- System.Drawing, PIL, ImageMagick, SVG, canvas, HTML/CSS, and procedural drawing are post-processing tools, not the first image-generation tool. Use them after an accepted generated image exists for resizing, cropping, padding, slicing, alpha cleanup, format conversion, state variants, nine-slice guides, or atlas packing.
- If the generated art style is wrong, regenerate through imagegen instead of trying to rescue it through code post-processing.
- Keep only assets referenced by the final or current document in `DesignAssets`.
- Do not duplicate runtime assets for documentation. Reference the actual project path when the runtime asset is the source of truth.

## Reporting {#reporting}

- Feedback and document writing are Korean by default.
- Final reports should briefly cover changed files, core changes, validation results, and remaining risk.
- For review requests, list findings first and place summaries afterward.
- Users cannot see full command output, so relay important results directly in the response.