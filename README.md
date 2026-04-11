# PocketLedger: Track Every Rupiah — Even Without Internet.

PocketLedger is an offline-first personal finance app that allows users to track expenses, income, and budgets without requiring internet connectivity. We believe your financial data belongs to you, so it's stored securely on your local device.

## Problem Statement
Most finance tracking apps require constant internet access, store sensitive financial data on arbitrary cloud servers, feature overly complicated UI/UX, and make the simple act of logging an expense take way too long. Users need a simpler, private-first experience.

## Solution
PocketLedger provides:
- **Offline Expense Tracking**: Fully functional at all times.
- **Instant Transaction Logging**: Streamlined, multi-step free logging.
- **Local Secure Storage**: SQLite-based private tracking.
- **Visual Spending Analytics**: Clear, chart-driven insights.

## Unique Value Proposition
1. Offline-first architecture
2. Privacy-first data storage
3. Ultra fast transaction entry
4. Lightweight UI
5. No mandatory account system

## Features
- **Core**: Quick transaction entry, income tracking, categorised budgeting, spending analytics, monthly summary, budget alerts.
- **Advanced**: Recurring transactions, CSV export, encrypted offline backup, beautiful dark mode, smart financial insights.

## Architecture & Tech Stack
- **Frontend**: Flutter, Dart.
- **State Management**: Riverpod.
- **Local Database**: SQLite (`sqflite`).
- **Dependency Injection**: `get_it`.
- **Charts**: `fl_chart`.
- **Landing Page**: Next.js, Tailwind CSS.

## Installation Steps
### Flutter App
1. Make sure Flutter SDK is installed and on stable channel.
2. Clone this repository.
3. Open terminal in `mobile_app/`.
4. Run `flutter pub get`.
5. Connect device or emulator and run `flutter run`.

### Landing Page
1. Ensure Node.js and NPM are installed.
2. Open terminal in `landing_page/`.
3. Run `npm install`.
4. Run `npm run dev`.

## Monetization Strategy
PocketLedger will remain free for fundamental offline tracking. Premium features (like CSV export, recurring transactions, custom categories) will be offered via a one-time lifetime purchase.

## Competitive Advantage
Zero latency on data entry, immune to connectivity drops, completely private.

## Architecture
See `docs/architecture.md` for our offline-first data flow.

## License
All intellectual property strictly owned by the authors. Open source under MIT where applicable.
