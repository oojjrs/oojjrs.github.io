---
layout: page
lang: en
title: "Codex Common Work Guidelines"
alternate_url: /kr/codex/common-work-guidelines/
category: "GUIDELINE"
description: "Human-readable shared work guidelines. The recurring agent reference lives in raw Markdown."
permalink: /en/codex/common-work-guidelines.html
---

[← Codex]({{ "/en/codex/" | relative_url }}) · [한국어]({{ "/kr/codex/common-work-guidelines/" | relative_url }})
{: .article-backlink }

Human-readable guidelines. The minimal recurring agent source is [`/codex/common-work-guidelines.md`]({{ "/codex/common-work-guidelines.md" | relative_url }}).
{: .article-lead }

1. Follow the user's latest instruction and current scope.
2. If `Design.html` exists, read it before work and update it only when needed.
3. Proceed immediately on ordinary work covered by custom instructions.
4. Change external or hard-to-undo state only with an immediately preceding explicit command: `git push`, deployment, permanent deletion, forced rollback, or unrecoverable document cleanup.
5. Preserve existing user or other-thread changes; do not revert or clean unrelated files.
6. Preserve existing text encoding and line endings. New text files use UTF-8 No-BOM + CRLF.
7. Stage and commit only the requested scope. Push only when explicitly asked.
8. Run practical validation commands when possible and report key results.
9. Write feedback and documents in Korean by default.
