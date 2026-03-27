---
description: Complete AI ecosystem configuration for Silent Space development
---

# Silent Space — AI Development Ecosystem

Comprehensive guide to all AI-assisted development files, tools, and workflows.

---

## 📋 Complete File Inventory

### Root Configuration Files

| File                              | Purpose                                      | Status    |
| --------------------------------- | -------------------------------------------- | --------- |
| `.github/copilot-instructions.md` | Global workspace instructions for all AI     | ✅ Active |
| `AGENTS.md`                       | AI agent behavior definition and enforcement | ✅ Active |
| `.editorconfig`                   | Code style enforcement across team           | ✅ Active |
| `TROUBLESHOOTING.md`              | Common issues with AI-assisted solutions     | ✅ Active |

### VS Code Team Setup

| File                      | Purpose                           | Status    |
| ------------------------- | --------------------------------- | --------- |
| `.vscode/extensions.json` | Recommended extensions for team   | ✅ Active |
| `.vscode/settings.json`   | Dart/Flutter development settings | ✅ Active |

### Style & Guidelines (Legacy — Now Consolidated)

| File             | Purpose                    | Consolidated Into                 |
| ---------------- | -------------------------- | --------------------------------- |
| `.ai/style.md`   | Naming conventions         | `.github/copilot-instructions.md` |
| `.ai/rules.md`   | Strict DO/DON'T rules      | `.github/copilot-instructions.md` |
| `.ai/context.md` | Project context/tech stack | `.github/copilot-instructions.md` |

### AI Skills Library (11 Total)

**Core Skills (5):**

| Skill               | Path                                          | Purpose                                  | Status       |
| ------------------- | --------------------------------------------- | ---------------------------------------- | ------------ |
| create-feature      | `.github/skills/create-feature/SKILL.md`      | Feature creation with Clean Architecture | ✅ 800 lines |
| testing-flutter     | `.github/skills/testing-flutter/SKILL.md`     | Unit & widget test patterns              | ✅ 700 lines |
| architecture-review | `.github/skills/architecture-review/SKILL.md` | Clean Architecture validation            | ✅ 500 lines |
| localization-i18n   | `.github/skills/localization-i18n/SKILL.md`   | Translation management                   | ✅ 400 lines |
| widget-refactoring  | `.github/skills/widget-refactoring/SKILL.md`  | Component optimization                   | ✅ 500 lines |

**Advanced Skills (6):**

| Skill                     | Path                                                | Purpose                     | Status       |
| ------------------------- | --------------------------------------------------- | --------------------------- | ------------ |
| dependency-injection      | `.github/skills/dependency-injection/SKILL.md`      | Service locator patterns    | ✅ 500 lines |
| error-handling            | `.github/skills/error-handling/SKILL.md`            | Exception→Failure mapping   | ✅ 600 lines |
| state-management-advanced | `.github/skills/state-management-advanced/SKILL.md` | Multi-Cubit flows           | ✅ 550 lines |
| debugging-architecture    | `.github/skills/debugging-architecture/SKILL.md`    | Layer violation debugging   | ✅ 450 lines |
| networking-api            | `.github/skills/networking-api/SKILL.md`            | Dio integration             | ✅ 650 lines |
| caching-persistence       | `.github/skills/caching-persistence/SKILL.md`       | Hive offline-first patterns | ✅ 700 lines |

### AI Workflows & Automation

| File                                          | Purpose                              | Status        |
| --------------------------------------------- | ------------------------------------ | ------------- |
| `.github/workflows/ai-assisted-pr-review.yml` | Automated PR validation              | ✅ Active     |
| `.ai/prompts/PROMPTS.md`                      | Custom prompts for development tasks | ✅ 11 prompts |

### Reference & Documentation

| File              | Purpose                        | Status        |
| ----------------- | ------------------------------ | ------------- |
| `.ai/glossary.md` | Project terminology dictionary | ✅ 150+ terms |

---

## 🎯 Quick Start: Using the Ecosystem

### For a New Developer

1. **Clone repo**

   ```bash
   git clone <repo>
   cd silent_space
   ```

2. **Install recommended extensions** (prompted by VS Code)

   ```
   .vscode/extensions.json → "Install All"
   ```

3. **Read key files** (in order)
   - `.github/copilot-instructions.md` (project overview)
   - `.ai/glossary.md` (understand terminology)
   - `TROUBLESHOOTING.md` (when stuck)

4. **Start development with AI assistance**
   - Open Copilot Chat (`Ctrl+Shift+I`)
   - Use prompts from `.ai/prompts/PROMPTS.md`

