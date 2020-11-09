import 'package:firebase_admob/firebase_admob.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;
  MobileAdTargetingInfo _targetingInfo;
  AdvertService._internal() {
    _targetingInfo = MobileAdTargetingInfo();
  }
  BannerAd banner;

  showBanner() {
    banner = BannerAd(
        adUnitId: BannerAd.testAdUnitId,
        size: AdSize.smartBanner,
        targetingInfo: _targetingInfo);
    banner
      ..load()
      ..show(anchorOffset: 50);
    banner.dispose();
  }

  hideBanner() {
    banner = null;
  }

  showIntersitial() {
    InterstitialAd interstitialAd = InterstitialAd(
        adUnitId: 'ca-app-pub-1425913863923510/4413442052',
        targetingInfo: _targetingInfo);

    interstitialAd
      ..load()
      ..show();

    interstitialAd.dispose();
  }
}
