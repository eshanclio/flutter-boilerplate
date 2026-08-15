// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get todoListTitle => 'Todos';

  @override
  String get todoListEmpty => 'Nothing to do yet.';

  @override
  String get addTodoHint => 'What needs doing?';

  @override
  String get removeTodoLabel => 'Remove todo';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';
}
