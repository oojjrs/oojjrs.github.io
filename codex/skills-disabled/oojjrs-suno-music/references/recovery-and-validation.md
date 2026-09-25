# Recovery and Validation

Use this procedure for every credit-consuming action and whenever submission status is uncertain.

## State evidence

| State | Required evidence |
| --- | --- |
| idle | No configured action is awaiting submission |
| prepared | Required inputs are present and read back; final action not authorized or not yet ready |
| armed | Exact action, source, destination, settings, and visible cost were approved or explicitly requested |
| sent | Final action was clicked once in this run |
| active | A new placeholder, job indicator, disabled result, or stable new ID proves acceptance |
| complete | Every known result reached an authoritative ready or failed state |
| unresolved | The action may have been accepted, but current evidence cannot prove acceptance or rejection |

Never move backward from `sent` to `armed` automatically.

## Preflight

Before the final action:

1. verify signed-in account state without reading secrets;
2. verify the exact source tab and no conflicting active generation;
3. record current result IDs;
4. read back mode, model, source inputs, lyrics mode, prompt or lyrics, Styles, exclusions, sliders, duration, title, and Workspace;
5. verify Create or derivative action is enabled;
6. inspect visible credit, plan, rights, public, and result-count warnings;
7. verify that current authority covers the exact action. A request naming the exact file, Suno, and generation or Extend action already covers its required upload and one submission; do not ask again.

Perform the final click exactly once and never from inside a polling loop.

## Poll without duplicating

- Poll the cheapest authoritative surface: new stable IDs, placeholder state, Play enabled state, and alerts.
- Use bounded waits shorter than the communication interval. Send a concise progress update before a longer generation wait.
- Track results as a set keyed by ID. Do not use title alone because variants commonly share titles.
- Stop polling when every discovered result is ready or failed, the user interrupts, the browser disconnects, or evidence becomes ambiguous.

## Resolve uncertainty

If a click, response, tab, or extension is interrupted:

1. do not click again;
2. reacquire the Suno tab from current `cua.getState()` browser and tab IDs;
3. inspect alerts, active placeholders, newest Library entries, and the baseline difference;
4. wait once when the UI shows a credible active or delayed state;
5. mark `unresolved` if no authoritative evidence appears.

Block another paid generation while an earlier action remains unresolved unless the user explicitly accepts the duplicate-risk after seeing the evidence.

## Handle control failures

- If a semantic click has no effect, inspect expanded state, pointer events, overlays, enabled state, and fresh DOM before retargeting.
- Expand parent sections before clicking children.
- Prefer labels, roles, and state attributes. Use coordinates only from current visual evidence and only when semantic control is unavailable.
- After retargeting, verify a changed state. Do not repeat the same ineffective action blindly.
- If a required control disappeared after a Suno update, stop and report the missing capability instead of guessing a selector.

## Handle blockers

- **Sign-in or reauthentication**: Ask the user to complete it in the selected browser tab and report when ready.
- **CAPTCHA**: Follow the active CUA tool policy and hand control to the user when required; never bypass it.
- **Microphone, Voice, or identity check**: Obtain the exact confirmation or hand control to the user. For a file upload already authorized by an exact Suno generation request, do not repeat confirmation.
- **Insufficient credits or plan gate**: Report the displayed restriction. Do not buy or upgrade without explicit authority and transaction confirmation.
- **Rights, legal terms, or public-visibility warning**: Surface the actual UI requirement and follow the active tool policy; never infer an attestation from file selection alone.

## Validate the outcome

Use independent evidence appropriate to the action:

- generation: new stable song IDs plus playable or failed state;
- option setting: selected, checked, text, slider, and enabled values read from the final form;
- download: completed local file path, size, and extension;
- publish or visibility: final visible status on the song or Library item;
- rename, move, queue, or playlist: final item state keyed by song ID;
- Trash: item absence from the source view plus visible Trash state or confirmation, without assuming recoverability.

Do not use an implementation action and a toast produced by that same action as the only proof when a persistent state is available.
