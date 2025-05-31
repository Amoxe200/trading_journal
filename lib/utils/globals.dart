import 'package:flutter/material.dart';
import 'package:trading_journal/screens/dashboard_screen.dart';
import 'package:trading_journal/screens/pages/trades_page.dart';

import '../screens/pages/page_view.dart';

List<Widget> pages = <Widget>[
  const TradesPage(),
  MyPageView(),
  TradingStatisticsScreen(),
];