# Rick and Morty Character App

A Flutter application for the Effective Mobile test assignment. The app fetches characters from the Rick and Morty API and supports pagination, offline caching, favorites management, theming, and search/sort functionality.

---

## Table of contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Requirements](#requirements)
- [Getting started](#getting-started)
- [Development workflow](#development-workflow)
- [Project structure](#project-structure)
- [Behavior & notes](#behavior--notes)
- [Screenshots](#screenshots)
- [Contributing](#contributing)
- [License](#license)

---

## Features
- Clean Architecture: separation of Domain, Data, and Presentation layers
- State management: BLoC (flutter_bloc)
- Offline mode: caches characters using Hive
- Pagination: infinite scrolling
- Favorites: add/remove favorites persisted locally
- Dark mode: toggleable theme
- Search & Sort: sort favorites by name or status

---

## Tech stack
- Flutter: 3.x
- Dart: 3.x
- Networking: dio (5.4.0)
- State: flutter_bloc (8.1.3)
- Local DB: hive (2.2.3)
- Dependency injection: get_it (7.6.0)
- Code generation: build_runner, freezed

---

## Requirements
- Flutter SDK (3.x) and Dart (3.x)
- Platform tooling (Android SDK / Xcode) for device/emulator
- Recommended: a recent IDE (VS Code, Android Studio)

---

## Getting started

1. Clone the repository
```bash
git clone [https://github.com/inositols/Rick-and-Morty-API.git]
cd rick_and_morty_app
```

2. Install dependencies
```bash
flutter pub get
```

3. Generate code (Hive adapters, freezed, etc.)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app
```bash
flutter run
```

---

## Development workflow

- Add new models: update freezed classes and Hive type adapters.
- Run code generation after model changes:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
- Use BLoC for state changes; follow existing patterns in the `presentation` layer.

---

## Project structure (high level)
- lib/
    - domain/        # business logic, use cases, entities
    - data/          # repositories, data sources, models
    - presentation/  # UI, widgets, BLoCs
    - core/          # common utilities, constants, DI
- assets/          # images, fonts
- test/            # unit/widget tests

---

## Behavior & notes
- Pagination: implemented as infinite scrolling; additional pages fetched as the user scrolls.
- Offline: loaded characters are cached in Hive to allow offline browsing.
- Favorites: stored locally using Hive; favorites can be sorted by name or status.
- Theme: toggleable dark/light mode persisted across launches.

---

## Screenshots
(Replace the placeholders with actual images)
- assets/screenshots/home.png
- assets/screenshots/favorite.png
- assets/screenshots/theme.png

---

## Contributing
- Fork the repository, create a feature branch, and submit a PR.
- Keep changes small and focused; include tests where applicable.

---

## License
Specify your project license here (e.g., MIT). Update LICENSE file accordingly.

---
If you need specific edits (badges, CI instructions, or to correct package names/versions), provide details and it will be updated.