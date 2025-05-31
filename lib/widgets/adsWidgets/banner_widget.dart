import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:trading_journal/services/adbmob_service.dart';

class AdBanner extends StatefulWidget {

  const AdBanner({ super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  bool _isLoaded = false;
  BannerAd? bannerAd;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadBannerAd();
  }

  void adEventCallback(Ad ad){
    setState(() {
      _isLoaded = true;
    });
  }

  void _loadBannerAd() {
    bannerAd = AdmobService.createBannerAd(adEventCallback, 'ca-app-pub-9197758218548044/4932910860');
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded ? Container(
        height: bannerAd!.size.height.toDouble(),
        width: bannerAd!.size.width.toDouble(),
      child: AdWidget(ad: bannerAd!),
    ) : SizedBox();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    bannerAd!.dispose();
    super.dispose();
  }
}
