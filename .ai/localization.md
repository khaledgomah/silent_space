# Localization Prompt

## Template
Use the /localization-i18n + /architecture-review skills for {feature_name}.

Requirements:
- Add string keys to AppStrings.
- Add translations in assets/translations/en.json and ar.json.
- Replace hardcoded UI strings with .tr() lookups.
- Verify RTL and layout behavior for Arabic.
- Add tests for visible localized labels where practical.

## Example
Use the /localization-i18n + /architecture-review skills for auth forms.

- Add keys for forgot/reset password flows
- Ensure all labels and validation messages are localized
- Verify Arabic text direction and spacing

## Checklist
- [ ] No new hardcoded user-facing strings
- [ ] All keys exist in both en and ar
- [ ] AppStrings constants match translation keys
- [ ] RTL is visually correct
- [ ] Fallback locale remains valid
