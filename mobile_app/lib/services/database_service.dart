import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../data/models/transaction.dart';
import '../data/models/category.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pocketledger_v2.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        created_at TEXT
      )
    ''');
    
    await db.execute('''
      CREATE TABLE categories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        icon TEXT,
        color TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        type TEXT,
        category_id INTEGER,
        date TEXT,
        note TEXT,
        is_recurring INTEGER DEFAULT 0,
        frequency TEXT,
        last_generated_date TEXT,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');
    
    await db.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        monthly_limit REAL,
        FOREIGN KEY (category_id) REFERENCES categories (id) ON DELETE CASCADE
      )
    ''');

    // Seed data
    await db.insert('users', {'created_at': DateTime.now().toIso8601String()});
    
    final cats = [
      {'name': 'Food & Drinks', 'icon': '🍔', 'color': '#EF4444'},
      {'name': 'Transport', 'icon': '🚗', 'color': '#3B82F6'},
      {'name': 'Shopping', 'icon': '🛍️', 'color': '#A855F7'},
      {'name': 'Health', 'icon': '🏥', 'color': '#F43F5E'},
      {'name': 'Entertainment', 'icon': '🎬', 'color': '#F59E0B'},
      {'name': 'Salary', 'icon': '💰', 'color': '#10B981'},
    ];

    for (var cat in cats) {
      await db.insert('categories', cat);
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN is_recurring INTEGER DEFAULT 0');
      await db.execute('ALTER TABLE transactions ADD COLUMN frequency TEXT');
      await db.execute('ALTER TABLE transactions ADD COLUMN last_generated_date TEXT');
    }
  }

  // Transactions CRUD
  Future<int> insertTransaction(AppTransaction transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<int> updateTransaction(AppTransaction transaction) async {
    final db = await database;
    return await db.update(
      'transactions', 
      transaction.toMap(), 
      where: 'id = ?', 
      whereArgs: [transaction.id]
    );
  }

  Future<List<AppTransaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('transactions', orderBy: 'date DESC');
    return List.generate(maps.length, (i) => AppTransaction.fromMap(maps[i]));
  }

  Future<List<AppTransaction>> getRecurringTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions', 
      where: 'is_recurring = 1'
    );
    return List.generate(maps.length, (i) => AppTransaction.fromMap(maps[i]));
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // Categories CRUD
  Future<List<AppCategory>> getCategories() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => AppCategory.fromMap(maps[i]));
  }

  // Budgets CRUD
  Future<int> upsertBudget(AppBudget budget) async {
    final db = await database;
    return await db.insert('budgets', budget.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<AppBudget>> getBudgets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('budgets');
    return List.generate(maps.length, (i) => AppBudget.fromMap(maps[i]));
  }

  Future<void> wipeAllData() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pocketledger_v2.db');
    await deleteDatabase(path);
    _database = null;
  }
}
