# Style & Naming Conventions

## File & Folder Naming
- All files and folders: `snake_case` (e.g., `auth_cubit.dart`, `show_data_container.dart`).

## Identifier Naming
- Classes, Enums, Typedefs, Extensions: `UpperCamelCase` (e.g., `AuthCubit`, `UserModel`).
- Variables, Functions, Parameters, Object Instances: `lowerCamelCase` (e.g., `signInUser`, `isLoading`).
- File-private variables/functions: prefix with underscore `_lowerCamelCase`.

## Widget Structure Rules
- Prefer composition over inheritance.
- Prefer `StatelessWidget` over `StatefulWidget` where possible.
- Separate UI from business logic completely.

## Code Formatting Strict Rules
- Trailing commas are mandatory for multi-line formatting.
- Avoid UI nesting depth > 3 in `build()` methods; extract to modular widgets instead.
- NO hardcoded strings: Use `easy_localization` (`AppStrings.key.tr()`).
- NO hardcoded colors: Use `AppTheme` and `Theme.of(context)`.
