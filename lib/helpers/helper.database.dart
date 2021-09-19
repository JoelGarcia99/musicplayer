import 'package:sqflite/sqflite.dart';

/// A sigleton database helper to access local data like
/// playlist, favorites, etc
class LocalDatabase {

  static LocalDatabase? _instance;

  factory LocalDatabase() {
    if(_instance == null) {
      _instance = new LocalDatabase._();
    }

    return _instance!;
  }

  LocalDatabase._();

  late final Database _db;

  /// You need to call this method before using any [_db]
  /// option
  Future<void> init({String dbPath = "app_data.db"}) async {
    _db = await openDatabase(dbPath);
  }

  get database => _db;
}