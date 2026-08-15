// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_router.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Assembles every route into one [GoRouter]. Add a route by creating a
/// `lib/routes/<name>_route.dart` and registering it here.
///
/// This is a provider rather than a top-level constant so redirects and
/// guards can read auth or feature-flag state from `lib/state/` via [ref].

@ProviderFor(appRouter)
final appRouterProvider = AppRouterProvider._();

/// Assembles every route into one [GoRouter]. Add a route by creating a
/// `lib/routes/<name>_route.dart` and registering it here.
///
/// This is a provider rather than a top-level constant so redirects and
/// guards can read auth or feature-flag state from `lib/state/` via [ref].

final class AppRouterProvider
    extends $FunctionalProvider<GoRouter, GoRouter, GoRouter>
    with $Provider<GoRouter> {
  /// Assembles every route into one [GoRouter]. Add a route by creating a
  /// `lib/routes/<name>_route.dart` and registering it here.
  ///
  /// This is a provider rather than a top-level constant so redirects and
  /// guards can read auth or feature-flag state from `lib/state/` via [ref].
  AppRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appRouterHash();

  @$internal
  @override
  $ProviderElement<GoRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GoRouter create(Ref ref) {
    return appRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GoRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GoRouter>(value),
    );
  }
}

String _$appRouterHash() => r'f0fccc536ecf24f164f09942c1431fed32c4b20a';
