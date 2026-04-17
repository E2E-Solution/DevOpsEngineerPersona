---
mode: agent
description: Add a new translation key to all 9 language files
---

# Add Translation Key

Add a new translation key to all 9 language files in `src/lib/translations/`.

## Rules

- **All 9 files must be updated simultaneously**: en.ts, es.ts, pt.ts, fr.ts, it.ts, ja.ts, zh.ts, de.ts, nl.ts
- English (`en.ts`) is the source of truth for key naming
- Keys use camelCase (e.g., `participantLimitWarning`)
- Translations must be natural and culturally appropriate — not word-for-word machine translations
- Keep translations concise — UI space is limited on mobile
- Don't translate brand names ("Zava Gift Exchange")
- Use informal register for Spanish (tú) and Portuguese (você)
- Use formal register for Japanese and German

## Steps

1. Read `src/lib/translations/en.ts` to understand the existing key naming conventions
2. Determine where in the file the new key should be added (group with related keys)
3. Add the key with appropriate translations to all 9 files
4. Verify the app builds: `npm run build`

## Usage in Components
```typescript
const { t } = useLanguage()
return <p>{t('yourNewKey')}</p>
```
