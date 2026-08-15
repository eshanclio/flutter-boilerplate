import 'package:flutter/widgets.dart';
import 'package:flutter_boilerplate/l10n/generated/app_localizations.dart';

extension L10nContext on BuildContext {
  /// The active [AppLocalizations]. Views must read strings through this
  /// getter rather than calling `AppLocalizations.of(context)` directly, so
  /// there is exactly one idiom in the codebase.
  ///
  /// Non-nullable because `l10n.yaml` sets `nullable-getter: false`. It throws
  /// if [AppLocalizations.localizationsDelegates] is not registered on the
  /// enclosing app — see `lib/main.dart`.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
