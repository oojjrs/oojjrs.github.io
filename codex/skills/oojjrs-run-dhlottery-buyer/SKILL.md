---
name: oojjrs-run-dhlottery-buyer
description: Run and manage the local UI-driven DHLottery helper in H:\연금복권 for Lotto 6/45 and Pension Lottery 720+. Use when the user asks Codex to prepare, dry-run, or explicitly execute a lottery purchase, inspect its local configuration, publish it, or configure its randomized interactive schedule.
---

# Run DHLottery Buyer

Use the local application at `H:\연금복권`. It controls only the official
DHLottery web UI and always keeps final purchase authority with the user.

## Safety Boundary

- Never ask the user to send an ID or password in chat.
- Never inspect or expose browser cookies, session storage, profile data, or the
  Windows Credential Manager secret.
- Never reproduce or call the site's internal purchase endpoints directly.
- Never bypass the application's exact local `구매` confirmation.
- Treat prior intent, standing permission, or a previous purchase as
  insufficient confirmation for a new transaction.
- If the user says a product was already purchased for the current round, do
  not launch that product again.
- Once a final confirmation click may have occurred, never retry an unknown,
  partial, or failed-looking result. Tell the user to check purchase history.
- Do not install, update, or run a scheduled task unless the user explicitly
  asks for that scheduling action.

## Local Entry Points

- Buyer: `H:\연금복권\scripts\Buy-Lottery.ps1`
- Publisher: `H:\연금복권\scripts\Publish.ps1`
- Randomized interactive schedule:
  `H:\연금복권\scripts\Install-ScheduledTask.ps1`

Supported scopes are `Both`, `Lotto`, and `Pension`.

## Prepare or Dry-Run

Use a dry-run unless the user explicitly asks to make a real purchase.

```powershell
powershell -ExecutionPolicy Bypass -File "H:\연금복권\scripts\Buy-Lottery.ps1" -Scope Both -DryRun
```

The application must report the verified round, tickets, count, and amount. A
dry-run must never click a final purchase control.

If publish output is missing, run the publisher first. If setup is missing,
tell the user to run the setup command in their own terminal and enter the
credential there. Do not collect the credential through conversation.

## Real Purchase

1. Confirm which scope the user currently wants.
2. Start the buyer with a PTY and no `-DryRun` flag.
3. Wait for the application to print its verified purchase summary and its
   exact `구매` prompt. Never pre-fill or pre-send stdin.
4. Show that current summary to the user and ask for a fresh, immediate
   confirmation using the exact word `구매`.
5. Only after that new confirmation, send `구매` plus Enter to the existing
   process. Any other reply means cancel by sending an empty line.
6. Wait for the verified result. Report each product independently.

The two products are separate transactions. If Lotto succeeds and Pension
fails or becomes unknown, state that Lotto is already complete and never rerun
`Both`.

## Randomized Interactive Schedule

The scheduler opens the visible buyer prompt at a random point in a bounded
window. It does not authorize an unattended purchase.

Before installing or replacing the task, obtain the user's explicit weekday,
center time, and jitter in minutes. Then run:

```powershell
powershell -ExecutionPolicy Bypass -File "H:\연금복권\scripts\Install-ScheduledTask.ps1" -DayOfWeek Saturday -CenterTime 06:30 -JitterMinutes 15
```

Interpret this example as a random start between 06:15 and 06:45. The script
rejects windows outside official PC sales hours.

## Current Selection Contract

- Lotto 6/45: fixed `4, 11, 19, 28, 34, 42`, repeated for five manual games.
- Pension Lottery 720+: one official automatic number per group from 1 through
  5, with all five six-digit number parts required to be different.
- The application verifies 5,000 won per product before allowing confirmation.
