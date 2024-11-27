import { Component, OnInit } from '@angular/core';
import { TodoService } from '../shared/todo.service';

@Component({
  selector: 'app-todo',
  templateUrl: './todo.component.html',
  styles: [],
})
export class TodoComponent implements OnInit {
  todos: any[] = [];
  showForm: boolean = false;
  showAlert: boolean = false;
  showAlertDelete : boolean = false;

  constructor(private todoService: TodoService) {}

  ngOnInit(): void {
    this.todoService.firestoreCollection
      .valueChanges({ idField: 'id' })
      .subscribe((items) => {
        this.todos = items.map((item: any) => ({
          ...item,
          isEditing: false,
          newContent: item.content,
        }));
        this.todos.sort((a: any, b: any) => a.isDone - b.isDone);
      });
  }

  // Ajoute une nouvelle tâche
  onClick(content: HTMLInputElement): void {
    if (content.value) {
      this.todoService.addTodo(content.value);
      content.value = '';
      this.showForm = false;
      this.showAlert = true;
      setTimeout(() => {
        this.showAlert = false;
      }, 3000);
    }
  }

  // Change le statut de la tâche
  onStatusChange(id: string, newStatus: boolean): void {
    this.todoService.updateTodoStatus(id, newStatus);
  }

  // Supprime une tâche
  onDelete(id: string): void {
    this.todoService.deleteTodo(id);
    this.showAlertDelete = true;
      setTimeout(() => {
        this.showAlertDelete = false;
      }, 3000);
  }

  // Affiche ou masque le formulaire
  toggleForm(): void {
    this.showForm = !this.showForm;
  }

  // Ajoute une tâche depuis le formulaire
  onSubmitForm(formValues: { field1: string }): void {
    this.todoService.addTodo(formValues.field1);
    this.showForm = false;
  }

  // Active le mode édition
  enableEdit(item: any): void {
    item.isEditing = true;
  }

  // Annule le mode édition
  cancelEdit(item: any): void {
    item.isEditing = false;
    item.newContent = item.content;
  }

  // Soumet les modifications de la tâche
  onEditSubmit(item: any): void {
    if (item.newContent.trim()) {
      this.todoService.updateTodoTitle(item.id, item.newContent).then(() => {
        item.content = item.newContent;
        item.isEditing = false;
      });
    }
  }
}
