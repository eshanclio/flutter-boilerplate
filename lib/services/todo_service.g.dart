// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The storage boundary. Override this in tests, or swap the implementation
/// here to change how todos persist.

@ProviderFor(todoStorageAdapter)
final todoStorageAdapterProvider = TodoStorageAdapterProvider._();

/// The storage boundary. Override this in tests, or swap the implementation
/// here to change how todos persist.

final class TodoStorageAdapterProvider
    extends
        $FunctionalProvider<
          TodoStorageAdapter,
          TodoStorageAdapter,
          TodoStorageAdapter
        >
    with $Provider<TodoStorageAdapter> {
  /// The storage boundary. Override this in tests, or swap the implementation
  /// here to change how todos persist.
  TodoStorageAdapterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoStorageAdapterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoStorageAdapterHash();

  @$internal
  @override
  $ProviderElement<TodoStorageAdapter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TodoStorageAdapter create(Ref ref) {
    return todoStorageAdapter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoStorageAdapter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoStorageAdapter>(value),
    );
  }
}

String _$todoStorageAdapterHash() =>
    r'217efe380051d31501fb72a10f8cf29100f28a6c';
