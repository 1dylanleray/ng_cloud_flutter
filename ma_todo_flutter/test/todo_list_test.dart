import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('TodoList Widget Tests', () {
    testWidgets('Displays tasks correctly with hardcoded values',
        (WidgetTester tester) async {
      final todoList = [
        {'content': 'Task 1', 'isDone': false},
        {'content': 'Task 2', 'isDone': true},
        {'content': 'Task 3', 'isDone': false},
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
                  final content = todo['content'] ?? '';
                  final isDone = todo['isDone'] ?? false;
                  return ListTile(
                    title: Text(content),
                    subtitle: Text(isDone ? 'Completed' : 'Not Completed'),
                  );
                },
              );
            },
          ),
        ),
      ));

      await tester.pump();

      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Task 3'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Not Completed'), findsNWidgets(2));
    });

    testWidgets('Displays message when no tasks', (WidgetTester tester) async {
      final todoList = <Map<String, dynamic>>[];
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
              if (docs.isEmpty) {
                return const Text('No tasks today');
              }
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

      await tester.pump();

      expect(find.text('No tasks today'), findsOneWidget);
    });
  });
}

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
