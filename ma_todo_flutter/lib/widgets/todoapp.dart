import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ma_todo_flutter/widgets/todoinput.dart';
import 'package:ma_todo_flutter/widgets/todolist.dart';
import 'package:modular_ui/modular_ui.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.8),
        elevation: 10,
        centerTitle: false,
        title: const Text(
          'My Daily Tasks',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, kToolbarHeight + 30, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MUIPrimaryInputField(
                      borderWidth: 0,
                      suffixIcon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                      hintText: '',
                      filledColor: Colors.white,
                      controller: TextEditingController(),
                    ),
                    const SizedBox(height: 10),
                    const TodoList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.large(
      foregroundColor: Colors.white,
      backgroundColor: Colors.transparent,
      onPressed: () => _showAddTaskModal(context),
      child: const Icon(CupertinoIcons.add_circled_solid),
    );
  }

  void _showAddTaskModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildModalCloseButton(context),
              const CreateTaskForm(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: IconButton(
        icon: const Icon(
          CupertinoIcons.arrow_down_circle_fill,
          color: Colors.black,
          size: 40,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
