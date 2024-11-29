import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoInput extends StatelessWidget {
  final String? taskId;
  final String? initialContent;

  const TodoInput({
    super.key,
    this.taskId,
    this.initialContent,
  });

  @override
  Widget build(BuildContext context) {
    return CreateTaskForm(
      taskId: taskId,
      initialContent: initialContent,
    );
  }
}

class CreateTaskForm extends StatefulWidget {
  final String? taskId;
  final String? initialContent;

  const CreateTaskForm({
    super.key,
    this.taskId,
    this.initialContent,
  });
  @override
  CreateTaskFormState createState() => CreateTaskFormState();
}

class CreateTaskFormState extends State<CreateTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.initialContent != null) {
      _contentController.text = widget.initialContent!;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> saveTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.taskId == null) {
          await FirebaseFirestore.instance.collection('todos').add({
            'content': _contentController.text,
            'isDone': false,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('New task saved.')),
          );
        } else {
          await FirebaseFirestore.instance
              .collection('todos')
              .doc(widget.taskId)
              .update({'content': _contentController.text});

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Task updated successfully.')),
          );
        }

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _contentController,
              maxLength: 20,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Task Content',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write something.';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextButton.icon(
              onPressed: saveTask,
              icon: const Icon(
                CupertinoIcons.floppy_disk,
                size: 20,
                color: Colors.black,
              ),
              label: const Text(
                'Save',
                style: TextStyle(color: Colors.black),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