### For Creating a Feature

1. **Open Copilot Chat**
2. **Copy prompt from `.ai/prompts/PROMPTS.md`** → "Create a Complete Feature"
3. **AI uses `/create-feature` skill** → implements end-to-end
4. **Review code** against `.github/copilot-instructions.md`
5. **Run tests** generated by skill

### For Code Review

1. **Use `/architecture-review` skill** → validates Clean Architecture
2. **Check PR against** `.github/workflows/ai-assisted-pr-review.yml`
3. **Refer to** `TROUBLESHOOTING.md` if issues found
4. **AI suggests fixes** based on `.ai/glossary.md` terminology

### For Troubleshooting

1. **Find issue in** `TROUBLESHOOTING.md`
2. **Follow "Solution Steps"** section
3. **Ask Copilot** with exact error message
4. **Copilot uses `/debugging-architecture` or other skills**

---

## 📚 Deep Dive: Ecosystem Components

### `.github/copilot-instructions.md`

**The Master Blueprint**

- **Lines:** 500+
- **Scope:** Global workspace rules for all AI interactions
- **Updates:** When architecture changes
- **Who maintains:** Tech lead

**Key Sections:**

- Quick Context (architecture overview)
- Three-Layer Architecture (Clean Architecture rules)
- Core Folder Structure (where everything goes)
- Service Locator Registration (dependency injection)
- Testing Strategy (unit + widget patterns)
- Localization (i18n/l10n setup)
- Health Checklist (periodic validation)

---

### `.github/skills/` (11 Skills, 5,800 Lines Total)

**Specialized Knowledge Modules**

**When Copilot Uses Skills:**

1. You ask a question matching skill's purpose
2. Copilot automatically loads the skill file
3. Skill provides step-by-step guidance with code examples
4. AI generates production-ready code following patterns

**Example Flow:**

```
You: "Create a Feedback feature with offline sync"
↓
Copilot: Loads /create-feature skill
↓
Skill: Walks through domain → data → presentation with examples
↓
Copilot: Generates complete feature code
↓
You: Review against .github/copilot-instructions.md
```

**Skill Organization:**

- **Architecture & Design:** create-feature, architecture-review, dependency-injection
- **Testing & Debugging:** testing-flutter, debugging-architecture
- **Infrastructure:** networking-api, caching-persistence, error-handling
- **State & UI:** state-management-advanced, widget-refactoring, localization-i18n

---

### `.vscode/extensions.json`

**Recommended Extensions for Team**

**What it does:** When a team member opens workspace, VS Code prompts "Install recommended extensions"

**Extensions included:**

- GitHub Copilot (AI chat & code completion)
- GitHub Copilot Nightly (early features)
- Dart Code & Flutter (language support)
- GitLens (version control insights)
- Prettier (formatting)
- Ruff (Python linting)
- Firebase tools
- Docker support
- And 20+ more...

**Benefits:**

- Consistent tools across team
- No "works on my machine" issues
- AI features enabled for all developers

---

### `.vscode/settings.json`

**Development Environment Configuration**

**Dart-specific settings:**

```json
{
  "dart.warnWhenEditingFilesOutsideWorkspace": false,
  "dart.enableSdkFormatter": true,
  "dart.lineLength": 100,
  "[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnPaste": true
  }
}
```

**Enforces:**

- Auto-format on save
- 100-character line limit (matches `.editorconfig`)
- Const constructor checking
- Import organization

---

### `.editorconfig`

**Cross-IDE Code Style**

**Coverage:** Dart, JSON, YAML, Gradle, Swift, Kotlin, C++

**Enforces:**

- 2-space indentation for Dart
- 100-character line length
- LF line endings
- UTF-8 encoding
- Trailing newlines

**Why important:** Even if someone uses Sublime Text, Vim, or JetBrains IDE, code style stays consistent.

---

### `TROUBLESHOOTING.md`

**Problem-Solution Encyclopedia**

**Structure:**

- **Common Errors & Solutions** (organized by category)
  - Startup & Build Errors
  - Network & API Errors
  - State Management & UI Issues
  - Cache & Persistence Errors
  - Testing Errors
  - Performance Issues
  - Firebase & Cloud Issues
  - Git & Version Control

**Each error includes:**

- Root cause explanation
- Debugging steps
- Code examples
- "Ask AI for help" suggestions
- Quick fix reference table

**Usage:** When stuck, Ctrl+F for your error → follow solution steps

---

### `.ai/glossary.md`

