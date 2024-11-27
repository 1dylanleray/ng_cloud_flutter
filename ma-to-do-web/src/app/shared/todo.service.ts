import { Injectable } from '@angular/core';
import {AngularFirestore, AngularFirestoreCollection} from '@angular/fire/compat/firestore'

@Injectable({
  providedIn: 'root'
})
export class TodoService {
  firestoreCollection : AngularFirestoreCollection;

  constructor(private firestore: AngularFirestore) {
    this.firestoreCollection = firestore.collection('todos');
   }

   addTodo(content: string){
     this.firestoreCollection.add({
       content,
       isDone : false
     })
   }

   updateTodoStatus(id:string, newStatus:boolean){
     this.firestoreCollection.doc(id).update({isDone:newStatus});
   }

   deleteTodo(id:string){
     this.firestoreCollection.doc(id).delete();
   }
   updateTodoTitle(id: string, newContent: string): Promise<void> {
    return this.firestoreCollection.doc(id).update({ content: newContent });
  }
  
}
