---
name: localization-i18n
description: 'Add multilingual strings to the app (English + Arabic). Use for managing translation files (en.json, ar.json), creating AppStrings constants, and verifying translation coverage across features.'
argument-hint: 'Feature or page name (e.g., notifications, session-details, feedback-form)'
---

# Localization & Internationalization

## When to Use
- Adding new string constants for UI text
- Supporting new languages (currently en + ar)
- Translating a new feature
- Verifying all strings are localized (no hardcoded text)

## File Structure

```
assets/
├── translations/
│   ├── en.json           # English (default)
│   └── ar.json           # Arabic
lib/
└── core/
    └── utils/
        └── app_strings.dart     # String key constants
```

## Step-by-Step Procedure

### 1. **Add Keys to app_strings.dart**

Edit `lib/core/utils/app_strings.dart` and add new string keys:

```dart
class AppStrings {
  // ── Authentication ──
  static const String welcome = 'welcome';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String email = 'email';
  static const String password = 'password';
  static const String forgotPassword = 'forgotPassword';
  static const String noAccount = 'noAccount';
  static const String alreadyHaveAccount = 'alreadyHaveAccount';
  
  // ── Home ──
  static const String home = 'home';
  static const String focusTime = 'focusTime';
  static const String focusCount = 'focusCount';
  static const String sessionToday = 'sessionToday';
  
  // ── Notifications (NEW) ──
  static const String notifications = 'notifications';
  static const String noNotifications = 'noNotifications';
  static const String markAsRead = 'markAsRead';
  static const String notificationTitle = 'notificationTitle';
  static const String clearAll = 'clearAll';
  
  // ── Settings ──
  static const String settings = 'settings';
  static const String language = 'language';
  static const String theme = 'theme';
  static const String soundVolume = 'soundVolume';
  
  // ── Errors ──
  static const String errorOccurred = 'errorOccurred';
  static const String tryAgain = 'tryAgain';
  static const String networkError = 'networkError';
  static const String sessionExpired = 'sessionExpired';
}
```

**Best Practices:**
- Use descriptive, hierarchical names: `notificationClearAll` not `clear`
- Group related strings with comments: `// ── Feature Name ──`
- Keep strings short and reusable
- Avoid code logic in strings

### 2. **Add Translations to en.json**

Edit `assets/translations/en.json`:

```json
{
  "welcome": "Welcome to Silent Space",
  "login": "Login",
  "signup": "Sign Up",
  "email": "Email Address",
  "password": "Password",
  "forgotPassword": "Forgot Password?",
  "noAccount": "Don't have an account?",
  "alreadyHaveAccount": "Already have an account?",
  
  "home": "Home",
  "focusTime": "Focus Time",
  "focusCount": "Sessions",
  "sessionToday": "Sessions Today",
  
  "notifications": "Notifications",
  "noNotifications": "No notifications yet",
  "markAsRead": "Mark as Read",
  "notificationTitle": "You have a new notification",
  "clearAll": "Clear All",
  
  "settings": "Settings",
  "language": "Language",
  "theme": "Theme",
  "soundVolume": "Sound Volume",
  
  "errorOccurred": "An error occurred",
  "tryAgain": "Try Again",
  "networkError": "Network error. Please check your connection.",
  "sessionExpired": "Your session has expired. Please login again."
}
```

### 3. **Add Translations to ar.json**

Edit `assets/translations/ar.json`:

```json
{
  "welcome": "أهلا وسهلا بك في Silent Space",
  "login": "تسجيل الدخول",
  "signup": "إنشاء حساب",
  "email": "عنوان البريد الإلكتروني",
  "password": "كلمة المرور",
  "forgotPassword": "هل نسيت كلمة المرور؟",
  "noAccount": "ليس لديك حساب؟",
  "alreadyHaveAccount": "هل لديك حساب بالفعل؟",
  
  "home": "الرئيسية",
  "focusTime": "وقت التركيز",
  "focusCount": "الجلسات",
  "sessionToday": "الجلسات اليوم",
  
  "notifications": "الإشعارات",
  "noNotifications": "لا توجد إشعارات حتى الآن",
  "markAsRead": "وضع علامة كمقروء",
  "notificationTitle": "لديك إشعار جديد",
  "clearAll": "مسح الكل",
  
  "settings": "الإعدادات",
  "language": "اللغة",
  "theme": "المظهر",
  "soundVolume": "مستوى الصوت",
  
  "errorOccurred": "حدث خطأ",
  "tryAgain": "حاول مجددا",
  "networkError": "خطأ في الشبكة. يرجى التحقق من الاتصال.",
  "sessionExpired": "انتهت جلستك. يرجى تسجيل الدخول مرة أخرى."
}
```

### 4. **Use Strings in UI**

Always use `AppStrings` with `.tr()` extension:

```dart
import 'package:easy_localization/easy_localization.dart';
import 'package:silent_space/core/utils/app_strings.dart';

// ✅ Correct - Using easy_localization
class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.notifications.tr()),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(AppStrings.markAsRead.tr()),
            trailing: IconButton(
              icon: const Icon(Icons.check),
              onPressed: () => markAsRead(),
            ),
          ),
          TextButton(
            onPressed: clearAll,
            child: Text(AppStrings.clearAll.tr()),
          ),
        ],
      ),
    );
  }
}

// ❌ Wrong - Hardcoded strings
class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),  // ❌
      body: const Center(child: Text('No notifications')),  // ❌
    );
  }
}
```

