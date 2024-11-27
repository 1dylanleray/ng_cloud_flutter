import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TodoComponent } from './todo.component';
import { TodoService } from '../shared/todo.service';
import { FormsModule } from '@angular/forms';
import { of } from 'rxjs';

describe('TodoComponent', () => {
  let component: TodoComponent;
  let fixture: ComponentFixture<TodoComponent>;
  let todoServiceMock: any;

  beforeEach(() => {
    todoServiceMock = {
      firestoreCollection: {
        valueChanges: jasmine.createSpy('valueChanges').and.returnValue(of([{ id: '1', content: 'Test', isDone: false }])),
      },
      addTodo: jasmine.createSpy('addTodo'),
      deleteTodo: jasmine.createSpy('deleteTodo'),
      updateTodoStatus: jasmine.createSpy('updateTodoStatus'),
    };

    TestBed.configureTestingModule({
      declarations: [TodoComponent],
      imports: [FormsModule],
      providers: [{ provide: TodoService, useValue: todoServiceMock }],
    }).compileComponents();

    fixture = TestBed.createComponent(TodoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('devrait être créé', () => {
    expect(component).toBeTruthy();
  });

  it('devrait afficher la liste des todos', () => {
    const compiled = fixture.nativeElement as HTMLElement;
    expect(compiled.querySelector('ul')?.textContent).toContain('Test');
  });

  it('devrait appeler `addTodo` lorsqu\'une nouvelle tâche est ajoutée', () => {
    const inputElement = fixture.nativeElement.querySelector('input');
    inputElement.value = 'Nouvelle tâche';
    inputElement.dispatchEvent(new Event('input'));

    component.onClick(inputElement);
    expect(todoServiceMock.addTodo).toHaveBeenCalledWith('Nouvelle tâche');
  });

  it('devrait appeler `deleteTodo` lorsqu\'une tâche est supprimée', () => {
    component.onDelete('1');
    expect(todoServiceMock.deleteTodo).toHaveBeenCalledWith('1');
  });
});
