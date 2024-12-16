// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Timer Settings`
  String get timerSettings {
    return Intl.message(
      'Timer Settings',
      name: 'timerSettings',
      desc: '',
      args: [],
    );
  }

  /// `Focus Duration(min)`
  String get focusDuration {
    return Intl.message(
      'Focus Duration(min)',
      name: 'focusDuration',
      desc: '',
      args: [],
    );
  }

  /// `Short Break Duration(min)`
  String get breakDuration {
    return Intl.message(
      'Short Break Duration(min)',
      name: 'breakDuration',
      desc: '',
      args: [],
    );
  }

  /// `General Settings`
  String get generalSettings {
    return Intl.message(
      'General Settings',
      name: 'generalSettings',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `How to Use`
  String get howToUse {
    return Intl.message(
      'How to Use',
      name: 'howToUse',
      desc: '',
      args: [],
    );
  }

  /// `About Silent Space`
  String get about {
    return Intl.message(
      'About Silent Space',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get categories {
    return Intl.message(
      'Categories',
      name: 'categories',
      desc: '',
      args: [],
    );
  }

  /// `Rate Us`
  String get RateUs {
    return Intl.message(
      'Rate Us',
      name: 'RateUs',
      desc: '',
      args: [],
    );
  }

  /// `Share Silent Space`
  String get share {
    return Intl.message(
      'Share Silent Space',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Focus Time`
  String get focusTime {
    return Intl.message(
      'Focus Time',
      name: 'focusTime',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message(
      'Today',
      name: 'today',
      desc: '',
      args: [],
    );
  }

  /// `Summary`
  String get summary {
    return Intl.message(
      'Summary',
      name: 'summary',
      desc: '',
      args: [],
    );
  }

  // skipped getter for the 'focasTime(min)' key

  /// `Focus Count`
  String get focusCount {
    return Intl.message(
      'Focus Count',
      name: 'focusCount',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `How to configure notification?`
  String get configurwNotificationQuestion {
    return Intl.message(
      'How to configure notification?',
      name: 'configurwNotificationQuestion',
      desc: '',
      args: [],
    );
  }

  /// `1. الخطوات التالية مخصصة لهواتف/أجهزة Android. إذا كنت تستخدم iPhone/Mac/iPad، يمكنك إعداد الإشعارات من إعدادات التطبيق.\n2. الخطوات مخصصة للإصدارات الأحدث من 1.3.2 فقط. قمنا بتحديث الإشعارات لتحسين عمل تطبيق Foca في الخلفية.\n3. تعتمد الإشعارات على إعدادات نظام Android.`
  String get configurwNotificationAnswer {
    return Intl.message(
      '1. الخطوات التالية مخصصة لهواتف/أجهزة Android. إذا كنت تستخدم iPhone/Mac/iPad، يمكنك إعداد الإشعارات من إعدادات التطبيق.\n2. الخطوات مخصصة للإصدارات الأحدث من 1.3.2 فقط. قمنا بتحديث الإشعارات لتحسين عمل تطبيق Foca في الخلفية.\n3. تعتمد الإشعارات على إعدادات نظام Android.',
      name: 'configurwNotificationAnswer',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mail...`
  String get enterYourMail {
    return Intl.message(
      'Enter your mail...',
      name: 'enterYourMail',
      desc: '',
      args: [],
    );
  }

  /// `Enter your feedback here...`
  String get enterYourFeedback {
    return Intl.message(
      'Enter your feedback here...',
      name: 'enterYourFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message(
      'Send',
      name: 'send',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your feedback!`
  String get noFeedbackError {
    return Intl.message(
      'Please enter your feedback!',
      name: 'noFeedbackError',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your mail!`
  String get noMailErro {
    return Intl.message(
      'Please enter your mail!',
      name: 'noMailErro',
      desc: '',
      args: [],
    );
  }

  /// `Feedback sent successfully!`
  String get feedbackSent {
    return Intl.message(
      'Feedback sent successfully!',
      name: 'feedbackSent',
      desc: '',
      args: [],
    );
  }

  /// `Failed to send feedback, please try again`
  String get feedbackNotSent {
    return Intl.message(
      'Failed to send feedback, please try again',
      name: 'feedbackNotSent',
      desc: '',
      args: [],
    );
  }

  /// `Ambient Sound`
  String get ambientSound {
    return Intl.message(
      'Ambient Sound',
      name: 'ambientSound',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message(
      'None',
      name: 'none',
      desc: '',
      args: [],
    );
  }

  /// `Waves`
  String get tide {
    return Intl.message(
      'Waves',
      name: 'tide',
      desc: '',
      args: [],
    );
  }

  /// `Forest`
  String get forest {
    return Intl.message(
      'Forest',
      name: 'forest',
      desc: '',
      args: [],
    );
  }

  /// `Cafe`
  String get cafe {
    return Intl.message(
      'Cafe',
      name: 'cafe',
      desc: '',
      args: [],
    );
  }

  /// `Storm`
  String get storm {
    return Intl.message(
      'Storm',
      name: 'storm',
      desc: '',
      args: [],
    );
  }

  /// `Clock`
  String get clock {
    return Intl.message(
      'Clock',
      name: 'clock',
      desc: '',
      args: [],
    );
  }

  /// `Bonfire`
  String get bonfire {
    return Intl.message(
      'Bonfire',
      name: 'bonfire',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get books {
    return Intl.message(
      'Books',
      name: 'books',
      desc: '',
      args: [],
    );
  }

  /// `Grass`
  String get grass {
    return Intl.message(
      'Grass',
      name: 'grass',
      desc: '',
      args: [],
    );
  }

  /// `Mosque`
  String get mosque {
    return Intl.message(
      'Mosque',
      name: 'mosque',
      desc: '',
      args: [],
    );
  }

  /// `Library`
  String get library {
    return Intl.message(
      'Library',
      name: 'library',
      desc: '',
      args: [],
    );
  }

  /// `Stream`
  String get stream {
    return Intl.message(
      'Stream',
      name: 'stream',
      desc: '',
      args: [],
    );
  }

  /// `Sound Level`
  String get soundLevel {
    return Intl.message(
      'Sound Level',
      name: 'soundLevel',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
