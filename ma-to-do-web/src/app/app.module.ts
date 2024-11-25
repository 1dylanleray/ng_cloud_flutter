
import { NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import {AngularFireModule} from '@angular/fire/compat';
import { AppComponent } from './app.component';
import { environment } from '../environments/environment';
import { TodoComponent } from './todo/todo.component';
import { CUSTOM_ELEMENTS_SCHEMA } from '@angular/core';

@NgModule({
    declarations: [
        AppComponent,
            ],
    imports: [
        BrowserModule,
        AngularFireModule.initializeApp(environment.firebaseConfig),

    ],
    schemas: [CUSTOM_ELEMENTS_SCHEMA],
    providers: [],
    bootstrap: [TodoComponent]
})
export class AppModule { }
