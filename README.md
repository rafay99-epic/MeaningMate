# Meaning Mate

![Thumbnail](/Mockup/Meaning%20Mate%20Mock-UP/1.png)  
_Meaning Mate_

## Introduction

Meaning Mate is a powerful vocabulary-building application designed to help users expand and refine their language skills in an interactive and engaging way. Whether you're a student, professional, or language enthusiast, Meaning Mate provides the tools to improve your vocabulary efficiently.

## Features

- **Personalized Word Bank** – Save and manage words with meanings, example sentences, tenses, antonyms, and synonyms.
- **AI-Powered Assistance** – Get real-time vocabulary support using an intelligent chatbot.
- **Interactive Quizzes** – Test your knowledge and reinforce learning through engaging quizzes.
- **Progress Tracking** – Monitor your vocabulary growth and enhance your learning experience.

## Getting Started

### Prerequisites

To run this project, you need to have:

- Flutter installed
- Firebase account set up for data storage
- Google Cloud API Key for chatbot functionality

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/rafay99-epic/MeaningMate
   ```
2. Navigate to the project folder:
   ```sh
   cd MeaningMate
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```

## Firebase & Chatbot Integration

To enable Firebase and Chatbot functionality:

1. **Firebase Setup**

   - Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Enable Firestore or Realtime Database for data storage.
   - Download the `google-services.json` file (for Android) and `GoogleService-Info.plist` file (for iOS) and place them in the respective `android/app/` and `ios/Runner/` directories.
   - Update your `firebase_options.dart` file if necessary.

2. **Google Cloud API for Chatbot**
   - Set up a project in [Google Cloud Console](https://console.cloud.google.com/).
   - Enable the Dialogflow API for chatbot assistance.
   - Generate an API key and update your `.env` file:
     ```sh
     GOOGLE_API_KEY=your_google_api_key
     ```

## Running the Project

To start the application on a connected device or emulator:

```sh
flutter run
```

This will launch the application for Android and iOS devices.

## APK Download

Download the latest APK from the following link:

[Download Meaning Mate APK](/apk/Meaning_Mate_01.apk)

## Blog

Want to know how this app was developed? Check out the detailed blog post on our website: [Meaning Mate Development Blog](https://www.rafay99.com)

## Author

- **Abdul Rafay**
  - Website: [rafay99.com](https://www.rafay99.com)
  - Email: [99marafay@gmail.com](mailto:99marafay@gmail.com)

## Contribution

If you'd like to contribute, feel free to submit a pull request. Ensure your changes align with the project's goals and maintain code quality.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
