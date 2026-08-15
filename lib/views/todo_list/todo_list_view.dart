import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/l10n/l10n_extension.dart';
import 'package:flutter_boilerplate/models/todo_list_view_state.dart';
import 'package:flutter_boilerplate/responsive/responsive_layout.dart';
import 'package:flutter_boilerplate/state/todo_list_provider.dart';
import 'package:flutter_boilerplate/theme/tokens.dart';
import 'package:flutter_boilerplate/views/todo_list/components/todo_input_bar.dart';
import 'package:flutter_boilerplate/views/todo_list/components/todo_item_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Maximum content width on tablet and desktop. A full-width list of
/// checkboxes is unreadable on a wide screen.
const _wideContentMaxWidth = 720.0;

/// Runs a mutation and reports failure as a transient [SnackBar].
///
/// Mutation errors are handled here, in the view, and never by writing to the
/// provider's state: a single failed action must not replace an otherwise
/// good list with a full-screen error. This is why `AsyncValue.guard` is
/// forbidden for mutations in `lib/state`.
Future<void> _runAction(
  BuildContext context,
  Future<void> Function() action,
) async {
  try {
    await action();
  } catch (_) {
    // `context` crosses an async gap here, so it may already be defunct.
    if (!context.mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.errorGeneric)));
  }
}

/// The todo list screen. Reads and mutates state exclusively through
/// [todoListNotifierProvider] — never an orchestrator, service, or adapter
/// directly.
class TodoListView extends ConsumerWidget {
  const TodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.todoListTitle)),
      body: ResponsiveLayout(
        mobile: (_) => const _TodoListBody(),
        // desktop is omitted, so it falls back to this.
        tablet: (_) => Center(
          child: ConstrainedBox(
            key: const Key('wideLayout'),
            constraints: const BoxConstraints(maxWidth: _wideContentMaxWidth),
            child: const _TodoListBody(),
          ),
        ),
      ),
    );
  }
}

class _TodoListBody extends ConsumerWidget {
  const _TodoListBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(todoListNotifierProvider);
    final notifier = ref.read(todoListNotifierProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        children: [
          TodoInputBar(
            onSubmit: (title) =>
                _runAction(context, () => notifier.addTodo(title)),
          ),
          Expanded(
            child: switch (todoList) {
              AsyncData(:final TodoListViewState value) => _TodoList(
                state: value,
                notifier: notifier,
              ),
              AsyncError() => Center(child: Text(context.l10n.errorGeneric)),
              _ => const Center(child: CircularProgressIndicator()),
            },
          ),
        ],
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({required this.state, required this.notifier});

  final TodoListViewState state;
  final TodoListNotifier notifier;

  @override
  Widget build(BuildContext context) {
    if (state.todos.isEmpty) {
      return Center(child: Text(context.l10n.todoListEmpty));
    }

    return ListView.builder(
      itemCount: state.todos.length,
      itemBuilder: (context, index) {
        final todo = state.todos[index];
        return TodoItemTile(
          todo: todo,
          onToggle: () =>
              _runAction(context, () => notifier.toggleTodo(todo.id)),
          onRemove: () =>
              _runAction(context, () => notifier.removeTodo(todo.id)),
        );
      },
    );
  }
}
