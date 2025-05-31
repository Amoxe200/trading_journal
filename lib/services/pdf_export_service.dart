
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:trading_journal/models/trade.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:trading_journal/providers/trade_provider.dart';


class PdfExportService{
  static Future<String> pdfExport(BuildContext context) async{

    List<Trade> _trades = Provider.of<TradeProvider>(context, listen: false).trades;
    Map<String, dynamic> _stats = Provider.of<TradeProvider>(context, listen: false).getTradingStatistics();

    final font_bold = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final ttf_bold = pw.Font.ttf(font_bold);
    final font_regular = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final ttf_regular = pw.Font.ttf(font_regular);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Trade Report", style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttf_bold)),
            pw.SizedBox(height: 10),

            // Key Statistics
            pw.Text("Key Statistics", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf_bold)),
            pw.Divider(),
            pw.Column(
              children: _stats.entries
                  .map((e) => pw.Text("${e.key}: ${e.value}", style: pw.TextStyle(fontSize: 14, font: ttf_regular)))
                  .toList(),
            ),
            pw.SizedBox(height: 10),

            // Trade History
            pw.Text("Trade History", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, font: ttf_bold)),
            pw.Divider(),
            pw.TableHelper.fromTextArray(
              headerStyle: pw.TextStyle(font: ttf_bold),
              cellStyle: pw.TextStyle(font: ttf_regular),
              headers: ["Date", "Profit/Loss", "Duration (mins)"],
              data: _trades.map((t) => [t.date, t.profitLoss.toString()]).toList(),
            ),
          ],
        )
      ),
    );
    try {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = "${directory.path}/trade_report.pdf";
      final file = File(filePath);

      await file.writeAsBytes(await pdf.save());
      print("Saved Succefully at $filePath");
      return filePath;
    } catch (e){
      print("Error accessing document directory $e");
      return '';
    }
  }

}