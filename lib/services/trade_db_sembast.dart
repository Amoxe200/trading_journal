import 'package:sembast/sembast.dart';
import 'package:sembast_web/sembast_web.dart' hide Database;
import 'package:sqflite/sqflite.dart' hide Database;
import '../models/trade.dart';
import 'base_trade.dart';

class TradeDBSembast implements BaseTradeDB {
  late Database _db;
  final _store = intMapStoreFactory.store('trades');


  Future<void> init() async {
    _db = await databaseFactoryWeb.openDatabase('trades.db');
  }

  Future<Trade> insertTrade(Trade trade) async {
    if (trade.id == null) {
      final int id = await _store.add(_db, trade.toMap());
      // Return new Trade instance with the generated id
      return Trade(
        id: id,
        tradeName: trade.tradeName,
        entryPrice: trade.entryPrice,
        exitPrice: trade.exitPrice,
        quantity: trade.quantity,
        date: trade.date,
        notes: trade.notes,
      );
    } else {
      await _store.record(trade.id!).put(_db, trade.toMap());
      return trade;
    }
  }

  @override
  Future<List<Trade>> trades() async {
    final records = await _store.find(_db);
    return records.map((snap) => Trade.fromMap(snap.value)).toList();
  }

  @override
  Future<void> updateTrade(Trade trade) async {
    await _store.record(trade.id!).update(_db, trade.toMap());
  }

  @override
  Future<void> deleteTrade(Trade trade) async {
    await _store.record(trade.id!).delete(_db);
  }
}