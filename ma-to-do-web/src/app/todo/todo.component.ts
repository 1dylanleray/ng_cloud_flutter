import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { TodoService } from '../shared/todo.service';

@Component({
  selector: 'app-todo',
  imports: [CommonModule],
  templateUrl: './todo.component.html',
  styles: [],
})
export class TodoComponent implements OnInit {
  todos: { title: string; isDone: boolean }[] = [];
  constructor(private todoService: TodoService) { }
  ngOnInit(): void {

  }
  onClick(titleInput: HTMLInputElement) {
    if (titleInput.value) {
      this.todoService.addTodo(titleInput.value);
      titleInput.value = "";
    }
  }
}
