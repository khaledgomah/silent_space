# Architecture Review Prompt

## Template
Use the /architecture-review skill to audit {target_scope}.

Review requirements:
- Validate clean architecture boundaries (domain -> data -> presentation).
- Detect layer leaks, direct data source usage in UI, or business logic in widgets.
- Validate repository contracts, use case structure, and failure mapping.
- Validate DI registrations for new/changed classes.
- Report issues by severity with file paths and exact fixes.

Output:
1. Critical issues
2. Major issues
3. Medium issues
4. Suggested refactoring plan

## Example
Use the /architecture-review skill to audit lib/features/time.

- Confirm timer business logic placement is correct
- Confirm cubit dependencies are injected from service locator
- Confirm feature does not bypass domain contracts

## Checklist
- [ ] Domain has zero data/presentation imports
- [ ] Presentation does not import data sources
- [ ] Repositories map exceptions to failures
- [ ] Cubits depend on use cases (or justified app-level services)
- [ ] Feature has complete layers or documented reason for partial layering
- [ ] DI is complete and lifecycle choices are justified
