import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoInput extends StatelessWidget {
  const TodoInput({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyCustomForm();
  }
}

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() => MyCustomFormState();
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('todos').add({
          'content': _contentController.text,
          'isDone': false, // Par défaut, la tâche n'est pas terminée
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New task saved.')),
        );

        Navigator.pop(context); // Ferme la modale après ajout
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sorry, an error occured.')),
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
              decoration: const InputDecoration(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please write something.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _addTask,
              icon: const Icon(CupertinoIcons.floppy_disk, size: 20),
              label: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
