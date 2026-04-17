# Feature Spec: Participant Limit Warning

## Title
Show a warning banner when a game approaches the maximum participant limit (100).

## Context
Games support up to 100 participants (enforced by `INPUT_LIMITS.MAX_PARTICIPANTS`). Organizers currently get a hard error when trying to add the 101st participant. A proactive warning at 90+ participants would improve the experience and prevent confusion.

## Requirements

### Functional
- [ ] Display a warning banner in the Organizer Panel when participant count reaches 90
- [ ] Banner text: "You're approaching the maximum of 100 participants"
- [ ] Banner disappears when a participant is removed (count drops below 90)
- [ ] Warning is informational only — does not block adding participants until 100

### Non-Functional
- [ ] Must work in all 9 supported languages
- [ ] Must be accessible (WCAG 2.0 AA) — use `role="alert"` for the banner
- [ ] Must be visible in both light and dark mode
- [ ] No API changes required (client-side only)

## Technical Design

### Affected Files
| File | Change Type | Description |
|------|-------------|-------------|
| `src/components/OrganizerPanelView.tsx` | Modified | Add warning banner when `participants.length >= 90` |
| `src/lib/translations/en.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/es.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/pt.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/fr.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/it.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/ja.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/zh.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/de.ts` | Modified | Add `participantLimitWarning` key |
| `src/lib/translations/nl.ts` | Modified | Add `participantLimitWarning` key |

### API Changes
None — this is a frontend-only change. The 100-participant limit is already enforced server-side.

### Database Changes
None.

## Acceptance Criteria
- [ ] Given a game with 89 participants, when the organizer views the panel, then no warning is shown
- [ ] Given a game with 90 participants, when the organizer views the panel, then a yellow warning banner is displayed
- [ ] Given a game with 90+ participants, when a participant is removed (count < 90), then the warning disappears
- [ ] Warning text is correctly translated in all 9 languages
- [ ] Warning is visible in dark mode with appropriate contrast

## Out of Scope
- Changing the 100-participant limit itself
- Adding a server-side warning in API responses
- Email notifications about participant limits

## Dependencies
None.
