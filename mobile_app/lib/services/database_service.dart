import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pocketledger.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
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
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');
    
    await db.execute('''
      CREATE TABLE budgets(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER,
        monthly_limit REAL,
        FOREIGN KEY (category_id) REFERENCES categories (id)
      )
    ''');

    // Default User record
    await db.insert('users', {'created_at': DateTime.now().toIso8601String()});

    // Default categories
    await db.insert('categories', {'name': 'Food', 'icon': '🍔', 'color': '#EF4444'});
    await db.insert('categories', {'name': 'Transport', 'icon': '🚗', 'color': '#3B82F6'});
    await db.insert('categories', {'name': 'Salary', 'icon': '💰', 'color': '#10B981'});
  }

  Future<void> wipeAllData() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pocketledger.db');
    await deleteDatabase(path);
    _database = null;
  }
}
