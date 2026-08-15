import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/l10n/l10n_extension.dart';
import 'package:flutter_boilerplate/theme/tokens.dart';

/// Text field plus submit button for adding a todo. Both the keyboard's done
/// action and the button call [onSubmit] with the trimmed title, then clear
/// the field. Blank input is ignored.
class TodoInputBar extends StatefulWidget {
  const TodoInputBar({required this.onSubmit, super.key});

  final ValueChanged<String> onSubmit;

  @override
  State<TodoInputBar> createState() => _TodoInputBarState();
}

class _TodoInputBarState extends State<TodoInputBar> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    widget.onSubmit(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(hintText: context.l10n.addTodoHint),
              onSubmitted: (_) => _submit(),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          IconButton(icon: const Icon(Icons.add), onPressed: _submit),
        ],
      ),
    );
  }
}
