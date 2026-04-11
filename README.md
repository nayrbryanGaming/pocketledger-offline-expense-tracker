# PocketLedger: Track Every Rupiah — Even Without Internet.

PocketLedger is a **Premium, Offline-First** personal finance application built to transform how users track their wealth without compromising privacy. This repository contains the complete production-ready source code for the mobile application, landing page, and documentation required for Google Play Store success.

## 🚀 The Build (PROD-READY)
This application was architected for maximum performance and minimal friction. We believe that your financial logs are your business, which is why PocketLedger requires **Zero Internet Permissions** to function.

### ✨ Key Features
- **⚡ Lightning Transaction Logging**: Enter expenses in under 3 seconds.
- **🔒 Hardened Privacy**: Internal SQLite database with zero cloud sync or data transmission.
- **📊 Interactive Analytics**: High-performance local charts (FL Chart) providing spending trend insights.
- **🌓 Adaptive Themes**: Seamless switching between an Emerald Green Dark mode and a sleek Clean Light mode.
- **📁 Production Utility**: Full CSV export and data wipe functionality for user autonomy.

## 🛠️ Tech Stack
- **Flutter (latest stable)**: For a high-fidelity cross-platform experience.
- **Riverpod**: Robust state management for real-time UI updates.
- **SQLite (sqflite)**: High-speed local data persistence.
- **Next.js & Tailwind CSS**: For a stunning, modern landing page.
- **Framer Motion**: For smooth, marketing-grade animations.

## 📁 Repository Structure
```
pocketledger-offline-expense-tracker/
├── mobile_app/         # Flutter Source Code (Riverpod + SQLite)
├── landing_page/       # Next.js & Tailwind Landing Page (Vercel Ready)
├── docs/               # Architecture, Product Strategy, and Monetization
├── legal/              # Play Store Compliant Policies (Privacy, Terms, Data Usage)
├── branding/           # Brand identity assets (Colors, Guidelines, Logo)
└── README.md           # This comprehensive guide
```

## 🏗️ Getting Started
### Flutter Application
1.  **Clone the Repository**: `git clone https://github.com/nayrbryanGaming/pocketledger-offline-expense-tracker`
2.  **Navigate directly**: `cd mobile_app`
3.  **Fetch Dependencies**: `flutter pub get`
4.  **Run Directly**: `flutter run` (Connect your device via USB)

### Marketing Page
1.  **Navigate**: `cd landing_page`
2.  **Install**: `npm install`
3.  **Preview**: `npm run dev`
4.  **Launch**: Deploy the folder directly to Vercel/Netlify.

## 🏆 Competitive Advantage
PocketLedger succeeds where other finance apps fail by eliminating the "loading spinner" fatigue. Every calculation happens locally. Every log stays private. It's the ultimate tool for the modern digital minimalist.

## 📜 License
© 2026 PocketLedger. All Rights Reserved. This codebase is provided for production review and deployment.