**Shared Vocabulary Dictionary**

**Why it exists:**

- AI responds consistently using project terminology
- New developers understand project-specific meanings
- Reduces miscommunication

**Content:**

- Architecture terms (Clean Architecture, Domain, Entity, etc.)
- State management (Cubit, Emit, BlocBuilder, etc.)
- Data & persistence (Hive, Cache, Offline-First, etc.)
- Networking (Dio, Interceptor, JWT, etc.)
- Testing (Unit Test, BDD, Mock, etc.)
- 150+ terms total

**AI uses this to:**

- Explain errors using correct terminology
- Generate code comments with consistent language
- Recommend patterns using known terms

---

### `.ai/prompts/PROMPTS.md`

**Pre-Written Prompts for Common Tasks**

**11 Prompts Included:**

1. Create Complete Feature
2. Code Review — Architecture
3. Debug Architecture Violation
4. Implement Error Handling
5. Refactor Large Widget
6. Write Tests
7. Setup Caching Strategy
8. Setup Networking
9. Add Localization
10. Dependency Injection Setup
11. Multi-Cubit Coordination

**How to use:**

```
1. Open Copilot Chat (Ctrl+Shift+I)
2. Copy prompt from .ai/prompts/PROMPTS.md
3. Customize {PLACEHOLDERS}
4. Paste into Copilot
5. AI executes the workflow
```

**Example Usage:**

```
Prompt Template:
Create a {FEATURE_NAME} feature with:
- Domain: {ENTITY} entity
- Use Cases: {USECASE_NAMES}
- Tests: {TEST_COVERAGE}

Your Version:
Create a UserPreferences feature with:
- Domain: PreferencesEntity with theme, language, notifications
- Use Cases: GetPreferences, UpdatePreferences, ResetToDefaults
- Tests: Full domain + data layer coverage
```

---

### `.github/workflows/ai-assisted-pr-review.yml`

**Automated Quality Gates**

**When it runs:** Every PR modifying `lib/`, `test/`, or `pubspec.yaml`

**Checks performed:**

1. **Architecture Check**
   - Validates Clean Architecture (no data imports in presentation)
   - Checks for Flutter imports in domain
   - Verifies service locator registrations

2. **Test Coverage**
   - Runs all tests
   - Ensures ≥60% coverage
   - Fails if coverage drops

3. **Code Style**
   - Checks file naming (snake_case)
   - Validates const constructors
   - Runs formatter

4. **Dependency Security**
   - Scans for outdated packages
   - Flags dangerous dependencies

5. **Summary Report**
   - Shows all results
   - Blocks merge if failed

**Benefits:**

- No manual quality checks
- Consistent standards enforced
- PR author gets immediate feedback

---

## 🔄 Workflow Examples

### Workflow 1: Create Feature from Scratch

```
1. User: "Create user profile feature"
2. Copilot Chat opens
3. User copies create-feature prompt from .ai/prompts/PROMPTS.md
4. Customizes: entity fields, use cases, endpoints
5. Pastes into Copilot
6. AI loads /create-feature skill
7. AI generates:
   - Domain: UserProfile entity, UserProfileRepository, GetUserProfileUseCase
   - Data: UserProfileRemoteDataSource, UserProfileModel, UserProfileRepositoryImpl
   - Presentation: UserProfilePage, UserProfileCubit, user_profile_state.dart
   - Tests: All layers covered
   - Service Locator: All registrations added
8. User reviews code
9. Runs tests (all pass)
10. Pushes PR
11. GitHub Actions validates (passes)
12. Merges to main
```

### Workflow 2: Fix a Bug

```
1. Error: "No instance of FeedbackRepository found"
2. User opens TROUBLESHOOTING.md
3. Finds "No instance of type XYZ found"
4. Follows debugging steps
5. Discovers: FeedbackRepository not registered
6. Opens service_locator.dart
7. Asks Copilot: "Register FeedbackRepository"
8. AI loads /dependency-injection skill
9. AI shows correct registration order
10. User adds registration
11. Error fixed
12. Tests pass
13. Merged
```

### Workflow 3: Code Review

```
1. PR submitted: "Add notifications feature"
2. Reviewer opens PR
3. Asks Copilot: "Use /architecture-review to validate notifications feature"
4. AI loads /architecture-review skill
5. AI checks:
   - Domain layer isolation ✅
   - No data imports in presentation ✅
   - Repository patterns ✅
   - Service locator registration ✅
   - State management (Equatable, immutable) ✅
6. Reviewer gets detailed report
7. Approves PR
8. GitHub Actions validates (passes)
9. Merged
```

