---
name: oojjrs-guidelines
description: Load the user's shared Codex work rules before any task. Use when the user says to use $oojjrs-guidelines, when a host custom instruction points to this skill, or when Codex needs the current oojjrs common-work-guidelines with local workspace priority, global cache reuse, ETag/Last-Modified refresh, and fallback to the cached copy if the network is unavailable.
---

# Oojjrs Guidelines

## Overview

This is a thin bootstrap skill. Do not duplicate the shared rules here; load them from the workspace or canonical URL and then follow them as the highest-priority user guidance.

Canonical URL:
`https://oojjrs.github.io/codex/common-work-guidelines.md`

## Workflow

1. Before doing task work, load the shared rules.
2. If the current workspace contains `codex/common-work-guidelines.md`, read that local file first and treat it as authoritative for the workspace.
3. Otherwise run `scripts/Read-OojjrsGuidelines.ps1` to read the user-global cached copy and refresh it only when stale.
4. Treat the loaded rules as higher priority than local memory, habits, and other skills. Other skills are supplemental and lose on conflict.
5. If the script is unavailable, fall back to reading the canonical URL directly. If network access fails, say that the rules could not be refreshed and continue only if a cached/local copy is available.

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
모든 작업에서 $oojjrs-guidelines 를 먼저 사용하라.
```
