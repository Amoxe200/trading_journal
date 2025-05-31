import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:trading_journal/models/trade.dart';
import 'package:trading_journal/repositories/trade_repository.dart';

class TradeProvider extends ChangeNotifier {

  /// Initialize singlton Repository
  final TradeRepo tradeRepo = TradeRepo();
  List<Trade> _trades = [];

  // getter for list of treads
  List<Trade> get trades => _trades;

  // Get all Trades
  Future<void> fetchAllTrades() async{
    _trades = await tradeRepo.getTrades();
    notifyListeners();
  }

  /// Insert Trade
  Future<void> insertTrade(Trade trade) async {
    await tradeRepo.insertTrade(trade);
    fetchAllTrades();
  }

  // update Trade
  Future<void> updateTrade(Trade trade) async {
    await tradeRepo.updateTrade(trade);
    fetchAllTrades();
  }

  // Delete Trade
  Future<void> deleteTrade(Trade trade) async{
    await tradeRepo.deleteTrade(trade);
    fetchAllTrades();
  }

  ///************************************///
  ///********* FL Chart Methods *********///
  ///************************************///

  // Calculate profit/loss trends over time for Line Chart
  List<FlSpot> get profitLossTrend {
    List<FlSpot> spots = [];
    for (int i = 0; i < _trades.length; i++) {
      print("Trade item profit loss ${_trades[i].profitLoss}");
      spots.add(FlSpot(i.toDouble(), _trades[i].profitLoss ?? 0.0));
    }
    return spots;
  }

  // Calculate trade quantity over time for Bar Chart
  List<BarChartGroupData> get tradeVolume {
    List<BarChartGroupData> bars = [];
    for (int i = 0; i < _trades.length; i++) {
      bars.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(toY: _trades[i].quantity.toDouble(), color: Colors.blue),
        ],
      ));
    }
    return bars;
  }

  // Winning vs. Losing trades for Pie Chart
  Map<String, double> get winLossData {
    int wins = _trades.where((trade) => (trade.profitLoss ?? 0) > 0).length;
    int losses = _trades.length - wins;
    return {
      "Winning Trades": wins.toDouble(),
      "Losing Trades": losses.toDouble(),
    };
  }

  // Get highest & lowest profit trades for display
  Trade? get highestProfitTrade {
    return _trades.isEmpty ? null : _trades.reduce((a, b) => (a.profitLoss ?? 0) > (b.profitLoss ?? 0) ? a : b);
  }

  Trade? get lowestProfitTrade {
    return _trades.isEmpty ? null : _trades.reduce((a, b) => (a.profitLoss ?? 0) < (b.profitLoss ?? 0) ? a : b);
  }



  Map<String, dynamic> getTradingStatistics() {
    if (_trades.isEmpty) {
      return {
        "totalTrades": 0,
        "winRate": 0,
        "totalProfitLoss": 0.0,
        "avgProfitPerTrade": 0.0,
        "largestWin": 0.0,
        "largestLoss": 0.0,
        "winStreak": 0,
        "lossStreak": 0,
        "riskRewardRatio": 0.0,
        "tradingFrequency": 0.0,
      };
    }

    int totalTrades = _trades.length;
    int winningTrades = _trades.where((trade) => trade.profitLoss > 0).length;
    int losingTrades = totalTrades - winningTrades;

    double totalProfitLoss = _trades.fold(0, (sum, trade) => sum + trade.profitLoss);
    double avgProfitPerTrade = totalProfitLoss / totalTrades;
    double largestWin = _trades.map((t) => t.profitLoss).reduce((a, b) => a > b ? a : b);
    double largestLoss = _trades.map((t) => t.profitLoss).reduce((a, b) => a < b ? a : b);

    int winStreak = _calculateStreak(true);
    int lossStreak = _calculateStreak(false);

    double totalWins = _trades.where((trade) => trade.profitLoss > 0).fold(0, (sum, trade) => sum + trade.profitLoss);
    double totalLosses = _trades.where((trade) => trade.profitLoss < 0).fold(0, (sum, trade) => sum + trade.profitLoss.abs());

    double riskRewardRatio = totalLosses > 0 ? totalWins / totalLosses : totalWins > 0 ? 999.0 : 0.0;

    double tradingFrequency = totalTrades / _calculateTradingDays();

    return {
      "totalTrades": totalTrades,
      "winRate": (winningTrades / totalTrades * 100).toStringAsFixed(2),
      "totalProfitLoss": totalProfitLoss.toStringAsFixed(2),
      "avgProfitPerTrade": avgProfitPerTrade.toStringAsFixed(2),
      "largestWin": largestWin.toStringAsFixed(2),
      "largestLoss": largestLoss.toStringAsFixed(2),
      "winStreak": winStreak,
      "lossStreak": lossStreak,
      "riskRewardRatio": riskRewardRatio.toStringAsFixed(2),
      "tradingFrequency": tradingFrequency.toStringAsFixed(2),
    };
  }

  int _calculateStreak(bool isWinStreak) {
    int maxStreak = 0, currentStreak = 0;
    for (Trade trade in _trades) {
      if ((isWinStreak && trade.profitLoss > 0) || (!isWinStreak && trade.profitLoss < 0)) {
        currentStreak++;
        maxStreak = currentStreak > maxStreak ? currentStreak : maxStreak;
      } else {
        currentStreak = 0;
      }
    }
    return maxStreak;
  }

  int _calculateTradingDays() {
    Set<String> tradingDays = _trades.map((trade) => trade.date.split(' ')[0]).toSet();
    return tradingDays.length > 0 ? tradingDays.length : 1;
  }
}