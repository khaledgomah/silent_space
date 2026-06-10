---
name: debugging-architecture
description: 'Analyze runtime and static errors related to architecture rules, dependency mismatches, and build failures.'
argument-hint: 'Optional specific error message or log excerpt'
---

# Debugging Architecture

## When to Use
- When encountering build errors, analyzer warnings, or runtime dependency lookup errors (`GetIt` registration failures).
- When a unit test or integration test fails due to dependencies or incorrect mocking.

## Principles

### 1. Identify Error Source
- **Static Analysis Errors**: Mismatched signatures, invalid overrides (e.g., repository implementation has different arguments than the abstract class), or wrong imports.
- **Runtime DI Errors**: "Object not registered" errors in `GetIt` indicate dependency registration sequence errors or missing registrations.
- **Layer Violations**: Domain imports referring to database/UI files, causing coupling issues.

---

## Step-by-Step Procedure

### 1. Check Imports and Layer Violations
Search the file showing the error for illegal imports:
- Ensure no data/presentation references exist in `/domain/`.

### 2. Verify Method Signatures
If the error is `invalid_override`:
- Compare the abstract Repository interface method signature with the concrete Repository implementation.
- Adjust parameters (optional vs required, parameter type, nullability) to make them identical.

### 3. Verify GetIt Registrations
If the runtime error is `GetIt: Object of type <T> is not registered`:
- Locate the dependency registration in [service_locator.dart](file:///H:/flutter%20old/silent_space/lib/core/utils/service_locator.dart).
- Verify the order: Dependencies must be registered bottom-up (External -> DataSources -> Repositories -> UseCases -> Cubits).
- Ensure target class/dependency is not registered with a different interface than is being requested.
