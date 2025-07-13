# 💳 CardBox

A secure, offline-first mobile app built with **Flutter** to store and manage your credit and debit cards — protected with **encryption** and **biometric authentication**.

<p align="center">
  <img src="https://img.shields.io/badge/flutter-blue?logo=flutter" />
  <img src="https://img.shields.io/badge/encryption-AES256-important" />
  <img src="https://img.shields.io/badge/platform-android%20%7C%20ios-green" />
  <img src="https://img.shields.io/github/license/sharathpc/cardbox" />
</p>

---

## 🚀 Features

- 🔐 Encrypted local storage using `sqflite_sqlcipher`
- 🔓 Biometric authentication (Face ID / Fingerprint)
- 💳 Store card details (Number, Name, Expiry, CVV, PIN)
- 🔄 Share card info securely via messaging apps
- 📴 Works offline — no internet required
- 🧼 Clean and minimal UI built with Flutter

---

## 📸 Screenshots

<div>
  <img src="https://github.com/sharathpc/gitlab-pipes/blob/master/screenshots/screenshot-1.png" width="200">
  <img src="https://github.com/sharathpc/gitlab-pipes/blob/master/screenshots/screenshot-2.png" width="200">
  <img src="https://github.com/sharathpc/gitlab-pipes/blob/master/screenshots/screenshot-3.png" width="200">
  <img src="https://github.com/sharathpc/gitlab-pipes/blob/master/screenshots/screenshot-4.png" width="200">
</div>

---

## 📦 Installation

Clone the repository and run the app:

```bash
git clone https://github.com/sharathpc/cardbox.git
cd cardbox
flutter pub get
flutter run
```

## 🔐 Security
CardBox uses the following techniques to secure your data:

* AES-256 encryption via sqflite_sqlcipher
* Biometric authentication using local_auth
* Offline access — your data never leaves the device

> In production, consider integrating secure storage for passwords/keys (e.g., flutter_secure_storage).

## 🧱 Tech Stack
* Flutter – UI & cross-platform logic
* sqflite_sqlcipher – Encrypted SQLite database
* local_auth – Biometric authentication
* share_plus – Share card details securely
* Provider – State management

## 📁 Project Structure

```css
lib/
│
├── models/
│   └── card_model.dart
│
├── db/
│   └── db_helper.dart
│
├── auth/
│   └── biometric_auth.dart
│
├── screens/
│   ├── home_screen.dart
│   └── add_card_screen.dart
│
└── main.dart
```

## 🛠️ Future Improvements
* ☁️ Secure cloud backup & sync
* 🧬 PIN fallback for biometric-less devices
* 📲 NFC or QR-based sharing

## 🙋‍♂️ Contributing
PRs are welcome! If you find a bug or want to suggest a feature, feel free to open an issue.

## 📜 License
This project is licensed under the MIT License. See LICENSE for more info.

## ⭐ Support
If you find this project useful, consider giving it a ⭐!
