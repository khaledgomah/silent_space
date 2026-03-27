---
name: widget-refactoring
description: 'Refactor complex Flutter widgets into smaller, composable, reusable StatelessWidget components. Use for reducing nesting depth (max 3 levels), extracting UI logic, improving readability, and managing widget rebuilds efficiently.'
argument-hint: 'Widget name or file path (e.g., HomePage, lib/features/home/presentation/pages/home_page.dart)'
---

# Widget Refactoring & Composition

## When to Use
- Widget has nesting depth > 3 levels in `build()`
- Multiple concerns mixed in one widget (state + lots of UI)
- Same widget pattern repeated in multiple places
- Rebuild optimization needed for performance

## Principles

### Composition Over Inheritance
```dart
// ❌ Wrong: Inheritable widget with extra logic
class FocusTimerBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 50 lines of timer logic mixed with UI
    return ...;
  }
}

// ✅ Right: Compose into smaller widgets
class FocusTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TimerDisplay(),        // Separate widget
        const TimerControls(),       // Separate widget
        const TimerProgressBar(),    // Separate widget
      ],
    );
  }
}
```

### Nesting Depth ≤ 3
```dart
// ❌ Too deep nesting (6+ levels)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Image.asset('assets/logo.png'),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Title'),
                        Text('Subtitle'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ Refactored (nesting: 3)
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const _HomeHeader(),   // Level 2
            const _HomeContent(),  // Level 2
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Image.asset('assets/logo.png'),
          Expanded(
            child: const _HeaderText(),  // Extracted
          ),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppStrings.title.tr()),
        Text(AppStrings.subtitle.tr()),
      ],
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
```

## Step-by-Step Refactoring Procedure

### 1. **Identify Problem Areas**

Check for these red flags:

```dart
// ❌ Warning: Deep nesting
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(...),
                        ...
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
```

**Count the nesting:**
```
1. Scaffold
2. Center
3. SingleChildScrollView
4. Column
5. Container
6. Row
7. Expanded
8. Column (second)
```
❌ **8 levels** — Must refactor!

### 2. **Extract Logical Sections**

Break down into meaningful, reusable parts:

**Before:**
```dart
class ProfilePage extends StatelessWidget {
  final UserEntity user;

  const ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user.avatarUrl),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(user.email),
                ],
              ),
            ),
            const Divider(),
            
            // Stats Section
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text('Sessions'),
                        Text(user.sessionCount.toString()),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text('Focus Time'),
                        Text('${user.focusHours} hrs'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Action Buttons
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => editProfile(),
                    child: const Text('Edit Profile'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () => signOut(),
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**After: Refactored into components**

```dart
class ProfilePage extends StatelessWidget {
  final UserEntity user;

  const ProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(user: user),
            const Divider(),
            _ProfileStats(user: user),
            _ProfileActions(user: user),
          ],
        ),
      ),
    );
  }
}

// Extracted component 1
class _ProfileHeader extends StatelessWidget {
  final UserEntity user;

  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user.avatarUrl),
          ),
          const SizedBox(height: 16),
          Text(
            user.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(user.email),
        ],
      ),
    );
  }
}

// Extracted component 2
class _ProfileStats extends StatelessWidget {
  final UserEntity user;

  const _ProfileStats({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _StatCard(
              label: AppStrings.sessions.tr(),
              value: user.sessionCount.toString(),
            ),
          ),
          Expanded(
            child: _StatCard(
              label: AppStrings.focusTime.tr(),
              value: '${user.focusHours} ${AppStrings.hours.tr()}',
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable sub-component
class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Text(value),
      ],
    );
  }
}

// Extracted component 3
class _ProfileActions extends StatelessWidget {
  final UserEntity user;

  const _ProfileActions({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () => context.read<ProfileCubit>().editProfile(),
            child: Text(AppStrings.editProfile.tr()),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.read<AuthCubit>().signOut(),
            child: Text(AppStrings.signOut.tr()),
          ),
        ],
      ),
    );
  }
}
```

**Benefits:**
- ✅ Main widget now 5 lines of Column children
- ✅ Each widget has single responsibility
- ✅ Easy to test individual components
- ✅ Reusable (`_StatCard` can be used elsewhere)
- ✅ Nesting depth: 2 levels max

### 3. **Extract Complex Lists**

For `ListView.builder` or `GridView`, create item widgets:

```dart
// ❌ Before: List item UI in builder
ListView.builder(
  itemCount: sessions.length,
  itemBuilder: (context, index) {
    final session = sessions[index];
    return ListTile(
      leading: CircleAvatar(
        child: Text(session.durationMinutes.toString()),
      ),
      title: Text(session.category),
      subtitle: Text(
        DateFormat('MMM dd, HH:mm').format(session.startTime),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          context.read<SessionCubit>().deleteSession(session.id);
        },
      ),
    );
  },
)

