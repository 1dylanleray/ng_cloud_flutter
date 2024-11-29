# MyDailyTasks - Daily Task Manager

## 🚀 Overview

- MyDailyTasks est un projet porté sur deux applications basées sur un backend commun.
- L'idée, c'est d'avoir un outil épuré et minimaliste pour gérer chaque petite tâche du quotidien.

## 🌟 Features

- 🖊️ Add Tasks: Quickly add new tasks with a floating action button.
- ✅ Mark as Completed: Track progress by marking tasks as done.
- 🔄 Edit Tasks: Update task content directly with an intuitive editor.
- ❌ Delete Tasks: Remove tasks you no longer need.
- 🔍 Search: Easily find tasks with a powerful search bar.
- 📡 Real-time Updates: Tasks are stored in Firebase, syncing across all your devices in real-time.

## 🛠️ Technologies Used

### Web

- Frontend: Angular
- Backend: Firebase Firestore
- Tests: Karma

### Mobile

- Frontend: Flutter
- Backend: Firebase Firestore
- Tests: flutter_test, fake_cloud_firestore et mockito
- UI Library: Modular UI

# 🔧 Getting Started

1. Clone the Repository \
   `git clone [repo-url]`
2. Install Dependencies and launch apps

- `cd ma-to-do-web/`
- `npm install`
- `ng serve`

- `cd ..`
- `cd ma_todo_flutter/`
- `flutter pub get`
- `flutter run`

3. Configure Firebase

- Allez dans la console Firebase. Créez un nouveau projet Firebase. Configurez Firestore dans mode test (pour le développement uniquement). Ajoutez une application Web (Web App) et récupérez la configuration Firebase.
- Mettre à jour la configuration Firebase :

- Modifiez le fichier src/environments/environment.ts :
  ```typescript
  export const environment = {
    production: false,
    firebaseConfig: {
      apiKey: "votre-api-key",
      authDomain: "votre-projet.firebaseapp.com",
      projectId: "votre-id-projet",
      storageBucket: "votre-projet.appspot.com",
      messagingSenderId: "votre-id-messaging",
      appId: "votre-app-id",
    },
  };
  ```

## 💡 Future Improvements

- 📅 Add login and assignation by user.
- 📊 Add task searching feature.

# 📄 License

This project is licensed under the MIT License.
