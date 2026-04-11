# PocketLedger Data Usage Policy

**PocketLedger is committed to complete data transparency.**

### Data Storage Architecture
- **Technology**: Local SQLite Database.
- **Location**: `/data/user/0/com.pocketledger.app/app_flutter/pocketledger_v2.db` (Internal app storage).
- **Encryption**: Data is protected by the operating system's standard application sandboxing.

### How We Use Your Data
1. **Application Logic**: To calculate your total balance, monthly spending, and category distributions.
2. **Visualizations**: To generate local charts using the `fl_chart` library.
3. **User Exports**: To generate CSV files at your request.

### What We NEVER Do
- We NEVER sell your data.
- We NEVER share transaction history with advertisers.
- We NEVER silent-sync data in the background.

### User Rights (GDPR/CCPA Compliance)
As an offline-only user, you have the ultimate right of access and erasure. Deleting the app filesystem via your device settings or the in-app "Wipe" function immediately and permanently destroys all records.
