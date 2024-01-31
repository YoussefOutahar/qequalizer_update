import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdService {
  final int maxFailedLoadAttempts = 3;

  int _numInterstitialLoadAttempts = 0;
  int _numRewardedLoadAttempts = 0;

  late InterstitialAd _interstitialAd;
  late RewardedAd _rewardedAd;

  void createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: "ca-app-pub-7511772989365508/4363078076",
        request: const AdRequest(
          nonPersonalizedAds: true,
        ),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            // print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd.dispose();
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd() {
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {},
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        // print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd.show();
    _interstitialAd.dispose();
  }

  void createRewardedAd() {
    RewardedAd.load(
        adUnitId: "ca-app-pub-7511772989365508/7418833863",
        request: const AdRequest(
          keywords: <String>['foo', 'bar'],
          contentUrl: 'http://foo.com/bar.html',
          nonPersonalizedAds: true,
        ),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd.dispose();
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd() {
    _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {},
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd.show(
      onUserEarnedReward: (ad, reward) {
        print('$ad with reward $reward');
      },
    );
    _rewardedAd.dispose();
  }
}

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});
  @override
  BannerState createState() => BannerState();
}

class BannerState extends State<AdBanner> {
  late BannerAd _banner;
  bool bannerisloaded = false;
  Widget showBanner() {
    if (bannerisloaded) {
      return AdWidget(ad: _banner);
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    super.initState();
    _banner = BannerAd(
      size: AdSize.banner,
      adUnitId: "ca-app-pub-7511772989365508/7418833863",
      listener: BannerAdListener(onAdLoaded: (ad) {
        setState(() {
          _banner = ad as BannerAd;
          bannerisloaded = true;
          debugPrint(bannerisloaded.toString());
        });
      }, onAdFailedToLoad: (ad, error) {
        setState(() {
          _banner.dispose();
          bannerisloaded = false;
          debugPrint(error.toString());
          ad.dispose();
        });
      }),
      request: const AdRequest(),
    );
    _banner.load();
  }

  @override
  void dispose() {
    _banner.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30.0),
      width: AdSize.banner.width.toDouble(),
      height: AdSize.banner.height.toDouble(),
      alignment: Alignment.topCenter,
      child: showBanner(),
    );
  }
}
