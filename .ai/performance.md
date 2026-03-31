# Performance Prompt

## Template
Use the /architecture-review + /widget-refactoring skills to optimize {target_scope}.

Requirements:
- Identify unnecessary rebuilds and deep widget trees.
- Extract reusable stateless widgets.
- Use const constructors where possible.
- Use BlocSelector/buildWhen for selective rebuilds.
- Avoid expensive sync work in build methods.
- Provide before/after impact summary.

## Example
Use the /architecture-review + /widget-refactoring skills to optimize home dashboard.

- Reduce chart and summary card rebuilds
- Split monolithic widgets
- Keep build nesting depth <= 3

## Checklist
- [ ] Rebuild hotspots identified
- [ ] Expensive logic moved out of build
- [ ] Stateless composition improved
- [ ] Const usage increased
- [ ] State subscriptions are targeted
