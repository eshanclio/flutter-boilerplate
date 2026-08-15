import 'package:flutter_boilerplate/routes/todo_list_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ignore: unnecessary_import
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// Assembles every route into one [GoRouter]. Add a route by creating a
/// `lib/routes/<name>_route.dart` and registering it here.
///
/// This is a provider rather than a top-level constant so redirects and
/// guards can read auth or feature-flag state from `lib/state/` via [ref].
@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
  initialLocation: TodoListRoute.path,
  routes: [TodoListRoute.route],
);
