# CeyGo Mobile App

<h3 align="center">
  Smart Public Transportation Information System
</h3>
<p align="center">
  A Flutter-based mobile application for passengers.
</p>

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-Backend-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)

</div>

<img src="https://user-images.githubusercontent.com/74038190/212284100-561aa473-3905-4a80-b561-0d28506553ee.gif" width="100%" />

## About

CeyGo is a smart public transportation information system designed to improve the public transportation experience by providing passengers with transportation information, ticket booking, live vehicle tracking, and other transportation-related features.

The mobile application is developed using **Flutter** and connects to **Firebase** services for authentication, database operations, and real-time transportation data.

---

## Features

### Implemented

* Phone number authentication
* OTP verification
* Passenger profile setup
* User profile management
* From / to destination selection
* Route selection
* Date selection for journey planning
* Live vehicle tracking map
* Ticket booking flow (route search, ticket selection, confirmation, payment)
* Local application state and profile caching

### Planned

* QR-based ticket functionality
* Wallet functionality
* Bus and train schedules
* Push notifications
* Complaints and feedback
* Emergency features
* Driver / Conductor role-based dashboards
* Live location sharing
* Vehicle-related functionality

---

## Technology Stack

| Technology                 | Purpose                             |
| -------------------------- | ----------------------------------- |
| Flutter                    | Mobile application framework        |
| Dart                       | Programming language                |
| Firebase Authentication    | User authentication                 |
| Cloud Firestore            | User, route, and application data   |
| Firebase Realtime Database | Real-time vehicle locations         |
| ChangeNotifier             | State management (Flutter built-in) |
| Flutter Map                | Map and location features           |
| OpenStreetMap              | Map data                            |
| Nominatim                  | Location search and geocoding       |
| Geocoding                  | Address lookup and coordinates      |
| SharedPreferences          | Local application state and caching |

---

## Project Structure

```text
apps/
├── mobile_app/
│   ├── android/
│   ├── assets/
│   │   └── images/
│   ├── ios/
│   ├── linux/
│   ├── macos/
│   ├── windows/
│   ├── lib/
│   │   ├── app/
│   │   │   └── app.dart
│   │   ├── core/
│   │   │   ├── services/
│   │   │   ├── theme/
│   │   │   └── widgets/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── onboarding/
│   │   │   ├── home/
│   │   │   ├── search/
│   │   │   ├── passenger/
│   │   │   ├── booking/
│   │   │   ├── payment/
│   │   │   ├── profile/
│   │   │   └── tickets/
│   │   ├── firebase_options.dart  (generated)
│   │   └── main.dart
│   ├── test/
│   ├── pubspec.yaml
│   └── README.md
└── admin_web/
```

---

## Architecture

The mobile application follows a feature-oriented structure.

```text
lib/
│
├── app/
│   └── Application configuration
│
├── core/
│   ├── services/
│   ├── theme/
│   └── widgets/
│
└── features/
    ├── auth/
    ├── onboarding/
    ├── home/
    ├── search/
    ├── passenger/
    ├── booking/
    ├── payment/
    ├── profile/
    └── tickets/
```

### Core

Contains functionality shared across multiple features.

Examples:

* Theme configuration
* Reusable widgets
* User profile service
* Shared application services

### Features

Each major application function is organized into its own feature.

```text
features/
└── auth/
    ├── presentation/
    └── ...
```

This keeps feature-specific code separated and makes the project easier to maintain.

---

## User Profile Management

User profile information is stored in **Cloud Firestore** and locally cached using **SharedPreferences**.

```text
Firebase Authentication
        ↓
      User UID
        ↓
Cloud Firestore
        ↓
UserProfileService
        ↓
SharedPreferences
        ↓
Home / Profile / Other Screens
```

The local cache prevents unnecessary Firestore requests when displaying frequently used profile information such as:

* Name
* Role
* Phone number

Firestore remains the primary source of profile data while SharedPreferences provides fast local access.

---

## Authentication Flow

```text
Splash Screen
      ↓
Check Authentication
      ↓
 ┌───────────────┐
 │               │
Not Logged In   Logged In
 │               │
 ↓               ↓
Onboarding     Check Setup
                 │
          ┌──────┴──────┐
          │             │
       Complete      Incomplete
          │             │
          ↓             ↓
        Home       Setup Screens
```

Phone authentication is handled using **Firebase Authentication**.

The application uses:

