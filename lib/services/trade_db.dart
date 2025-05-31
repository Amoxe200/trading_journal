import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trading_journal/services/base_trade.dart';

import '../models/trade.dart';

class TradeDBSqflite implements BaseTradeDB {
  Database? _database;

  TradeDBSqflite();

  @override
  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'trades.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE trades(id INTEGER PRIMARY KEY, tradeName TEXT, entryPrice REAL, exitPrice REAL, quantity INTEGER, date TEXT, notes TEXT)'
      );
    });
  }

  Database get _db {
    if (_database == null) throw Exception('Database not initialized. Call init() first.');
    return _database!;
  }

  @override
  Future<void> insertTrade(Trade trade) async {
    await _db.insert('trades', trade.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<List<Trade>> trades() async {
    final List<Map<String, dynamic>> maps = await _db.query('trades');
    return List.generate(maps.length, (i) => Trade.fromMap(maps[i]));
  }

  @override
  Future<void> updateTrade(Trade trade) async {
    await _db.update('trades', trade.toMap(), where: 'id = ?', whereArgs: [trade.id]);
  }

  @override
  Future<void> deleteTrade(Trade trade) async {
    await _db.delete('trades', where: 'id = ?', whereArgs: [trade.id]);
  }
}
