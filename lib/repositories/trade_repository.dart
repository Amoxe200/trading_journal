import 'package:trading_journal/services/trade_db.dart';

import '../models/trade.dart';
import '../services/base_trade.dart';
import '../services/trade_db_sembast.dart';

class TradeRepo {
  final BaseTradeDB _tradeDB;

  static final TradeRepo _instance = TradeRepo._internal();

  factory TradeRepo() => _instance;

  TradeRepo._internal() : _tradeDB = TradeDBSembast(); // or TradeDBSqflite();

  Future<void> initDB() async {
    await _tradeDB.init();
  }

  Future<void> insertTrade(Trade trade) async {
    await _tradeDB.insertTrade(trade);
  }

  Future<List<Trade>> getTrades() async {
    return await _tradeDB.trades();
  }

  Future<void> updateTrade(Trade trade) async {
    await _tradeDB.updateTrade(trade);
  }

  Future<void> deleteTrade(Trade trade) async {
    await _tradeDB.deleteTrade(trade);
  }
}
