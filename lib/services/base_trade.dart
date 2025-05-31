import '../models/trade.dart';

abstract class BaseTradeDB{
  Future<void> insertTrade(Trade trade);
  Future<void> init();  // Add this line
  Future<List<Trade>> trades();
  Future<void> updateTrade(Trade trade);
  Future<void> deleteTrade(Trade trade);
}