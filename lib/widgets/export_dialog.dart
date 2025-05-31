import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:trading_journal/services/csv_export_service.dart';
import 'package:trading_journal/services/pdf_export_service.dart';

Widget customDialog(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24.0),
    ),
    elevation: 8.0,
    backgroundColor: Colors.white,
    child: Container(
      width: MediaQuery.of(context).size.width * 0.85, // Constrain width
      padding: EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.file_download_outlined,
            size: 48,
            color: Color(0xFF33B49B),
          ),
          SizedBox(height: 16),
          Text(
            'Export Your Data 📊',
            style: TextStyle(
              fontSize: 22, // Slightly reduced
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Choose your preferred format',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Wrap( // Using Wrap instead of Row
            spacing: 16, // Horizontal spacing
            runSpacing: 16, // Vertical spacing
            alignment: WrapAlignment.center,
            children: [
              _buildExportButton(
                onTap: () async{
                  // CSV export logic
                  final path = await CsvExportService.exportToCSV(context);
                  OpenFile.open(path);
                  },
                color: Color(0xFF33B49B),
                text: 'CSV',
                icon: Icons.table_chart,
              ),
              _buildExportButton(
                onTap: () async {
                  // PDF export logic
                  final path = await PdfExportService.pdfExport(context);
                  OpenFile.open(path);
                },
                color: Color(0xFFFF474D),
                text: 'PDF',
                icon: Icons.picture_as_pdf,
              ),
            ],
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildExportButton({
  required VoidCallback onTap,
  required Color color,
  required String text,
  required IconData icon,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Reduced padding
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}