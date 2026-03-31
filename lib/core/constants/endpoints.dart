class Endpoints {
	Endpoints._();

	// Firestore collection names are centralized here to avoid typo-driven bugs
	// and keep data-layer queries consistent across features.
	static const String usersCollection = 'users';
	static const String sessionsCollection = 'sessions';
	static const String settingsCollection = 'settings';
	static const String categoriesCollection = 'categories';
	static const String feedbackCollection = 'feedback';

	static String userDocument(String userId) => '$usersCollection/$userId';
}

