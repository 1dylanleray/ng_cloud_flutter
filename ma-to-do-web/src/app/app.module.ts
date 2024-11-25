
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {AngularFireModule} from '@angular/fire/compat';
import { AppComponent } from './app.component';
import { AngularFirestoreModule } from '@angular/fire/compat/firestore';
import { environment } from '../environments/environment';
import { TodoComponent } from './todo/todo.component';
import { TodoService } from './shared/todo.service';

@NgModule({
    declarations: [
        AppComponent,
        TodoComponent
            ],
    imports: [
        BrowserModule,
        AngularFireModule.initializeApp(environment.firebaseConfig),
        AngularFirestoreModule,

    ],
    providers: [TodoService],
    bootstrap: [AppComponent]
})
export class AppModule { }
