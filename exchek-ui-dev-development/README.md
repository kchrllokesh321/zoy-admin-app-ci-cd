# Exchek

[![Flutter Version](https://img.shields.io/badge/Flutter-3.32.0-blue.svg)](https://flutter.dev/)
[![Dart SDK](https://img.shields.io/badge/Dart-3.8.0-blue.svg)](https://dart.dev/)
[![Android](https://img.shields.io/badge/Android-Supported-3DDC84.svg?logo=android&logoColor=white)](https://flutter.dev/)
[![iOS](https://img.shields.io/badge/iOS-Supported-000000.svg?logo=apple&logoColor=white)](https://flutter.dev/)
[![Web](https://img.shields.io/badge/Web-Supported-4285F4.svg?logo=google-chrome&logoColor=white)](https://flutter.dev/)


## 📱 Overview
Exchek is a comprehensive B2B and B2C financial application designed to simplify cross-border transactions and currency exchange. The platform enables users to make international payments, convert currencies, and track transactions seamlessly.

## 🏗️ Project Structure (MVVM)

```
├── core/
│   ├── api_config/      # API configuration and endpoints
│   ├── app/             # App-level configurations
│   ├── check_connection/ # Network connectivity utilities
│   ├── flavor_config/   # Environment configuration
│   ├── generated/       # Auto-generated code
│   ├── global/          # Global constants and variables
│   ├── l10n/            # Localization resources
│   ├── routes/          # Navigation routes
│   ├── responsive_helper/ # Manage Responsive Ui
│   ├── themes/          # App themes and styling
│   └── utils/           # Utility functions
├── main/                # Entry points
│   ├── main_dev.dart    # Development entry
│   ├── main_prod.dart   # Production entry
│   └── main_stage.dart  # Staging entry
├── models/              # Data models
├── repository/          # Data repositories
├── viewmodels/          # Business logic
├── views/               # UI screens
└── widgets/             # Reusable UI components
```
## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.32.0
- Dart SDK 3.8.0
- Android Studio / VS Code
- Git

### Installation

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/exchek.git
   ```

2. Navigate to the project directory
   ```bash
   cd exchek
   ```

3. Install dependencies
   ```bash
   flutter pub get
   ```

4. Run the app
   ```bash
   flutter run --flavor dev -t lib/main/main_dev.dart
   ```
## 📚 Dependencies
### 📦 Core Dependencies

| Package                      | Version   | Purpose                                                 |
| ---------------------------- | --------- | ------------------------------------------------------- |
| flutter\_bloc                | ^9.1.1    | State management using BLoC pattern                     |
| dio                          | ^5.8.0+1  | HTTP client for API requests and network calls          |
| cupertino\_icons             | ^1.0.8    | iOS-style icons for cross-platform compatibility        |
| connectivity\_plus           | ^6.1.3    | Network connectivity detection and monitoring           |
| flutter\_secure\_storage     | ^9.0.0    | Secure storage for sensitive data (tokens, credentials) |
| shared\_preferences          | ^2.2.2    | Local storage for user preferences and settings         |
| encrypt                      | ^5.0.1    | Data encryption and decryption utilities                |
| google\_fonts                | ^6.2.1    | Google Fonts integration for custom typography          |
| lottie                       | ^3.3.1    | Animated graphics and micro-interactions                |
| flutter\_svg                 | ^2.0.17   | SVG image rendering and display                         |
| uuid                         | ^4.5.1    | Unique identifier generation                            |
| cached\_network\_image       | ^3.4.1    | Network image caching and optimization                  |
| flutter\_cache\_manager      | ^3.4.1    | File caching and cache management                       |
| shimmer                      | ^3.0.0    | Loading skeleton animations                             |
| equatable                    | ^2.0.7    | Value equality comparison for objects                   |
| toastification               | ^2.3.0    | Toast notifications and alerts                          |
| flutter\_native\_splash      | ^2.4.6    | Native splash screen configuration                      |
| pretty\_dio\_logger          | ^1.4.0    | HTTP request/response logging for debugging             |
| flutter\_dotenv              | ^5.2.1    | Environment variables and configuration management      |
| device\_info\_plus           | ^9.1.2    | Device information and platform details                 |
| permission\_handler          | ^12.0.0+1 | Runtime permissions management                          |
| intl                         | ^0.20.2   | Internationalization and localization support           |
| keyboard\_actions            | ^4.2.0    | Keyboard toolbar and input enhancements                 |
| go\_router                   | ^14.2.0   | Declarative routing and navigation                      |
| package\_info\_plus          | ^8.3.0    | App package information and version details             |
| wave                         | ^0.2.2    | Wave animations and visual effects                      |
| dynamic\_path\_url\_strategy | ^1.0.0    | URL path strategy for web deployment                    |
| file\_picker                 | ^10.1.9   | File selection and picking functionality                |
| flutter\_spinkit             | ^5.2.1    | Loading spinners and animations                         |
| image\_picker                | ^1.1.2    | Image selection from gallery or camera                  |
| dotted\_border               | ^3.0.1    | Dotted border decorations for UI elements               |
| flutter\_widget\_from\_html  | ^0.16.0   | HTML rendering in Flutter widgets                       |


### 🛠 Development Dependencies

| Package              | Version | Purpose                                            |
| -------------------- | ------- | -------------------------------------------------- |
| build\_runner        | ^2.4.15 | Code generation build system                       |
| flutter\_lints       | ^5.0.0  | Flutter linting rules and code analysis            |
| intl\_utils          | ^2.8.7  | Internationalization utilities for code generation |
| flutter\_gen\_runner | ^5.8.0  | Asset and resource code generation                 |
| mockito              | ^5.4.6  | Mocking framework for unit and widget tests        |
| mocktail             | ^1.0.4  | Alternative mocking library for Dart & Flutter tests|
| bloc\_test           | ^10.0.0 | Utilities for testing BLoC state changes           |


## 🔧 Code Generation Commands

```bash
# Generate code and delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes and continuously generate code
flutter pub run build_runner watch --delete-conflicting-outputs

# Generate asset classes with flutter_gen
flutter pub run build_runner build

# Generate localization files
flutter pub run intl_utils:generate

# Generate native splash screens
flutter pub run flutter_native_splash:create
```

## 🌐 Environment Configuration

The app supports three environments:

### Running the App

```bash
# Development
flutter run --flavor dev -t lib/main/main_dev.dart

# Staging
flutter run --flavor stage -t lib/main/main_stage.dart

# Production
flutter run --flavor prod -t lib/main/main_prod.dart
```

### Building the App

```bash
# Development APK
flutter build apk --flavor dev -t lib/main/main_dev.dart

# Staging APK
flutter build apk --flavor stage -t lib/main/main_stage.dart

# Production APK
flutter build apk --flavor prod -t lib/main/main_prod.dart
```

## 📝 Version Update

Liquor Express includes a Bash script to automate version and build number updates across platforms and generate changelog entries.

### Files Affected

- `pubspec.yaml` (Flutter version)
- `android/app/build.gradle.kts` (Android versionCode & versionName)
- `ios/Runner.xcodeproj/project.pbxproj` (iOS MARKETING_VERSION & CURRENT_PROJECT_VERSION)
- `ios/Runner/Info.plist` (iOS CFBundleShortVersionString & CFBundleVersion)
- `CHANGELOG.md` (Automatic changelog entry generation)

### Usage

```bash
./scripts/version.sh 1.0.1 1
```

After running the command:
1. Enter what changes were made in this build
2. Press Enter twice to commit changes

### Example Output

```
⌛ Starting version update process...
- Added user profile customization
- Fixed checkout flow issues
✅ Added new entry for version 1.0.1 (build 1) to CHANGELOG.md
✅ Updated pubspec.yaml to version 1.0.1+1
✅ Updated Android version to 1.0.1 (build 1)
✅ Updated iOS version to 1.0.1 (build 1)
🎉 Version update completed successfully!
```

<p align="center">Made with ❤️ by the Exchek Team</p>

