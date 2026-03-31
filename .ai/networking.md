# Networking Prompt

## Template
Use the /networking-api + /error-handling + /dependency-injection skills to implement {firebase_scope} using Firebase services.

Requirements:
- Use Firebase Auth + Cloud Firestore as the primary remote source.
- Centralize collection/document path constants in one place.
- Map Firebase and connectivity exceptions to Failure objects.
- Ensure repositories return Either<Failure, T>.
- Register all remote data dependencies in service locator.

## Example
Use the /networking-api + /error-handling + /dependency-injection skills to implement session sync with Firestore.

- Collections: users/{uid}/sessions or sessions with userId index
- Connectivity-aware fallback to local cache
- Failure mapping for permission denied, unavailable, unknown
- Add repository and tests

## Checklist
- [ ] Firestore collections and paths are centralized
- [ ] Auth context is validated before remote calls
- [ ] Firebase, network, and cache failures are mapped
- [ ] Repository has no unhandled exceptions
- [ ] Dependencies are registered and testable
