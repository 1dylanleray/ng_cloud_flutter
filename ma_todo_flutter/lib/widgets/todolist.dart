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
            final content = todo['content'] ?? '';
            final isDone = todo['isDone'] ?? false;

            return Row(
              children: [
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
                    // Supprimer l'élément de Firebase
                    FirebaseFirestore.instance
                        .collection('todos')
                        .doc(todos[index].id)
                        .delete();
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
