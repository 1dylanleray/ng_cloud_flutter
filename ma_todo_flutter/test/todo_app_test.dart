import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_todo_flutter/widgets/todoinput.dart';
import 'package:ma_todo_flutter/widgets/todolist.dart';
import 'package:ma_todo_flutter/widgets/todoapp.dart';
import 'package:mockito/mockito.dart';
import 'package:modular_ui/modular_ui.dart';

class QuerySnapshotFake extends Fake implements QuerySnapshot {
  final List<Map<String, dynamic>> data;
  QuerySnapshotFake(this.data);

  @override
  List<DocumentSnapshot> get docs {
    return data.map((dataMap) {
      return DocumentSnapshotFake(dataMap);
    }).toList();
  }
}

class DocumentSnapshotFake extends Fake implements DocumentSnapshot {
  final Map<String, dynamic> dataMap;
  DocumentSnapshotFake(this.dataMap);

  @override
  Map<String, dynamic> get data => dataMap;
}

void main() {
  group('TodoApp Tests', () {
    testWidgets('AppBar contains the correct title',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TodoApp()));

      expect(find.text('My Daily Tasks'), findsOneWidget);
    });

    testWidgets('FloatingActionButton triggers bottom sheet on press',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TodoApp()));

      expect(find.byType(FloatingActionButton), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));

      await tester.pumpAndSettle();

      expect(find.byType(CreateTaskForm), findsOneWidget);
    });

    testWidgets('TodoList is displayed with tasks',
        (WidgetTester tester) async {
      final todoList = [
        {'content': 'Task 1', 'isDone': false},
        {'content': 'Task 2', 'isDone': true},
      ];

      final StreamController<QuerySnapshot> controller = StreamController();
      final QuerySnapshot snapshot = QuerySnapshotFake(todoList);
      controller.add(snapshot);

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: StreamBuilder<QuerySnapshot>(
            stream: controller.stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return const Text('Error');
              }
              final docs = snapshot.data?.docs ?? [];
              return ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final todo = docs[index].data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(todo['content']),
                  );
                },
              );
            },
          ),
        ),
      ));

      await tester.pumpAndSettle();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
    });

    testWidgets('Search input field is displayed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: TodoApp()));

      expect(find.byType(MUIPrimaryInputField), findsOneWidget);
    });
  });
}
