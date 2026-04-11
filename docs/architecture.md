# PocketLedger Architecture

## Overview
PocketLedger follows a strict Offline-First architecture. Data flows unidirectionally from the User Interface, through Riverpod state management, into the Repository Layer, and finally to the local SQLite database.

## Components

### State Management (Riverpod)
We use `flutter_riverpod` to securely manage business states. Repositories are injected via `Providers`. 
- `transactionProvider`
- `categoryProvider`
- `budgetProvider`

### Database (SQLite via sqflite)
Locally stored DB ensuring zero latency.
Tables:
- `users`: Basic app metadata.
- `transactions`: Historical data of expenses/incomes.
- `categories`: User-defined tagging.
- `budgets`: Category-linked monthly limits.

### Analytics Engine
Aggregates logic reading `transactions` and `budgets` for summary models passed directly to FL Chart UI elements.

### Optional Backup
Future integration:
- Dump SQLite rows to encrypted JSON.
- Sync/Backup via Google Drive or Firebase.