### 5. **Pluralization & Parameters** (Advanced)

For dynamic strings, use placeholder syntax:

**app_strings.dart:**
```dart
class AppStrings {
  static const String sessionsCompleted = 'sessionsCompleted';
  static const String welcomeUser = 'welcomeUser';
  static const String focusTimeRemaining = 'focusTimeRemaining';
}
```

**en.json:**
```json
{
  "sessionsCompleted": "You've completed {count} sessions today",
  "welcomeUser": "Welcome {name}!",
  "focusTimeRemaining": "{minutes} minutes remaining"
}
```

**ar.json:**
```json
{
  "sessionsCompleted": "لقد أكملت {count} جلسات اليوم",
  "welcomeUser": "أهلا {name}!",
  "focusTimeRemaining": "{minutes} دقيقة متبقية"
}
```

**Widget:**
```dart
Text(
  AppStrings.sessionsCompleted.tr(args: ['5']),
  // Output: "You've completed 5 sessions today"
)

Text(
  AppStrings.welcomeUser.tr(namedArgs: {'name': userName}),
  // Output: "Welcome Ahmed!"
)
```

### 6. **List & Nested Translations** (Advanced)

For lists of options:

**en.json:**
```json
{
  "ambientSounds": {
    "none": "None",
    "rain": "Rain",
    "forest": "Forest",
    "coffee": "Coffee Shop",
    "library": "Library",
    "mosque": "Mosque"
  }
}
```

**ar.json:**
```json
{
  "ambientSounds": {
    "none": "بدون",
    "rain": "مطر",
    "forest": "غابة",
    "coffee": "مقهى",
    "library": "مكتبة",
    "mosque": "مسجد"
  }
}
```

**Widget:**
```dart
final sounds = [
  Sound(
    name: 'ambientSounds.none'.tr(),
    icon: Icons.volume_off,
  ),
  Sound(
    name: 'ambientSounds.rain'.tr(),
    icon: Icons.cloud_queue,
  ),
];
```

## Translation Workflow

### For English (Default)
1. Add key to `AppStrings`
2. Add English text to `en.json`
3. Use in widget: `Text(AppStrings.key.tr())`

### For Arabic
1. Translate the English text from `en.json`
2. Add translation to `ar.json` with same key
3. Test both languages in app settings

### Checking Coverage

```bash
# Verify all keys in AppStrings have translations
# Run this manually or add to CI/CD

# 1. Extract all keys from app_strings.dart
# 2. Check they exist in en.json and ar.json
# 3. Report missing or orphaned keys
```

## Common Translation Issues

| Issue | Example | Fix |
|-------|---------|-----|
| Missed a string | `Text("Login")` in widget | Add to `AppStrings`, then `Text(AppStrings.login.tr())` |
| Key mismatch | `AppStrings.logn` (typo) | Use correct key: `AppStrings.login` |
| Translation missing | Key exists in `en.json`, not `ar.json` | Add Arabic translation |
| Parameter wrong | `.tr(args: [value])` but no `{0}` in JSON | Add `{0}` or use `namedArgs` |

## Best Practices

✅ **Organize by feature** — Group related strings with comments
✅ **Use descriptive keys** — `welcomeBack` not `msg1`
✅ **Keep translations short** — Especially for UI with space constraints
✅ **Test both languages** — Change language in settings and verify all text appears
✅ **Use context** — If a string could mean two things, make the key more specific
✅ **Avoid UI logic** — Don't put conditional text in strings
✅ **Add placeholders consistently** — Use `{name}` format for all parameters

## Validation Checklist

Before submitting code:

- [ ] All user-facing strings defined in `AppStrings`
- [ ] All strings exist in both `en.json` and `ar.json`
- [ ] No hardcoded strings in widgets
- [ ] All strings use `.tr()` after key
- [ ] Tested with both English and Arabic languages
- [ ] Parameters/placeholders match JSON format
- [ ] No broken translation keys (typos)

## Language Switching

Users can switch language via settings:

```dart
// In Settings widget
BlocBuilder<LanguageCubit, Locale>(
  builder: (context, locale) {
    return ListTile(
      title: Text(AppStrings.language.tr()),
      trailing: DropdownButton<Locale>(
        value: locale,
        onChanged: (Locale? newLocale) {
          if (newLocale != null) {
            context.setLocale(newLocale);
            context.read<LanguageCubit>().changeLanguage(newLocale);
          }
        },
        items: const [
          DropdownMenuItem(value: Locale('en'), child: Text('English')),
          DropdownMenuItem(value: Locale('ar'), child: Text('العربية')),
        ],
      ),
    );
  },
);
```

The `easy_localization` package handles:
- Language switching at runtime
- RTL/LTR text direction for Arabic
- Plural/gender rules (when needed)
- Default fallback to English

## Migration Checklist for New Features

When adding a new feature, localization checklist:

- [ ] Add all UI strings to `AppStrings` (with clear key names)
- [ ] Add English translations to `assets/translations/en.json`
- [ ] Add Arabic translations to `assets/translations/ar.json`
- [ ] Replace all hardcoded strings in widgets with `AppStrings.key.tr()`
- [ ] Test language switching in the new feature
- [ ] Verify no missing translations by checking logs
