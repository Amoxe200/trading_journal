import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:trading_journal/screens/pages/charts_page.dart';
import 'package:trading_journal/screens/pages/quantity_chart.dart';
import 'package:trading_journal/screens/pages/win_lose_chart.dart';

class MyPageView extends StatelessWidget {
  MyPageView({super.key});
  final controller = PageController(
    initialPage: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: controller,
                children: [
                  ChartsPage(),
                  QuantityChart(),
                  WinLoseChart(),
                ],
              ),
            ),
            SmoothPageIndicator(
                controller: controller,
                count: 3,
                effect: SlideEffect(
                    dotHeight: 12.0,
                    dotWidth: 12.0,
                    spacing:  8.0,
                    dotColor:  Colors.grey,
                    activeDotColor:  Color(0xFF33B49B)
                ),
            ),
          ],
        ),
      )
    );
  }
}
