import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_todo_flutter/widgets/todoinput.dart';

class MockFirestoreInstance extends Mock implements FirebaseFirestore {}

void main() {
  group('CreateTaskForm Widget Tests', () {
    late FakeFirebaseFirestore mockFirestore;

    setUp(() {
      mockFirestore = FakeFirebaseFirestore();
    });

    testWidgets(
        'Initializes with pre-filled content when initialContent is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CreateTaskForm(initialContent: 'Test Task'),
        ),
      ));

      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('Shows error message when content is empty',
        (WidgetTester tester) async {
      // Créez le widget sans contenu initial
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CreateTaskForm(),
        ),
      ));

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(find.text('Please write something.'), findsOneWidget);
    });

    testWidgets('Saves a new task to Firestore', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CreateTaskForm(),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'New Task');

      await tester.tap(find.text('Save'));
      await tester.pump();

      final tasks = await mockFirestore.collection('todos').get();
      expect(tasks.docs.isNotEmpty, true);
      expect(tasks.docs.first['content'], 'New Task');
    });

    testWidgets('Updates an existing task in Firestore',
        (WidgetTester tester) async {
      final taskRef = await mockFirestore
          .collection('todos')
          .add({'content': 'Old Task', 'isDone': false});

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CreateTaskForm(
            taskId: taskRef.id,
            initialContent: 'Old Task',
          ),
        ),
      ));

      await tester.enterText(find.byType(TextFormField), 'Updated Task');
      await tester.tap(find.text('Save'));
      await tester.pump();

      final updatedTask =
          await mockFirestore.collection('todos').doc(taskRef.id).get();
      expect(updatedTask['content'], 'Updated Task');
    });
  });
}
