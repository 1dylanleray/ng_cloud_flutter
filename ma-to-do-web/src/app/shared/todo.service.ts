import { Injectable } from '@angular/core';
import { AngularFirestore, AngularFirestoreCollection } from '@angular/fire/compat/firestore';

@Injectable({
  providedIn: 'root'
})
export class TodoService {
  firestoreCollection: AngularFirestoreCollection;

  constructor(private firestore: AngularFirestore) {
    this.firestoreCollection = this.firestore.collection('todos');
  }

  addTodo(title: string) {
    return this.firestoreCollection.add({ title, isDone: false });
  }
}
