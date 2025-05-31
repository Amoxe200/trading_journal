import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';

class ProfitLossChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TradeProvider>(context);

    if (provider.trades.isEmpty){
      return Center(
        child: Column(
          children: [
            Icon(Icons.data_thresholding_outlined, size: 20, color: Colors.grey,),
            SizedBox(height: 10,),
            Text('No Data Available', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),)
          ],
        ),
      );
    }
    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
              show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  // Format as currency with proper spacing
                  return Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Text(
                      value >= 0
                          ? '+\$${value.toStringAsFixed(0)}'
                          : '-\$${(-value).toStringAsFixed(0)}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
                // Increase reserved size to prevent grey block
                reservedSize: 40,
                // Calculate interval based on data range
                interval: _calculateInterval(provider.profitLossTrend),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= provider.trades.length) return const Text('');

                  final trade = provider.trades[value.toInt()];
                  // Format date to be more readable
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
                // Show fewer labels to prevent overcrowding
                interval: _calculateBottomInterval(provider.trades.length),
              ),
            ),
          ),
          borderData: FlBorderData(
              show: true,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 3,
              ),
              left: BorderSide(
                color: Colors.grey,
                width: 3,
              )
            )
          ),
          lineBarsData: [
            LineChartBarData(
              spots: provider.profitLossTrend,
              isCurved: true,
              color: Color(0xFF33B49B),
              belowBarData: BarAreaData(
                  show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withOpacity(0.3), // Red for negative values
                    Color(0xFF33B49B).withOpacity(0.3), // Your color for positive values
                  ],
                  stops: [0.0, 1.0],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  // Change dot color based on profit/loss
                  final isPositive = provider.profitLossTrend[index].y >= 0;
                  return FlDotCirclePainter(
                    radius: 4,
                    color: isPositive ? Color(0xFF33B49B) : Colors.red,
                    strokeWidth: 2,
                    strokeColor: Colors.white,
                  );
                },
              ),
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Color(0xFF33B49B),
                ],
                stops: [0.0, 1.0],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                final spot = barData.spots[index];
                final isPositive = spot.y >= 0;
                return TouchedSpotIndicatorData(
                  FlLine(color: isPositive ? Color(0xFF33B49B) : Colors.red, strokeWidth: 2),
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 4,
                        color: isPositive ? Color(0xFF33B49B) : Colors.red,
                        strokeWidth: 2,
                        strokeColor: Colors.white,
                      );
                    },
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.white,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  final isPositive = touchedSpot.y >= 0;
                  return LineTooltipItem(
                    touchedSpot.y.toStringAsFixed(2),
                    TextStyle(
                      color: isPositive ? Color(0xFF33B49B) : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}


// Add these helper methods outside the build method:
double _calculateInterval(List<FlSpot> spots) {
  if (spots.isEmpty) return 100;

  double maxY = spots.map((spot) => spot.y.abs()).reduce(max);
  if (maxY <= 100) return 20;
  if (maxY <= 500) return 100;
  if (maxY <= 1000) return 200;
  if (maxY <= 5000) return 1000;
  return maxY / 5;
}

double _calculateBottomInterval(int totalTrades) {
  if (totalTrades <= 5) return 1;
  if (totalTrades <= 10) return 2;
  if (totalTrades <= 20) return 4;
  return (totalTrades / 5).ceil().toDouble();
}