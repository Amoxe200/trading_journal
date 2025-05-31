import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';

class TradeVolumeChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TradeProvider>(context);

    // Calculate maxVolume directly
    final maxVolume = provider.tradeVolume.isEmpty
        ? 0.0
        : provider.tradeVolume
        .map((group) => group.barRods.first.toY)
        .reduce((max, value) => value > max ? value : max);

    if (provider.trades.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_outlined, size: 20, color: Colors.grey),
            SizedBox(height: 10),
            Text(
              'No Trade Volume Data',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold
              ),
            )
          ],
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: maxVolume * 1.2, // Add 20% padding on top
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: _calculateVolumeInterval(maxVolume),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withOpacity(0.2),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      value.toStringAsFixed(1),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                reservedSize: 40,
                interval: _calculateVolumeInterval(maxVolume),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= provider.trades.length) return const Text('');

                  final trade = provider.trades[value.toInt()];
                  final date = DateTime.parse(trade.date);
                  final formattedDate = '${date.day}/${date.month}';

                  return Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
                interval: _calculateBottomInterval(provider.trades.length),
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 1),
              left: BorderSide(color: Colors.grey, width: 1),
            ),
          ),
          barGroups: provider.tradeVolume.map((group) {
            return BarChartGroupData(
              x: group.x,
              barRods: [
                BarChartRodData(
                  toY: group.barRods.first.toY,
                  width: 16,
                  color: _getBarColor(group.barRods.first.toY, maxVolume),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxVolume,
                    color: Colors.grey.withOpacity(0.1),
                  ),
                ),
              ],
            );
          }).toList(),
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              //fillColor: Colors.white, // Changed from tooltipBgColor to fillColor
              tooltipRoundedRadius: 8,
              tooltipBorder: BorderSide(color: Colors.grey.withOpacity(0.2)),
              tooltipPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY.toStringAsFixed(2)} coins\n',
                  TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  children: [
                    TextSpan(
                      text: provider.trades[group.x].date,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods remain the same
  double _calculateVolumeInterval(double maxVolume) {
    if (maxVolume <= 10) return 1;
    if (maxVolume <= 50) return 5;
    if (maxVolume <= 100) return 10;
    if (maxVolume <= 500) return 50;
    return maxVolume / 10;
  }

  double _calculateBottomInterval(int totalTrades) {
    if (totalTrades <= 5) return 1;
    if (totalTrades <= 10) return 2;
    if (totalTrades <= 20) return 4;
    return (totalTrades / 5).ceil().toDouble();
  }

  Color _getBarColor(double volume, double maxVolume) {
    final percentage = volume / maxVolume;

    if (percentage < 0.3) return Color(0xFF64B5F6);  // Light blue
    if (percentage < 0.6) return Color(0xFF2196F3);  // Medium blue
    return Color(0xFF1976D2);  // Dark blue
  }
}