# Codex work memory — oojjrs.github.io

## 2026-11-01 Asia/Seoul — durable project work memory rules

Current task: add a Codex-only project work memory exception to public document rules and skill sources. This is a local content edit. No staging, commit, push, publication, or installed-skill refresh has been requested.

User intent:
- Design.html is for the user and must contain polished, minimal content.
- Preserve user statements, corrections, all decisions and rationale, proposals/rejected alternatives, work history, evidence, unresolved questions, and next actions in a separate file for Codex.
- The user does not intend to read this file. Format, language, and length are at Codex's discretion.
- $Trash alone cannot preserve context across work PCs.
- Memory content must never flow into Design.html without strict separate approval of exact wording and placement. Approval is presumed unlikely.
- The user approved adjusting conflicting rules autonomously and corrected the proposed storage wording: not all projects use Git; memory must work without a repository. Repository inclusion is optional, and Codex may propose it when appropriate.

Original user request:
> 문서 작성 규칙에 추가하자. Design.html은 내가 보는 거고, 굉장히 정제된 내용이 들어가야하는 건 맞는데, 그렇게 하니까 메모리도 안 쓰는데 아무래도 네가 작업하기 너무 힘들어하는 것 같아서, 네가 볼 수 있는 작업 메모리 파일을 하나 만들까 해. trash에 넣으라고 하는 것도 작업pc가 바뀌면 한계가 있으니까, 너만을 위한.. md파일이든 txt든 포맷도 상관없고, 영문이든 한글이든 니 맘대로 작성되는 정도면 충분하거든? (어차피 난 절대 안 열어볼거야) 커밋도 Design.html 할 때 같이 해도 되는 형태로. 모든 의사 결정, 내가 했던 말, 뭐 네가 좋아하는 주절주절 붙이는 설명들, 전부, 기록하는 용도로 쓰라고 문서 작성 규칙에 추가해놓고, 대신 거기 있는 내용을 Design.html에 기록하려면 엄격하게 나의 심사가 필요한 형태지. (뭐 당연히 지금까지의 규칙을 보면 알겠지만 허가 안할거야) 널 위해 추가하는 파일인 거야.
> 지침과 스킬에 추가해볼까?

User correction after the exact wording/location proposal:
> 이와 대치되는 내용은 네가 알아서 수정하되, 모든 프로젝트가 깃에 올라가는 것은 아니므로 깃이라고 표현하는건 부적절하고, 필요시 저장소에 올릴 순 있어. (네가 상황을 보고 제안해도 좋고)

Decisions:
- Use one project-root CodexWorkMemory.md, outside disposable $Trash; this file is a working record, not an instruction/approval authority.
- Read it at project-task start/resumption and update it throughout work.
- Exempt this file from wording preapproval, five-line limits, and bans on explanations or work history.
- Preserve existing history; distinguish current facts, past records and inference.
- Repository use is optional; including memory with related changes requires the relevant repository/publication authorization.
- Keep durable task checklists in memory so resumption does not depend on a local $Trash plan file.
- Keep Design.html's exact-wording approval gate. Decision agreement and a memory record do not grant document-writing or execution permission.

Repository evidence before this task's writes:
- Dedicated checkout: H:\oojjrs.github.io; origin: https://github.com/oojjrs/oojjrs.github.io.git.
- Pre-existing protected changes: codex/skills/oojjrs-ai-music-generator/SKILL.md and codex/skills/oojjrs-ai-music-generator/agents/openai.yaml. Leave untouched.
- Repository-linked GitHub Projects probe returned no boards. No board changes were made.
- The document rules previously required convenience records only in $Trash and prohibited project work memory. These clauses conflict directly with the new user request.
- Practical rules previously placed the only checklist in $Trash; Design rules also excluded all work records from commits. Adjust their memory-specific handling.
- Primary domain: oojjrs-skill-maintenance; oojjrs-guidelines loaded the canonical public common rules once. No new standalone skill is needed.
- Canonical rule and installed-skill publication remain separate from these local source edits.

Pending verification:
- Inspect the scoped diff and changed-file encoding/line endings once.
- Confirm the new memory file is available as ordinary project content and no protected music-skill files changed.
- Leave local changes unstaged and uncommitted for review.

## Local finish evidence

- Completed local edits: document-writing rule 4/5 and scope exception; common rules 4/5/8; Design decision/work-record separation; practical decisions/checklist/resumption; core skill and default prompt; focused Design router and Design builder.
- Source format checks and scoped whitespace checks passed.
- The changed YAML default_prompt quoted value parses and includes memory routing.
- Both pre-existing protected music-skill files retain their pre-edit SHA-256 hashes.
- CodexWorkMemory.md is not ignored by this repository.
- Changes remain unstaged and uncommitted. No remote publication or installed-skill refresh occurred; future sessions on other machines require the normal authorized publication/full-set installation path.
- The final closing command checks this memory file's UTF-8/CRLF format and prints the final scoped diff/status. If it reports a problem, that result supersedes this local record.

## 2026-11-01 — authorized publication follow-up

Latest user instruction:
> 이번 변경만 커밋하고 푸시한 다음, 스킬 설치본도 동기화해줘.

This instruction supersedes the earlier local-only finish state. It authorizes committing and pushing this task's nine paths, then synchronizing the entire active managed skill set from that pushed immutable commit.
- Initiating checkout: H:\oojjrs.github.io; local branch master; dedicated remote origin https://github.com/oojjrs/oojjrs.github.io.git.
- Exact origin/master fetch before publication resolved to 870462101b7e37c58c0fcfdb2cc4f41c3dea2974, equal to local HEAD. No branch integration or dirty-state preservation move was needed.
- Keep the two pre-existing music-generator source edits excluded from staging and preserve their bytes.
- Commit subject: 프로젝트 작업 메모리 규칙 추가.
- After push, read back origin/master and require equality with the initiating checkout's committed tip.
- Download and verify codex/skills/install.ps1 from the pushed commit, then run its complete active-set synchronization into D:\.codex\skills. Matching files remain untouched; only changed or missing files transfer.
- Do not append content after freezing this commit's scope. The resulting commit, remote-readback and installer counts will be in this task's closing tool results and final reply; read current Git and installed state when resuming.
