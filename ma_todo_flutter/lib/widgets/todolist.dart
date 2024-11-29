import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_todo_flutter/widgets/todoinput.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('todos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Une erreur s\'est produite.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No tasks today, get some rest',
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        // Récupérer les tâches
        final todos = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index].data() as Map<String, dynamic>;
            final taskId = todos[index].id;
            final content = todo['content'] ?? '';
            final isDone = todo['isDone'] ?? false;

            Future<void> toggleTaskCompletion(bool? newValue) async {
              try {
                await FirebaseFirestore.instance
                    .collection('todos')
                    .doc(taskId)
                    .update({'isDone': newValue});
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to update task: $e'),
                    ),
                  );
                }
              }
            }

            Future<void> deleteTask() async {
              try {
                await FirebaseFirestore.instance
                    .collection('todos')
                    .doc(todos[index].id)
                    .delete();

                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted.')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete task: $e')),
                  );
                }
              }
            }

            return Row(
              children: [
                Checkbox(
                  value: isDone,
                  onChanged: (newValue) {
                    toggleTaskCompletion(newValue);
                  },
                  activeColor: Colors.green,
                  shape: CircleBorder(),
                ),
                Expanded(
                  child: Text(
                    content,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: isDone ? Colors.green : Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.pencil_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16,
                            bottom:
                                MediaQuery.of(context).viewInsets.bottom + 16,
                          ),
                          child: TodoInput(
                            taskId: taskId,
                            initialContent: content,
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.trash_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    deleteTask();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
