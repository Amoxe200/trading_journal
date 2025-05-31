import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trading_journal/providers/trade_provider.dart';
import 'package:trading_journal/repositories/trade_repository.dart';
import 'package:trading_journal/screens/home_screen.dart';
import 'package:trading_journal/services/adbmob_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final tradeRepository = TradeRepo();
  await tradeRepository.initDB();
  //AdmobService.resetActionCount();
  AdmobService.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TradeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      home: HomeScreen(),
    );
  }
}