---
name: git-commit-split
description: 'Analyze uncommitted git changes, group them logically into independent, atomic units, and perform separate commits with clear conventional commit messages.'
argument-hint: 'Optional specific files or commit scope filters'
---

# Git Commit Split (Atomic Commits)

## When to Use
- When multiple changes across different layers, features, or concerns have been made without committing.
- When creating a new feature with many files (domain, data, presentation, tests) and you want to commit them in logical, reviewable phases.
- Before pushing changes to a remote repository, to ensure the commit history remains clean, granular, and easy to revert or cherry-pick.

## Principles

### 1. Atomic Commits
Every commit should represent a single, logical change. It must:
- Be complete (don't break the build or tests).
- Focus on one topic/layer/concern.
- Be as small as possible while remaining functional.

### 2. Clean Architecture Layer Commit Sequence
For feature development, commit in order of dependencies (bottom-up):
1. **Domain Layer**: Entities and Repository Interfaces (`feat(feature/domain): ...`)
2. **Data Layer**: Models, Data Sources, and Repository Implementations (`feat(feature/data): ...`)
3. **Presentation Layer**: Cubits, States, Pages, and Widgets (`feat(feature/presentation): ...`)
4. **Service Registration / Setup**: `service_locator.dart`, routes, config (`feat(feature/di): ...` or `chore(di): ...`)
5. **Testing**: Unit and Widget tests (`test(feature): ...`)

### 3. Conventional Commit Format
Use the standard Conventional Commits specification:
```
<type>(<scope>): <description>

[optional body]
```

**Types:**
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc.)
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `build`: Changes that affect the build system or external dependencies
- `ci`: Changes to CI configuration files and scripts
- `chore`: Other changes that don't modify src or test files

**Scopes (examples):**
- `auth/domain`, `session/data`, `settings/presentation`
- `core/network`, `core/cache`, `core/di`
- `theme`, `localization`

---

## Step-by-Step Procedure

### 1. **Analyze Uncommitted Changes**
Run `git status` and `git diff` to identify all changed files and modifications.

### 2. **Formulate the Atomic Commit Plan**
Group the changes into separate commits. Draft a table or checklist of commits to show the user:
- Commit Number
- Type & Scope
- Commit Message
- Included Files / Changes

### 3. **Request User Approval**
Present the Commit Plan to the user and ask for verification before executing the commits.

### 4. **Execute Commits Sequentially**
For each approved commit in the plan:
1. Stage only the files associated with the current commit using:
   ```bash
   git add <file1> <file2> ...
   ```
   *Note: If a file contains changes for multiple commits, use interactive staging `git add -p <file>` to stage specific hunks.*
2. Commit the staged changes:
   ```bash
   git commit -m "<type>(<scope>): <description>"
   ```
3. Run `git status` to verify staging is clean for the next step.

### 5. **Verify and Clean Up**
Run `git status` to ensure all changes have been successfully committed and the working tree is clean.

---

## Examples

### Example 1: New Feature Implementation
If you implemented a new "Focus Analytics" feature including domain, data, presentation, and unit tests, split them as follows:

| Commit | Message | Files Included |
| :--- | :--- | :--- |
| **Commit 1** | `feat(analytics/domain): define focus analytics entities and repository contracts` | `lib/features/analytics/domain/entities/` <br> `lib/features/analytics/domain/repositories/` |
| **Commit 2** | `feat(analytics/data): implement analytics remote source and repository` | `lib/features/analytics/data/models/` <br> `lib/features/analytics/data/sources/` <br> `lib/features/analytics/data/implements/` |
| **Commit 3** | `feat(analytics/presentation): create analytics cubit and page layout` | `lib/features/analytics/presentation/cubit/` <br> `lib/features/analytics/presentation/pages/` <br> `lib/features/analytics/presentation/widgets/` |
| **Commit 4** | `chore(di): register focus analytics dependencies in service locator` | `lib/core/utils/service_locator.dart` |
| **Commit 5** | `test(analytics): add unit tests for repository and use cases` | `test/features/analytics/` |

### Example 2: Bug Fix & Clean Up
If you fixed a bug in localization and refactored a shared widget:

| Commit | Message | Files Included |
| :--- | :--- | :--- |
| **Commit 1** | `fix(localization): resolve arabic translation loading issue` | `assets/translations/ar.json` <br> `lib/core/cubits/language/` |
| **Commit 2** | `refactor(core/widgets): extract custom button design to reusable widget` | `lib/core/widgets/custom_button.dart` |
