# SebScan Flutter App

SebScan is a Flutter mobile app for iOS and Android that scans ingredient labels and flags food triggers related to seborrheic dermatitis and hair fall.

## What is included

- Riverpod state setup
- `go_router` navigation
- Trigger database and analyzer utilities
- Animated results screen with filter chips and trigger cards
- Manual scan flow
- Barcode scan flow using Open Food Facts
- Photo OCR flow using ML Kit text recognition
- Firebase service layer for anonymous auth and scan history
- History, Learn, Profile, and Auth screens

## Important environment note

This machine did not have `flutter` or `dart` available in `PATH` when the project was built, so the native platform folders from `flutter create` and local `flutter analyze` verification could not be completed yet.

## Next steps once Flutter is installed

From the `sebscan/` directory:

```bash
flutter create . --org com.sebscan --platforms ios,android
flutter pub get
flutter analyze
flutter run
```

## Firebase setup still required

Add your app-specific:

- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`

Then follow the standard Firebase setup for Flutter so `Firebase.initializeApp()` can connect successfully.

## Notes

- The risk scoring implementation is tuned so multiple severe triggers can surface as a high-risk result quickly in the UI.
- The preview `ResultsScreen` route works with mock data before scan flows are used.
