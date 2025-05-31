import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:provider/provider.dart';
import 'package:trading_journal/providers/trade_provider.dart';
import 'package:trading_journal/utils/globals.dart';
import 'package:trading_journal/widgets/custom_Drawer.dart';

import '../services/adbmob_service.dart';
import '../widgets/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var _selectedIndex = 0;

  @override
  void initState() {
    checkForUpdate();
    Provider.of<TradeProvider>(context, listen: false).fetchAllTrades();
    super.initState();
  }

  /// Method To Check for Update
  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(),
      drawer: CustomDrawer(),
      body: pages.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF000000), // This affects both icon and label color when selected
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
          onTap: (value){
            setState(() {
              _selectedIndex = value;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.list_alt, color: Color(0xFF33B49B),),
                label: 'Trade Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.stacked_line_chart, color: Color(0xFF33B49B),),
              label: 'Trades Performance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, color: Color(0xFF33B49B),),
              label: 'Trading Dashboard',
            ),
          ],
      ),
    );
  }
}