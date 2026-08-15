import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/l10n/l10n_extension.dart';
import 'package:flutter_boilerplate/models/todo.dart';
import 'package:flutter_boilerplate/theme/tokens.dart';

/// One row in the todo list: a checkbox, the title (struck through when
/// completed), and a delete button.
class TodoItemTile extends StatelessWidget {
  const TodoItemTile({
    required this.todo,
    required this.onToggle,
    required this.onRemove,
    super.key,
  });

  final Todo todo;
  final VoidCallback onToggle;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Checkbox(value: todo.completed, onChanged: (_) => onToggle()),
          Expanded(
            child: Text(
              todo.title,
              style: textTheme.bodyMedium?.copyWith(
                decoration: todo.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: context.l10n.removeTodoLabel,
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
