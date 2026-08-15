import 'package:flutter_boilerplate/models/todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_list_view_state.freezed.dart';

/// View-ready state for the todo list route.
///
/// Lives in `models/` rather than beside its orchestrator because both the
/// orchestrator (which produces it) and the view (which pattern-matches on
/// it) need the type, and a view may not import `orchestrators/`.
///
/// freezed gives this structural equality including deep list comparison,
/// which is what lets Riverpod skip rebuilding the view when a rebuild
/// produces an equal state.
///
/// Deliberately holds no `isLoading` flag: the provider exposes this type
/// wrapped in an `AsyncValue`, which already models loading and error. A
/// second loading flag here would be a duplicate source of truth that the
/// view has to reconcile.
@freezed
abstract class TodoListViewState with _$TodoListViewState {
  const factory TodoListViewState({required List<Todo> todos}) =
      _TodoListViewState;
}
