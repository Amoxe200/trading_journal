import 'package:flutter/material.dart';
import 'package:trading_journal/widgets/export_dialog.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        ' 📊 Trading Journal',
        style: TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.download, color: Color(0xFF33B49B)),
          onPressed: () {
            // TODO: Add analytics view
            showDialog(context: context, builder: (BuildContext context){
              return customDialog(context);
            });
          },
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}