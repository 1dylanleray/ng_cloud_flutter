import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    // Écouter les données Firestore
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('todos').snapshots(),
      builder: (context, snapshot) {
        // Vérifier si les données sont en cours de chargement
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Vérifier s'il y a des erreurs
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              'Une erreur s\'est produite.',
              style: TextStyle(color: Colors.red),
            ),
          );
        }

        // Vérifier si les données sont disponibles
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

            Future<void> _toggleTaskCompletion(bool? newValue) async {
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

            Future<void> _deleteTask() async {
              try {
                // Suppression de la tâche dans Firestore
                await FirebaseFirestore.instance
                    .collection('todos')
                    .doc(todos[index].id)
                    .delete();

                // Affichage de la snackbar après la suppression réussie
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted.')),
                  );
                }
              } catch (e) {
                // Gestion des erreurs en cas d'échec de la suppression
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
                    _toggleTaskCompletion(newValue);
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
                    // Ajouter votre logique pour modifier la tâche
                  },
                ),
                IconButton(
                  icon: const Icon(
                    CupertinoIcons.trash_circle_fill,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    _deleteTask();
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
