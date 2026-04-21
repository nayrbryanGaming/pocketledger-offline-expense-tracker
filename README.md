<div align="center">
  <img src="branding/logo.png" alt="PocketLedger Logo" width="120" height="120">
  
  <h1>PocketLedger</h1>
  <p><strong>Track every rupiah — even without internet.</strong></p>
  
  <p>
    <a href="#features">Features</a> •
    <a href="#architecture">Architecture</a> •
    <a href="#installation">Installation</a> •
    <a href="#contribution">Contribution</a>
  </p>
</div>

---

## 📖 Product Overview

PocketLedger is an **offline-first** personal finance application that empowers users to track expenses, income, and budgets with zero reliance on internet connectivity. Designed with privacy and speed at its core, PocketLedger stores all financial data locally on the user's device. No cloud syncs, no data mining, just pure financial control.

### Problem Statement
Most finance tracking apps today suffer from critical flaws:
- They require constant internet access.
- They send sensitive financial data to proprietary cloud servers.
- They feature overcomplicated, sluggish user interfaces.
- Transaction entry is unnecessarily slow.

### Solution
PocketLedger disrupts the personal finance space by providing:
- **100% offline expense tracking**
- **Instant transaction logging** (zero latency)
- **Local secure storage** (SQLite)
- **Visual spending analytics** directly on-device

### Unique Value Proposition
1. **Offline-first Architecture**: Your data never leaves your device unless you explicitly export it.
2. **Privacy-first Data Storage**: Zero telemetry, zero tracking.
3. **Ultra-fast Transaction Entry**: Streamlined UI for entering data in seconds.
4. **Lightweight UI**: Built with a sleek, modern, adaptive Flutter interface.
5. **No Mandatory Account System**: Start tracking immediately upon launch.

---

## ✨ Features

### Core Features
- **Quick Transaction Entry**: Add income and expenses instantly.
- **Income Tracking**: Monitor your cash flow efficiently.
- **Category Management**: Customize categories with rich emojis and colors.
- **Spending Analytics**: Visualize spending patterns with beautiful FL Charts.
- **Monthly Summary**: Get a bird's-eye view of your monthly financial health.
- **Budget Alerts**: Set monthly limits and track your progress.

### Advanced Features
- **Recurring Transactions**: Automate daily, weekly, or monthly expenses.
- **CSV Export**: Export your data to Excel or Google Sheets.
- **Encrypted Backup**: Backup and restore data securely via JSON.
- **Dark Mode**: Adaptive dark/light themes for comfortable viewing.
- **Financial Insights**: AI-driven (local) insights based on spending trends.

---

## 🏗️ Architecture

PocketLedger follows a strict layered architecture built on top of Riverpod for state management:

```
User
  ↓
Flutter UI Layer (Presentation)
  ↓
State Management (Riverpod Notifiers)
  ↓
Repository / Service Layer
  ↓
Local Database (SQLite via sqflite)
```

- **Analytics Engine**: Reads transactions locally and generates visual summaries.
- **Backup Flow**: SQLite Data → Encrypted JSON → Local File System (Cloud export is user-initiated only).

### Tech Stack
- **Frontend**: Flutter (Latest Stable)
- **State Management**: Flutter Riverpod
- **Local Database**: SQLite (sqflite)
- **Charts**: fl_chart
- **Dependency Injection**: Provider overrides

---

## 🛠️ Installation Steps

1. **Clone the repository**
   ```bash
   git clone https://github.com/nayrbryanGaming/pocketledger-offline-expense-tracker.git
   cd pocketledger-offline-expense-tracker/mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

4. **Build APK for Android**
   ```bash
   flutter build apk --release
   ```

---

## 📂 Project Structure

```
pocketledger-offline-expense-tracker
├── mobile_app/
│   ├── lib/
│   │   ├── core/         # Constants, themes, utils
│   │   ├── data/         # Models, DB schemas
│   │   ├── features/     # Dashboard, Analytics, Add Transaction
│   │   ├── services/     # Database, Backup, Notifications
│   │   └── main.dart     # App Entrypoint
├── branding/             # Logo and brand assets
├── legal/                # Privacy policies and terms
└── README.md             # You are here!
```

---

## 🚀 Roadmap
- [x] Initial Release (Offline tracking, Categories, Analytics)
- [x] Recurring Transactions Engine
- [x] JSON/CSV Export & Import
- [ ] End-to-end Encrypted Cloud Sync (Optional/Opt-in)
- [ ] AI-driven budget forecasting
- [ ] Multi-currency support

---

## 💰 Monetization Strategy
PocketLedger operates on a freemium model.
- **Free Tier**: Unlimited local transactions, basic analytics, category management.
- **Elite Tier (One-time purchase)**: Unlocks advanced forecasting, zero-knowledge sync, and unlimited wallets.

### Competitive Advantage
Unlike competitors (Mint, YNAB), PocketLedger respects user privacy by default and guarantees functionality without internet access. This caters directly to privacy-conscious users, travelers, and those in low-connectivity areas.

---

## 🤝 Contribution Guide
1. Fork the project.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License
This project is proprietary and confidential. Unauthorized copying, modification, distribution, or use is strictly prohibited. For inquiries, contact the repository owner.
