import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';
import '../providers/trade_provider.dart';

class WinLossPieChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TradeProvider>(context);
    final data = provider.winLossData;

    if (data.isEmpty || (data["Winning Trades"] == 0 && data["Losing Trades"] == 0)) {
      return Center(child: Text("No trade data available."));
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: PieChart(
            dataMap: data,
            chartType: ChartType.ring,
            colorList: [Colors.green, Colors.red],
            ringStrokeWidth: 30,
            animationDuration: Duration(milliseconds: 800),
            chartLegendSpacing: 32,
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: true,
              showChartValuesOutside: true,
              decimalPlaces: 1,
            ),
            legendOptions: LegendOptions(
              showLegends: true,
              legendTextStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            centerText: "${(data["Winning Trades"]! + data["Losing Trades"]!).toInt()} Trades",
            baseChartColor: Colors.grey.shade200,
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.circle, color: Colors.green, size: 12),
            SizedBox(width: 5),
            Text("Winning Trades", style: TextStyle(fontSize: 14)),
            SizedBox(width: 20),
            Icon(Icons.circle, color: Colors.red, size: 12),
            SizedBox(width: 5),
            Text("Losing Trades", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
