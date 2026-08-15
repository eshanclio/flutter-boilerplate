// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(todoService)
final todoServiceProvider = TodoServiceProvider._();

final class TodoServiceProvider
    extends $FunctionalProvider<TodoService, TodoService, TodoService>
    with $Provider<TodoService> {
  TodoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoServiceHash();

  @$internal
  @override
  $ProviderElement<TodoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TodoService create(Ref ref) {
    return todoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoService>(value),
    );
  }
}

String _$todoServiceHash() => r'e7f288aa105dffaf4b4db4a8d3716e524d6a1a93';

@ProviderFor(todoListOrchestrator)
final todoListOrchestratorProvider = TodoListOrchestratorProvider._();

final class TodoListOrchestratorProvider
    extends
        $FunctionalProvider<
          TodoListOrchestrator,
          TodoListOrchestrator,
          TodoListOrchestrator
        >
    with $Provider<TodoListOrchestrator> {
  TodoListOrchestratorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todoListOrchestratorProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListOrchestratorHash();

  @$internal
  @override
  $ProviderElement<TodoListOrchestrator> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TodoListOrchestrator create(Ref ref) {
    return todoListOrchestrator(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TodoListOrchestrator value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TodoListOrchestrator>(value),
    );
  }
}

String _$todoListOrchestratorHash() =>
    r'5ae55c83b63feaf290db067fd74d80775d795c19';

/// State for the todo list route. Thin by design: it delegates every action
/// to [TodoListOrchestrator] and holds no business logic.
///
/// Named explicitly because riverpod_generator would otherwise strip the
/// `Notifier` suffix from the class name and generate `todoListProvider`
/// instead of `todoListNotifierProvider`.
///
/// `retry` is disabled: Riverpod 3's default retry policy would otherwise
/// re-run [build] on a backoff schedule after a storage failure, so a
/// transient error would silently recover instead of surfacing to the UI.

@ProviderFor(TodoListNotifier)
final todoListNotifierProvider = TodoListNotifierProvider._();

/// State for the todo list route. Thin by design: it delegates every action
/// to [TodoListOrchestrator] and holds no business logic.
///
/// Named explicitly because riverpod_generator would otherwise strip the
/// `Notifier` suffix from the class name and generate `todoListProvider`
/// instead of `todoListNotifierProvider`.
///
/// `retry` is disabled: Riverpod 3's default retry policy would otherwise
/// re-run [build] on a backoff schedule after a storage failure, so a
/// transient error would silently recover instead of surfacing to the UI.
final class TodoListNotifierProvider
    extends $AsyncNotifierProvider<TodoListNotifier, TodoListViewState> {
  /// State for the todo list route. Thin by design: it delegates every action
  /// to [TodoListOrchestrator] and holds no business logic.
  ///
  /// Named explicitly because riverpod_generator would otherwise strip the
  /// `Notifier` suffix from the class name and generate `todoListProvider`
  /// instead of `todoListNotifierProvider`.
  ///
  /// `retry` is disabled: Riverpod 3's default retry policy would otherwise
  /// re-run [build] on a backoff schedule after a storage failure, so a
  /// transient error would silently recover instead of surfacing to the UI.
  TodoListNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'todoListNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todoListNotifierHash();

  @$internal
  @override
  TodoListNotifier create() => TodoListNotifier();
}

String _$todoListNotifierHash() => r'e0ebc5e47c69bcfbe26a23e582e61bd8f789280e';

/// State for the todo list route. Thin by design: it delegates every action
/// to [TodoListOrchestrator] and holds no business logic.
///
/// Named explicitly because riverpod_generator would otherwise strip the
/// `Notifier` suffix from the class name and generate `todoListProvider`
/// instead of `todoListNotifierProvider`.
///
/// `retry` is disabled: Riverpod 3's default retry policy would otherwise
/// re-run [build] on a backoff schedule after a storage failure, so a
/// transient error would silently recover instead of surfacing to the UI.

abstract class _$TodoListNotifier extends $AsyncNotifier<TodoListViewState> {
  FutureOr<TodoListViewState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<TodoListViewState>, TodoListViewState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TodoListViewState>, TodoListViewState>,
              AsyncValue<TodoListViewState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
