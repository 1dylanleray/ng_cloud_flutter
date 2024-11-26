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

  constructor(private todoService: TodoService) {}

  ngOnInit(): void {
    this.todoService.firestoreCollection
      .valueChanges({ idField: 'id' })
      .subscribe((items) => {
        this.todos = items.map((item: any) => ({
          ...item,
          isEditing: false, // Ajout du mode édition par défaut
          newTitle: item.title, // Pré-remplir avec le titre existant
        }));
        this.todos.sort((a: any, b: any) => a.isDone - b.isDone); // Trier les tâches
      });
  }

  // Ajoute une nouvelle tâche
  onClick(titleInput: HTMLInputElement): void {
    if (titleInput.value) {
      this.todoService.addTodo(titleInput.value);
      titleInput.value = ''; // Réinitialise le champ
      this.showForm = false; // Cache le formulaire si actif
    }
  }

  // Change le statut de la tâche
  onStatusChange(id: string, newStatus: boolean): void {
    this.todoService.updateTodoStatus(id, newStatus);
  }

  // Supprime une tâche
  onDelete(id: string): void {
    this.todoService.deleteTodo(id);
  }

  // Affiche ou masque le formulaire
  toggleForm(): void {
    this.showForm = !this.showForm;
  }

  // Ajoute une tâche depuis le formulaire
  onSubmitForm(formValues: { field1: string }): void {
    this.todoService.addTodo(formValues.field1);
    this.showForm = false; // Cache le formulaire
  }

  // Active le mode édition
  enableEdit(item: any): void {
    item.isEditing = true; // Passe la tâche en mode édition
  }

  // Annule le mode édition
  cancelEdit(item: any): void {
    item.isEditing = false; // Désactive le mode édition
    item.newTitle = item.title; // Réinitialise le titre
  }

  // Soumet les modifications de la tâche
  onEditSubmit(item: any): void {
    if (item.newTitle.trim()) {
      this.todoService.updateTodoTitle(item.id, item.newTitle).then(() => {
        item.title = item.newTitle; // Met à jour le titre localement
        item.isEditing = false; // Désactive le mode édition
      });
    }
  }
}
