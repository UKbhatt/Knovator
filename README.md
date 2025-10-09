<div align="">

# 📮 MailMan

Robust Flutter app that lists posts, supports read/unread states, offline cache, and a clean modern UI.

![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)
![GetX](https://img.shields.io/badge/GetX-State%20Management-7E57C2)
![Dio](https://img.shields.io/badge/Dio-HTTP%20Client-26A69A)
![Hive](https://img.shields.io/badge/Hive-Local%20Storage-FFB300)

</div>

---

## ✨ Features

- ✅ Fetch posts from API (JSONPlaceholder)
- 📨 Read / Unread indicators with instant UI feedback
- 🔄 Pull-to-refresh
- 📦 Local cache with Hive (posts + read status)
- 🌐 Connectivity-aware sync (shows friendly errors)
- 📱 Clean list and detail UIs with subtle elevation and typography

---

## 🗺️ Architecture

- State management: GetX controllers
- Data: Repository pattern over services
- Local storage: Hive boxes (`postsBox`, `readBox`, `metaBox`)
- UI: Widgets in modules with lightweight, reactive views

```
lib/
  app.dart                     # GetMaterialApp bootstrapping
  main.dart                    # Hive init + first-run setup
  core/
    binding/InitialBinding.dart
    routes/AppRoutes.dart
    theme/AppTheme.dart
    utils/Failure.dart, Results.dart
  data/
    models/ModelPost.dart
    repositories/PostRepository.dart
    services/ApiService.dart, HiveService.dart, ConnectionService.dart
  modules/
    Post/
      controllers/PostController.dart
      views/PostPage.dart
      widgets/PostTile.dart
    PostDetails/
      controllers/PostDetailController.dart
      view/PostDetailPage.dart
  widgets/
    Error.view.dart, Loading.view.dart
```

---

## 🚀 Quick Start

1) Prerequisites
- Flutter 3.22+ and Dart 3.8+
- Android Studio/Xcode for mobile targets

2) Install dependencies
```bash
flutter pub get
```

3) Run
```bash
flutter run 
```

---

## 💾 Caching & Read State

- Boxes opened at startup (`main.dart`):
  - `postsBox`: list of posts as maps under key `posts`
  - `readBox`: list of read post IDs under key `readIds`
  - `metaBox`: misc metadata

- First-run experience: `main.dart` ensures new installs start with zero read posts by clearing `readIds` once.

- Mark as read: tapping a post marks it read immediately (UI updates via reactive `readIds`).

- Offline/Errors: user-friendly messages are surfaced for connectivity/errors. If sync fails and the list is empty, the controller attempts to show cached posts (when available) to avoid a blank screen.

---


## 🖌️ UI Details

- List
  - Unread uses soft amber background and an unread icon badge
  - Read uses white background with a green read icon
  - Header displays compact Unread / Read counters

- Detail
  - Modern card layout with rounded corners, border, soft shadow
  - Title with strong weight, small metadata line, relaxed body line-height

---

## 🛟 Troubleshooting

- Android requests fail
  - Verify Internet permission exists in `AndroidManifest.xml`
  - Check emulator/device connectivity

- Empty list on start
  - Pull to refresh to fetch from API
  - Check console for connectivity messages

---

## 📚 Tech Stack

- Flutter, Dart
- GetX (state, DI, routes)
- Dio (HTTP)
- Hive (local storage)

---

## 👨‍💻 Contributing
#### 💡 Want to improve this project? Feel free to contribute!<br>
1.Fork the repository<br>
2.Create a new branch (git checkout -b feature/your-feature)<br>
3.Make your changes and commit (git commit -am 'Added a new feature')<br>
4.Push the branch (git push origin feature/your-feature)<br>
5.Submit a Pull Request<br> 

---

## 🌍 Contact
**💻 Author: Utkarsh**<br>
**📧 Email: ubhatt2004@gmail.com**<br>
**🐙 GitHub: https://github.com/UKbhatt**<br>