* Sri Lankan mobile number validation
* Firebase Phone Authentication
* OTP verification
* Firebase user sessions

---

## Local Application State

`SharedPreferences` is used for lightweight local state such as:

* Initial setup completion
* Cached user profile information
* Local application preferences

Example:

```dart
final prefs = await SharedPreferences.getInstance();

await prefs.setBool('setup_completed', true);
```

---

## Firebase Services

The mobile application uses the following Firebase services:

### Firebase Authentication

Used for:

* Phone authentication
* OTP verification
* Maintaining authenticated sessions

### Cloud Firestore

Used for:

* User profiles
* Route and ticket data
* Structured persistent data

### Firebase Realtime Database

Used for:

* Live vehicle locations
* Real-time transportation information

> Push notifications (Firebase Cloud Messaging) are planned.

---

## Requirements

Before running the application, install:

* Flutter SDK
* Dart SDK
* Android Studio or another Android development environment
* Android SDK
* Git

Verify the Flutter installation:

```bash
flutter doctor
```

---

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
```

### 2. Navigate to the Mobile App

```bash
cd apps/mobile_app
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Configure Firebase

Firebase configuration files are not committed. Generate them with FlutterFire:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

In CI (Codemagic) these files are generated automatically from environment variables during the post-clone step.

### 5. Connect a Device

Check connected devices:

```bash
flutter devices
```

### 6. Run the Application

```bash
flutter run
```

---

## Development

### Run in Debug Mode

```bash
flutter run
```

### Analyze the Project

```bash
flutter analyze
```

### Run Tests

```bash
flutter test
```

### Format Dart Code

```bash
dart format .
```

---

## Environment and Firebase Configuration

Firebase configuration is generated and must not be committed. The generated files are:

```text
lib/firebase_options.dart
ios/Runner/GoogleService-Info.plist
android/app/google-services.json
```

Locally, they are produced with `flutterfire configure`. In CI (Codemagic), the post-clone step writes them from environment variables matching your Firebase project.

Firebase configuration should always be kept consistent with the project's Firebase environment. Do not replace Firebase configuration files with credentials from another Firebase project.

---

## Main Application Flow

```text
Splash
  ↓
Onboarding
  ↓
Phone Authentication
  ↓
OTP Verification
  ↓
Name Setup
  ↓
Permission Setup
  ↓
Home
```

After the initial setup has been completed, the application uses the stored setup state to avoid showing the setup screens again on every launch.

---

## Maps and Location

The application uses:

* `flutter_map`
* OpenStreetMap
* Nominatim
* `geocoding`
* `geolocator`
* `permission_handler`

These services support transportation mapping, location retrieval, destination search, and live location functionality.

---

## Package Management

Dependencies are managed through:

```text
pubspec.yaml
```

After modifying dependencies:

```bash
flutter pub get
```

---

## Build

### Android Debug Build

```bash
flutter build apk --debug
```

### Android Release Build

```bash
flutter build apk --release
```

---

## Team Development Guidelines

### Branch Naming

Use feature-based branches:

```text
feature/<feature-name>
```

Example:

```text
feature/mobile-app
feature/ticket-booking
feature/live-tracking
```

### Commit Messages

Use clear and descriptive commit messages.

Examples:

```text
feat: add phone authentication
fix: resolve OTP verification issue
refactor: improve user profile caching
docs: update mobile app README
```

### Before Pushing

Run:

```bash
flutter analyze
dart format .
```

Then verify the application builds successfully.

---

## Project Information

| Item             | Details                                        |
| ---------------- | ---------------------------------------------- |
| Project          | CeyGo                                          |
| System           | Smart Public Transportation Information System |
| Platform         | Android (iOS planned)                          |
| Framework        | Flutter                                        |
| Language         | Dart                                           |
| Backend          | Firebase                                       |
| State Management | ChangeNotifier (Flutter built-in)              |
| Project Type     | University Group Project                       |

---

## Status

**Development**

The CeyGo mobile application is currently under active development as part of the Smart Public Transportation Information System.

Current development includes:

* Passenger home and navigation interfaces
* Destination, route, and date selection
* Ticket booking flow (search, ticket selection, confirmation, payment)
* Live vehicle tracking map
* User profile management
* Firebase integration
* Authentication and application state management
* Performance optimization (app startup, live data, caching)

Additional transportation, booking, live tracking, notification, and other system features are being developed incrementally.
