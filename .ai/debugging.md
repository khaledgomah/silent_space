# Debugging Prompt

## Template
Use the /debugging-architecture + /architecture-review skills to debug:

- Error: {error_message}
- Scope: {file_or_feature}
- Expected behavior: {expected_behavior}
- Reproduction steps: {steps}

Tasks:
1. Identify root cause
2. Explain architectural impact
3. Apply minimal safe fix
4. Add or update tests
5. Verify with flutter analyze and flutter test

## Example
Use the /debugging-architecture + /architecture-review skills to debug:

- Error: Session list is empty after login
- Scope: lib/features/session
- Expected: sessions should load from remote then cache locally
- Repro: login -> home -> stats tab

## Checklist
- [ ] Root cause reproduced
- [ ] Fix aligns with clean architecture
- [ ] No new layer violations introduced
- [ ] Regression test added
- [ ] Analyzer and tests pass for changed scope
