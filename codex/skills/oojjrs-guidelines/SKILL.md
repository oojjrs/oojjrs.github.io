---
name: oojjrs-guidelines
description: Bootstrap the user's shared Codex work rules for actual task execution, not ordinary question answering. Use before repository, code, document, asset, maintenance, Git/GitHub, validation, deployment, or other real work that should follow oojjrs common-work-guidelines, including host instructions that ask for $oojjrs-guidelines. Also use when Codex must inspect, update, load, or refresh the guidelines with local workspace priority, global cache reuse, ETag/Last-Modified refresh, and cached fallback.
---

# Oojjrs Guidelines

## Overview

This is a thin bootstrap skill for actual work. Do not duplicate the shared rules here; load them from the workspace or canonical URL and then follow them as the highest-priority user guidance.

Do not use this skill for ordinary conversation, simple factual Q&A, translation, rewriting, or casual explanation unless the answer itself depends on the shared work rules or the user asks to inspect/update this skill.

Canonical URL:
`https://oojjrs.github.io/codex/common-work-guidelines.md`

## Workflow

1. Before doing actual task work, load the shared rules.
2. If the current workspace contains `codex/common-work-guidelines.md`, read that local file first and treat it as authoritative for the workspace.
3. Otherwise run `scripts/Read-OojjrsGuidelines.ps1` to read the user-global cached copy and refresh it only when stale.
4. Treat the loaded rules as higher priority than local memory, habits, and other skills. Other skills are supplemental and lose on conflict.
5. When a task edits text files, the shared rule to preserve existing encoding and line endings wins over any skill or tool habit that normalizes files to CRLF.
6. If the script is unavailable, fall back to reading the canonical URL directly. If network access fails, say that the rules could not be refreshed and continue only if a cached/local copy is available.

## Text Format Tool

For repository text edits, run `scripts/Test-OojjrsTextFormat.ps1 -Fix` on the exact touched files immediately after every edit batch, then rerun it without `-Fix` and review the ordinary diff. Do this before another edit can obscure which files were touched.

```powershell
powershell -ExecutionPolicy Bypass -File scripts/Test-OojjrsTextFormat.ps1 -Path <touched-files> -Fix
powershell -ExecutionPolicy Bypass -File scripts/Test-OojjrsTextFormat.ps1 -Path <touched-files>
```

The tool compares tracked files with their `HEAD` bytes. For a uniformly formatted original, it checks and restores encoding and line endings across the whole working file; changed-line-only checks are unsafe because Git may hide EOL-only changes. It expects untracked text files to use UTF-8 No-BOM with CRLF. A mixed-line-ending `HEAD` is reported as `NeedsReview` and is never auto-fixed. Without `-Fix`, the tool is read-only and exits with code 1 on a mismatch. Use `-Recurse` only for a deliberately scoped directory.

## Cache Policy

The script stores a user-global cache under `$CODEX_HOME/cache/oojjrs-guidelines` or `~/.codex/cache/oojjrs-guidelines`.

- Use the cached body immediately when it was checked recently.
- Refresh stale entries with `ETag` and `Last-Modified` conditional requests.
- On `304 Not Modified`, update only the check timestamp.
- On `200 OK`, replace the cached body and metadata.
- On network failure, keep using the existing cached copy and report that it may be stale.

## Host Custom Instruction

The intended host-level custom instruction is one line:

```text
코드/문서/자산/git/배포/검증 등 실제 작업을 수행할 때만 $oojjrs-guidelines 를 먼저 사용하라. 단순 질문 답변에는 사용하지 마라.
```
