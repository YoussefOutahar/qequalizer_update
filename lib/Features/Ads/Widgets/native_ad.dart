import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

class GoogleNativeAd extends StatefulWidget {
  const GoogleNativeAd(
    {
      super.key,
      required this.adUitId,
      required this.templateType
    }
  );
  
  final String adUitId;
  final TemplateType templateType;

  @override
  State<GoogleNativeAd> createState() => _GoogleNativeAdState();
}

class _GoogleNativeAdState extends State<GoogleNativeAd> {
  NativeAd? _nativeAd;
  bool _isNativeAdLoaded = false;
  bool _isLoading = false;

  void loadAd() {
    _isLoading = true;
    _nativeAd = NativeAd(
      adUnitId: widget.adUitId,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeAdLoaded = true;
            _isLoading = false;
          });
          debugPrint("google ad loaded");
        },
        onAdFailedToLoad: (ad, error) {
          setState(() {
            _isNativeAdLoaded = false;
            _isLoading = false;
          });
          debugPrint("google failed to load: $error");
        },
      ),
      request: const AdRequest(),
      nativeTemplateStyle:
          NativeTemplateStyle(templateType: TemplateType.medium),
    );
    _nativeAd?.load();
  }

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _isNativeAdLoaded
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                  constraints: const BoxConstraints(
                      maxHeight: 380,
                      maxWidth: 380,
                      minWidth: 320,
                      minHeight: 320),
                  child: AdWidget(ad: _nativeAd!)),
            )
          : _isLoading
              ? buildShimmer()
              : const SizedBox(),
    );
  }

  Widget buildShimmer() {
    return SizedBox(
      width: double.infinity,
      height: 100.0,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[400]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          width: double.infinity,
          height: 100.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
