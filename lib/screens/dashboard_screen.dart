import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';

class TradingStatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TradeProvider>(context);
    final stats = provider.getTradingStatistics();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: stats.isEmpty
            ? Center(child: Text("No trading data available.", style: TextStyle(fontSize: 18)))
            : GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.3,
          children: [
            _buildStatCard("Total Trades", stats["totalTrades"].toString(), Icons.assessment),
            _buildStatCard("Win Rate", "${stats["winRate"]}%", Icons.emoji_events),
            _buildStatCard("Total Profit/Loss", "\$${stats["totalProfitLoss"]}", Icons.attach_money),
            _buildStatCard("Avg. Profit/Trade", "\$${stats["avgProfitPerTrade"]}", Icons.trending_up),
            _buildStatCard("Largest Win", "\$${stats["largestWin"]}", Icons.emoji_emotions),
            _buildStatCard("Largest Loss", "\$${stats["largestLoss"]}", Icons.sentiment_very_dissatisfied),
            _buildStatCard("Win Streak", "${stats["winStreak"]}", Icons.star),
            _buildStatCard("Loss Streak", "${stats["lossStreak"]}", Icons.star_border),
            _buildStatCard("Risk-Reward Ratio", "${stats["riskRewardRatio"]}", Icons.balance),
            _buildStatCard("Trading Frequency", "${stats["tradingFrequency"]} trades/day", Icons.calendar_today),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: Color(0xFF33B49B)),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
