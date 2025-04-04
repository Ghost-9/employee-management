# 👨‍💼 Employee Ledger

A Flutter-based web and mobile app to **manage employee records** efficiently.  
This project supports deployment as a **Progressive Web App (PWA)** and **Android APK** with performance optimizations, obfuscation, and GitHub Pages hosting.

---

## 🌐 Live Demo

➡️ [https://ghost-9.github.io/employee_management/](https://ghost-9.github.io/employee_management/)

---


## 📦 Features

- ✨ Cross-platform: Web and Android
- 🔐 Obfuscated & optimized APK builds
- 📉 Tree-shaken icons and minimized resources
- 💾 **Local database with [sembast](https://pub.dev/packages/sembast)** (No backend needed!)
- ⚙️ CI/CD-ready Makefile with web & APK deployment
- 📊 Manage employee data in a clean UI
- 📲 PWA support for installation on mobile and desktop
- ⚡ Splash screen and loading animation
- 🧩 Skia-based rendering for enhanced performance

---

## 📚 Local Database (Cross-Platform)

This app uses [`sembast`](https://pub.dev/packages/sembast), a NoSQL-style persistent database for Flutter:

- Works on **Android, iOS, Web, macOS, Windows, Linux**
- Pure Dart (no platform channels or native code)
- Simple key-value store with Map-like structure
- Perfect for storing employee records offline

🗂️ Your data stays **on-device**, so this app works **offline by default**.

---