// ✅ After: Extracted item widget
ListView.builder(
  itemCount: sessions.length,
  itemBuilder: (context, index) {
    return _SessionListItem(
      session: sessions[index],
      onDelete: () {
        context.read<SessionCubit>().deleteSession(sessions[index].id);
      },
    );
  },
)

class _SessionListItem extends StatelessWidget {
  final FocusSession session;
  final VoidCallback onDelete;

  const _SessionListItem({
    required this.session,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(session.durationMinutes.toString()),
      ),
      title: Text(session.category),
      subtitle: Text(
        DateFormat('MMM dd, HH:mm').format(session.startTime),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
```

### 4. **Handle State Efficiently**

Use `BlocBuilder` for only parts that change:

```dart
// ❌ Wrong: Rebuilds entire page on state change
class Homepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Home')),  // Rebuilds unnecessarily
          body: state is SessionLoaded
              ? SessionList(sessions: state.sessions)
              : const LoadingWidget(),
        );
      },
    );
  }
}

// ✅ Correct: Only content rebuilds
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),  // Stable, not in BlocBuilder
      body: BlocBuilder<SessionCubit, SessionState>(
        builder: (context, state) {
          if (state is SessionLoading) {
            return const LoadingWidget();
          } else if (state is SessionLoaded) {
            return SessionList(sessions: state.sessions);
          } else if (state is SessionError) {
            return ErrorWidget(message: state.message);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

Even better — use `BlocSelector` for granular rebuilds:

```dart
// ✅ Best: Only rebuild when sessions list changes
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocSelector<SessionCubit, SessionState, List<FocusSession>?>(
        selector: (state) {
          return state is SessionLoaded ? state.sessions : null;
        },
        builder: (context, sessions) {
          if (sessions == null) {
            return const LoadingWidget();
          }
          return SessionList(sessions: sessions);
        },
      ),
    );
  }
}
```

## Refactoring Checklist

When extracting a widget:

- [ ] Component has a single responsibility
- [ ] Maximum nesting depth is 3 levels in `build()`
- [ ] Widget is const (zero mutable state)
- [ ] Uses `BlocBuilder` / `BlocSelector` only where needed
- [ ] All string literals use `AppStrings.key.tr()`
- [ ] All colors use `Theme.of(context)` or `AppTheme`
- [ ] Callback functions passed as parameters, not internal logic
- [ ] Constructor parameters are clearly named
- [ ] Widget is reusable (not tied to one specific use case)

## Common Extraction Patterns

### Pattern 1: Header + Content + Footer
```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Header(),      // Title, info
        Expanded(
          child: _Content(),  // Main area
        ),
        _Footer(),      // Actions, buttons
      ],
    );
  }
}
```

### Pattern 2: List with Item Widget
```dart
class ItemListView extends StatelessWidget {
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ItemTile(item: items[index]);
      },
    );
  }
}

class ItemTile extends StatelessWidget {
  final Item item;
  
  @override
  Widget build(BuildContext context) => ...;
}
```

### Pattern 3: State-Driven Content
```dart
class FeaturePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureCubit, FeatureState>(
      builder: (context, state) {
        if (state is FeatureLoading) {
          return const _LoadingView();
        } else if (state is FeatureLoaded) {
          return _ContentView(data: state.data);
        } else if (state is FeatureError) {
          return _ErrorView(message: state.message);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
```

## Performance Tips

✅ **Use const constructors** — Aggressively apply `const` to all widgets
✅ **Extract to avoid rebuilds** — Small, focused widgets rebuild only when needed
✅ **Use `BlocSelector`** — Listen only to properties you care about
✅ **Lazy widgets** — Use `ListView.builder` instead of `ListView` for long lists
✅ **Cache expensive builds** — Widgets outside `BlocBuilder` don't rebuild

## Testing Extracted Widgets

```dart
void main() {
  testWidgets('_StatCard displaysLabelAndValue', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: const _StatCard(
            label: 'Sessions',
            value: '42',
          ),
        ),
      ),
    );

    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('42'), findsOneWidget);
  });
}
```

## Migration Checklist for Refactoring

- [ ] Identify all widgets with nesting > 3 levels
- [ ] Create extracted widget files
- [ ] Move UI code into extracted widgets
- [ ] Pass data via constructor parameters
- [ ] Pass callbacks for actions
- [ ] Update tests for new widget structure
- [ ] Verify no hardcoded strings/colors
- [ ] Test performance (no unnecessary rebuilds)
