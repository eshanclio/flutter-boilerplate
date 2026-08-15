import 'package:flutter_boilerplate/views/todo_list/todo_list_view.dart';
import 'package:go_router/go_router.dart';

/// The todo list route: its path, its name, and the view it renders. No
/// business logic and no state — one file per route, registered in
/// `app_router.dart`.
abstract final class TodoListRoute {
  static const String path = '/';
  static const String name = 'todoList';

  static GoRoute get route => GoRoute(
    path: path,
    name: name,
    builder: (context, state) => const TodoListView(),
  );
}
