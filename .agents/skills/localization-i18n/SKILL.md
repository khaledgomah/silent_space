---
name: localization-i18n
description: 'Review or add localization keys and setup multi-language support (easy_localization) in pages and widgets.'
argument-hint: 'Optional localization key or string to localize'
---

# Localization and Internationalization (i18n)

## When to Use
- When adding user-facing text, titles, button labels, error alerts, or hints to UI screens.
- When expanding multi-language support for Arabic (`ar`) and English (`en`).

## Principles

### 1. No Hardcoded Strings
- Do not write raw text in widgets like `Text('Welcome')`.
- All user-facing strings must be localized using `easy_localization`.

### 2. Synchronization of Translations
- When adding a translation key, define it in both English and Arabic files (located under `assets/translations/en.json` and `assets/translations/ar.json`).
- Ensure key names match exactly and use camelCase or snake_case consistently.

---

## Step-by-Step Procedure

### 1. Add Keys to Translation Files
Open `assets/translations/en.json`:
```json
{
  "welcomeTitle": "Welcome back",
  "loginButton": "Log In"
}
```
Open `assets/translations/ar.json`:
```json
{
  "welcomeTitle": "مرحباً بك مجدداً",
  "loginButton": "تسجيل الدخول"
}
```

### 2. Use Translation in Widget
Call `.tr()` on String keys:
```dart
Text('welcomeTitle'.tr())
```

### 3. Localization in Tests
Mock the localization context in tests or utilize mock string wrappers so widget tests don't fail due to missing context.
