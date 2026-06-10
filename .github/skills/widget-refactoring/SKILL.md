---
name: widget-refactoring
description: 'Refactor complex, monolithic, or deeply nested widgets into small, modular, stateless, and performance-optimized widgets.'
argument-hint: 'Optional widget class name to refactor'
---

# Widget Refactoring

## When to Use
- When a widget build method is too large (more than 100 lines), hard to read, or has deep nesting.
- When there is duplicate layout logic inside pages.
- When optimizing UI rebuild performance (reducing state scope).

## Principles

### 1. Separation of Concerns
- Keep UI widgets stateless (`StatelessWidget`) whenever possible.
- If local state is needed (e.g. text controllers, animation states), use a separate stateful sub-widget rather than bloating the main page.
- Do not mix business logic with layout markup.

### 2. Style Guides
- Do not hardcode margins, paddings, colors, or fonts.
- Use `AppColors`, `AppTheme`, and layout constant classes to maintain consistency.

---

## Step-by-Step Procedure

### 1. Identify Monolithic Blocks
Look for:
- Deeply nested widgets (more than 5-6 levels deep).
- Large helper functions returning Widgets (e.g., `Widget _buildItem()`) which can result in unnecessary rebuilds. Convert these to dedicated class-based widgets.

### 2. Extract Sub-Widgets
Extract nested blocks into a new `StatelessWidget` within the `/presentation/widgets/` subdirectory:
```dart
class FeatureItemCard extends StatelessWidget {
  final ItemEntity item;
  const FeatureItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.title),
      ),
    );
  }
}
```

### 3. Implement performance optimizations
- Use `const` constructors where possible to cache widget builds.
- Wrap only relevant elements with `BlocBuilder` instead of wrapping the entire page.
