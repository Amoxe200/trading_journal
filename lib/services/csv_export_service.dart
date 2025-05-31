import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:provider/provider.dart';
import '../models/trade.dart';
import '../providers/trade_provider.dart';

class CsvExportService {
  static Future<String> exportToCSV(BuildContext context) async {
    List<List<dynamic>> rows = [];
    List<Trade> trades = Provider.of<TradeProvider>(context, listen: false).trades;
    // Add CSV headers
    rows.add(["Date", "Profit/Loss", "Duration (mins)"]);

    // Add trade data
    for (var trade in trades) {
      rows.add([trade.date, trade.profitLoss]);
    }

    String csvData = const ListToCsvConverter().convert(rows);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = "${directory.path}/trades.csv";
    final file = File(filePath);

    await file.writeAsString(csvData);
    return filePath;
  }
}
