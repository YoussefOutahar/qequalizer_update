import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'Widgets/banner_ad.dart';
import 'Widgets/native_ad.dart';

class GoogleAdsService {
  void init() {
    MobileAds.instance.initialize();
  }

  final bannerAdUnitId = dotenv.env['GOOGLE_BANNER_AD_UNIT_ID']!;
  final interstitialAdUnitId = dotenv.env['GOOGLE_INTERSTITIAL_AD_UNIT_ID']!;
  final nativeAdUnitId = dotenv.env['GOOGLE_NATIVE_AD_UNIT_ID']!;
  final appOpenUnitId = dotenv.env['GOOGLE_APP_OPEN_AD_UNIT_ID']!;

  InterstitialAd? _interstitialAd;

  get bannerAd => BannerAdWidget(adUnitId: bannerAdUnitId);

  nativeAd({required TemplateType templateType}) {
    return GoogleNativeAd(
      adUitId: nativeAdUnitId,
      templateType: templateType,
    );
  }

  Future<void> loadInterstitial(
      {required void Function() onAdLoaded, required void Function(LoadAdError error) onAdFailedToLoad}) {
    return InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (ad) {
            _interstitialAd = ad;
            _interstitialAd!.show();
            onAdLoaded();
          },
          onAdFailedToLoad: (LoadAdError error) {
            onAdFailedToLoad(error);
          },
        ));
  }

  Widget getBannerAdWidget() => BannerAdWidget(adUnitId: bannerAdUnitId);
}
