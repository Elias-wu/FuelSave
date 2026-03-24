# FuelSave

A Flutter app to find the cheapest petrol station near you using the UK Fuel Finder API with real-time data via OAuth.

## Setup

1. Install Flutter SDK from https://flutter.dev/docs/get-started/install/windows

2. Run `flutter pub get` to install dependencies.

3. For iOS, you need a Mac to build. For Android, connect a device or use emulator.

4. Obtain OAuth client ID and secret from https://www.developer.fuel-finder.service.gov.uk/

5. Replace 'YOUR_CLIENT_ID' and 'YOUR_CLIENT_SECRET' in lib/main.dart with your credentials.

6. Adjust API endpoints and response parsing based on actual API documentation.

7. Run `flutter run` to launch the app.

## Features

- Requests location permission

- Gets current location

- Authenticates with OAuth and fetches real-time fuel prices

- Parses JSON and finds the cheapest station within 5km

- Displays the result

## Note

This uses the API for real-time data. Ensure endpoints match the API docs. For production, add error handling, maps, and fuel type selection.