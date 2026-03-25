# AI Rules

## Strict DO & DON'T
- DO reuse existing code and widgets from `core/widgets/`.
- DO extract complex UI into small, modular widgets.
- DO handle Loading, Error, Success, and Empty states properly in UI and Cubits.
- DO map all exceptions to typed `Failure` objects before reaching the UI.
- DON'T create unnecessary or duplicate files.
- DON'T break Feature-based Clean Architecture boundaries (e.g., Presentation must not import Data sources directly).
- DON'T write quick hacks. Everything must be production-ready.
- DON'T mutate variables inside Cubits; state must be managed via immutable State classes.

## Performance Rules
- Use `const` constructors aggressively in widget trees.
- Avoid unnecessary `setState`; prefer BlocBuilder and specific BlocSelectors.
- Extract complex widgets into separate `StatelessWidget` classes rather than helper methods to optimize rebuilt scope.

## State Management Rules
- Use `Cubit` (flutter_bloc) for state management.
- States MUST be immutable (extend `Equatable`).
- Always emit new states; never rely on mutable Cubit fields for core properties.
