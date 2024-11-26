import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ma_todo_flutter/widgets/todoinput.dart';
import 'package:ma_todo_flutter/widgets/todolist.dart';
import 'package:modular_ui/modular_ui.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarBrightness: Brightness.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(40, 1.2 * kToolbarHeight, 40, 20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                // Permet le défilement
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'My Daily Tasks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.0),
                      child: Divider(
                        color: Colors.white,
                      ),
                    ),
                    MUIPrimaryInputField(
                      borderWidth: 0,
                      suffixIcon: const Icon(
                        CupertinoIcons.search,
                        color: Colors.black,
                      ),
                      hintText: '',
                      filledColor: Colors.white,
                      controller: TextEditingController(text: ''),
                    ),
                    const SizedBox(height: 20),
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
      floatingActionButton: FloatingActionButton.large(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (BuildContext context) {
                final TextEditingController titleController =
                    TextEditingController();
                final TextEditingController descriptionController =
                    TextEditingController();
                return Container(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context)
                          .viewInsets
                          .bottom, // Gère le clavier
                    ),
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: IconButton(
                            icon: const Icon(
                              CupertinoIcons.arrow_down_circle_fill,
                              color: Colors.black,
                              size: 40,
                            ),
                            onPressed: () {
                              Navigator.pop(context); // Ferme la modal
                            },
                          ),
                        ),
                        const MyCustomForm(), // Intègre ton formulaire ici
                      ],
                    ));
              });
        },
        child: const Icon(CupertinoIcons.add_circled_solid),
      ),
    );
  }
}
