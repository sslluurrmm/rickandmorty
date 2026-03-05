# Rick and Morty Character Explorer

Mobile application for browsing characters from the "Rick and Morty" universe with the ability to add them to favorites, switch themes, and offline access to favorite characters.

## Key Features

- View character list with pagination
- Detailed information about each character
- Add/remove characters to/from favorites
- Local storage of favorites using Hive
- Offline mode: when there is no internet connection, favorite characters are displayed
- Switch between light, dark, and system themes
- Sort favorites by name, status, or species

## Technologies and Versions

### Requirements

- **Flutter SDK**: version 3.16.0 or higher (compatible with Dart 3.11.1)
- **Dart SDK**: ^3.11.1

### Main Dependencies

| Package | Version |
|---------|---------|
| flutter_bloc |
| dio | ^5.3.3 |
| hive | ^2.2.3 |
| hive_flutter | ^1.1.0 |
| extended_image | ^10.0.1 |
| equatable | ^2.0.5 |
| intl | ^0.18.1 |
| cupertino_icons | ^1.0.8 |

### Dev Dependencies

| Package | Version |
|---------|---------|
| build_runner | ^2.4.6 |
| hive_generator | ^2.0.1 |
| flutter_lints | ^6.0.0 |

See the full list of dependencies in the [`pubspec.yaml`](pubspec.yaml) file.

## Build and Run Instructions

### 1. Clone the repository

```bash
git clone https://github.com/your-username/rick_and_morty_app.git
cd rick_and_morty_app
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate Hive code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Run the application

```bash
flutter run
```

To build a release version:

- **Android**: flutter build apk
- **iOS**: flutter build ios

## API

The application uses the public [Rick and Morty API](https://rickandmortyapi.com/).  
Main endpoint: `https://rickandmortyapi.com/api/character`