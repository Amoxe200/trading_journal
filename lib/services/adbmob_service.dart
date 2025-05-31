import 'dart:async';
import 'dart:ui';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdmobService {

  static final AdmobService _admobService = AdmobService._internal();
  factory AdmobService() => _admobService;

  AdmobService._internal();
  static InterstitialAd? _interstitialAd;

  /// Initialize Admob
  static void init(){
    unawaited(MobileAds.instance.initialize());
  }

  /// Create Banner AD
  static BannerAd createBannerAd(AdEventCallback listener, String bannerAdUnit) {
    return BannerAd(
      size: AdSize.banner,
      request: AdRequest(),
      // Banner Ad Unit
      adUnitId: bannerAdUnit,
      listener: BannerAdListener(
        onAdLoaded: listener,
        onAdFailedToLoad: (ad, error){
          print ("Banner Ad Failed to load: $error");
          ad.dispose();
        }
      ),
    )..load();
  }

  static const String interstitialAdUnit = "ca-app-pub-9197758218548044/3619829191";
  static InterstitialAd? myInterstitialAd;
  static bool isInterstitialAdReady = false;

  // Time-based ad display settings
  static DateTime? _lastAdTime;
  static const int minAdIntervalMinutes = 5; // Show ad no more than once every 5 minutes

  static Future<void> loadLastAdTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAdTimeStr = prefs.getString('last_ad_time');
    if (lastAdTimeStr != null) {
      _lastAdTime = DateTime.parse(lastAdTimeStr);
      print("Last ad shown at: $_lastAdTime");
    }
  }

  static Future<void> saveLastAdTimestamp() async {
    final now = DateTime.now();
    _lastAdTime = now;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_ad_time', now.toIso8601String());
    print("Saved ad timestamp: $now");
  }

  static void creatInterstitialAd(){
    InterstitialAd.load(
      adUnitId: interstitialAdUnit,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad){
            myInterstitialAd = ad;
            isInterstitialAdReady = true;
            ad.fullScreenContentCallback = FullScreenContentCallback(
              onAdDismissedFullScreenContent: (InterstitialAd ad){
                ad.dispose();
                isInterstitialAdReady = false;
                creatInterstitialAd();
              },
            );
          },
          onAdFailedToLoad: (LoadAdError error){
            print("Interstitial Ad Failed to load: $error");
          }
      ),
    );
  }

  static Future<void> showInterstitialAd({required VoidCallback onAdDismissed}) async {
    final now = DateTime.now();
    bool canShowAd = true;

    // Check if enough time has passed since the last ad
    if (_lastAdTime != null) {
      final minutesSinceLastAd = now.difference(_lastAdTime!).inMinutes;
      canShowAd = minutesSinceLastAd >= minAdIntervalMinutes;
      print("Minutes since last ad: $minutesSinceLastAd, Can show ad: $canShowAd");
    }

    if (canShowAd && isInterstitialAdReady && myInterstitialAd != null) {
      print("Showing interstitial ad");
      await saveLastAdTimestamp();
      myInterstitialAd!.show().then((_) {
        myInterstitialAd = null;
        isInterstitialAdReady = false;
        onAdDismissed();
      });
    } else {
      print("Ad not shown - Time condition not met or ad not ready");
      onAdDismissed();
    }
  }
}