### Workflow 4: Troubleshoot Performance

```
1. Complaint: "App feels slow when scrolling sessions"
2. User opens TROUBLESHOOTING.md
3. Searches "slow" → finds "Performance Issues" section
4. Learns: missing const constructors, expensive rebuilds
5. Opens SessionListPage
6. Asks Copilot: "Use /widget-refactoring to optimize SessionListPage"
7. AI loads /widget-refactoring skill
8. AI shows:
   - Add const to SessionTile constructor
   - Use BlocSelector instead of BlocBuilder
   - Extract SessionStatsWidget
9. User applies changes
10. Performance improves (60fps)
```

---

## 📊 AI Ecosystem Stats

| Metric                      | Count  |
| --------------------------- | ------ |
| Total AI files              | 9      |
| Total skills                | 11     |
| Total lines of guidance     | 8,000+ |
| Custom prompts              | 11     |
| Automated checks            | 5      |
| Terms in glossary           | 150+   |
| Common solutions documented | 20+    |

---

## 🚀 Getting Maximum Value

### Best Practices

✅ **Always ask AI specific questions** — "Create user profile feature" ✅ vs. ❌ "build something"

✅ **Use skills as templates** — Don't reinvent patterns

✅ **Validate architecture regularly** — Run /architecture-review monthly

✅ **Keep glossary updated** — Add new terms as project evolves

✅ **Refer to TROUBLESHOOTING** — Before asking generic questions

✅ **Trust the workflows** — GitHub Actions checks for you

### Avoiding Common Pitfalls

❌ **Ignoring .github/copilot-instructions.md** — This is the source of truth

❌ **Not using services_locator.dart** — Causes "Type not found" errors

❌ **Skipping tests** — AI skills include full test coverage

❌ **Hardcoding strings/colors** — Use AppStrings and Theme instead

❌ **Breaking Clean Architecture** — AI catches violations in code review

---

## 🆘 When Things Go Wrong

**Step 1:** Check `TROUBLESHOOTING.md` → See if your error is documented

**Step 2:** Ask Copilot with error message and file name

**Step 3:** Copilot loads relevant skill (debugging, error-handling, etc.)

**Step 4:** Follow AI guidance → Run tests → Verify

**Step 5:** If still stuck → Reference `.ai/glossary.md` + `.github/copilot-instructions.md`

---

## 📈 Maintenance & Evolution

| Frequency    | Task                                     | Owner               |
| ------------ | ---------------------------------------- | ------------------- |
| Monthly      | Run `/architecture-review` on codebase   | Tech lead           |
| Quarterly    | Update `.ai/glossary.md` with new terms  | Team                |
| When changed | Update `.github/copilot-instructions.md` | Tech lead           |
| Per PR       | GitHub Actions validates automatically   | Automation          |
| Per feature  | AI generates code with skills            | Developer + Copilot |

---

## 🎓 Learning Path

**For New Developers:**

1. Read `.github/copilot-instructions.md` (understand architecture)
2. Read `.ai/glossary.md` (learn terminology)
3. Follow `.ai/prompts/PROMPTS.md` to create first feature
4. Review `TROUBLESHOOTING.md` (bookmark for reference)

**For Experienced Developers:**

1. Use skills as templates for advanced patterns
2. Review PR with `/architecture-review`
3. Contribute to `.ai/glossary.md`
4. Improve skills with new patterns

**For Tech Leads:**

1. Maintain `.github/copilot-instructions.md`
2. Review skills quarterly
3. Update workflows based on team needs
4. Enforce architecture reviews

---

## 📞 Getting Help

### If you're not sure:

- **"What does Clean Architecture mean?"** → `.ai/glossary.md`
- **"How do I create a feature?"** → `.github/skills/create-feature/SKILL.md`
- **"Why am I getting this error?"** → `TROUBLESHOOTING.md`
- **"How should I structure this?"** → `.github/copilot-instructions.md`

### If you want to:

- **Learn a pattern** → Use skill as reference
- **Debug quickly** → Copy prompt from `.ai/prompts/PROMPTS.md`
- **Review code** → Use `/architecture-review` skill
- **Write tests** → Use `/testing-flutter` skill

---

**Last Updated:** March 2026  
**Total Investment:** 8,000+ lines of structured guidance  
**ROI:** Faster development, consistent quality, fewer bugs, better architecture  
**Maintained By:** Silent Space Team

🚀 **You now have a complete AI-powered development ecosystem!**
