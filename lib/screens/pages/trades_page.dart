import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:trading_journal/widgets/adsWidgets/banner_widget.dart';

import '../../providers/trade_provider.dart';
import '../../services/adbmob_service.dart';
import '../../widgets/trade_item_widget.dart';
import '../add_trade_scene.dart';

class TradesPage extends StatefulWidget {
  const TradesPage({super.key});

  @override
  State<TradesPage> createState() => _TradesPageState();
}

class _TradesPageState extends State<TradesPage> {

  @override
  void initState() {
    // TODO: implement initState
    AdmobService.creatInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.06),
        child: FloatingActionButton(
          onPressed: (){
            AdmobService.showInterstitialAd(onAdDismissed: (){});
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddTradeScreen()),
            );
          },
          backgroundColor: Color(0xFF33B49B),
          child:  Icon(Icons.add, color: Colors.white),
        ),
      ),
      body: Consumer<TradeProvider>(
        builder: (context, provider, child) {
          if (provider.trades.isEmpty) {
            return Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.show_chart,
                        size: 120,
                        color: Color(0xFF33B49B).withOpacity(0.5),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No Trades Yet 📈',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start by adding your first trade!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AdBanner(),
                ),
              ],
            );
          }
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: provider.trades.length,
                  itemBuilder: (context, index) {
                    return TradeItemWidget(trade: provider.trades[index]);
                  },
                ),
              ),
              SizedBox(height: 16,),
              AdBanner(),
            ],
          );
        },
      ),
    );
  }
}
