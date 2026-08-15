import 'package:flutter_boilerplate/models/todo_list_view_state.dart';
import 'package:flutter_boilerplate/orchestrators/todo_list_orchestrator.dart';
import 'package:flutter_boilerplate/services/todo_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ignore: unnecessary_import
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'todo_list_provider.g.dart';

Duration? _noRetry(int retryCount, Object error) => null;

@riverpod
TodoService todoService(Ref ref) =>
    TodoService(ref.watch(todoStorageAdapterProvider));

@riverpod
TodoListOrchestrator todoListOrchestrator(Ref ref) =>
    TodoListOrchestrator(ref.watch(todoServiceProvider));

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
@Riverpod(name: 'todoListNotifierProvider', retry: _noRetry)
class TodoListNotifier extends _$TodoListNotifier {
  @override
  Future<TodoListViewState> build() =>
      ref.watch(todoListOrchestratorProvider).loadTodos();

  Future<void> addTodo(String title) => _run((it) => it.addTodo(title));

  Future<void> toggleTodo(String id) => _run((it) => it.toggleTodo(id));

  Future<void> removeTodo(String id) => _run((it) => it.removeTodo(id));

  /// Assigns the orchestrator's result directly rather than wrapping it in
  /// `AsyncValue.guard`. Guarding a mutation would make one failed action
  /// render the whole screen as an error; `guard` belongs in [build] only.
  Future<void> _run(
    Future<TodoListViewState> Function(TodoListOrchestrator) action,
  ) async {
    state = AsyncData(await action(ref.read(todoListOrchestratorProvider)));
  }
}
