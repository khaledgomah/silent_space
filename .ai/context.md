# Repository Context

## App Purpose
Silent Space is a productivity application focused on focus timers, ambient sounds, session tracking, and user settings, featuring dynamic localization and theming.

## Tech Stack
- Frontend: Flutter
- State Management: flutter_bloc (Cubit)
- Dependency Injection: get_it
- Networking: dio
- Local Storage: hive, shared_preferences, flutter_secure_storage
- Localization: easy_localization

## Architecture
- Clean Architecture (Feature-based)
- Presentation: Pages, Widgets, Cubits, States
- Domain: Entities, Repositories (abstract), UseCases
- Data: Models, Repositories (impl), DataSources (Remote/Local)

## Folder Responsibilities
- `lib/core/`: App-wide utilities, constants, network clients, errors, caching, theming.
- `lib/features/`: Isolated feature modules (e.g., auth, home, session, setting, splash, time).
- `assets/`: Static assets, images, audio, translations.
- `test/`: Unit and widget testing mapping the feature-based structure.
