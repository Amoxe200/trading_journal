import '../models/trade.dart';
import 'base_trade.dart';

class StubTradeDB implements BaseTradeDB {
  @override
  Future<void> deleteTrade(Trade trade) async => throw UnimplementedError();
  @override
  Future<void> insertTrade(Trade trade) async => throw UnimplementedError();
  @override
  Future<void> updateTrade(Trade trade) async => throw UnimplementedError();
  @override
  Future<List<Trade>> trades() async => throw UnimplementedError();
  @override
  Future<void> init() async => throw UnimplementedError();
}

BaseTradeDB getTradeDB() => StubTradeDB();