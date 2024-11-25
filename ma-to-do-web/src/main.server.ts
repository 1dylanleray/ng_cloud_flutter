import { bootstrapApplication } from '@angular/platform-browser';
import { enableProdMode } from '@angular/core';
import { environment } from './environments/environment';

if (environment.production) {
  enableProdMode();
}

console.log('Application is bootstrapping...'); 
import { AppComponent } from './app/app.component';
import { config } from './app/app.config.server';

const bootstrap = () => bootstrapApplication(AppComponent, config);

export default bootstrap;
