import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_background/flutter_background.dart';
import 'package:provider/provider.dart';
import 'package:qequalizer_update/Features/Ads/Widgets/banner_ad.dart';
import 'package:qequalizer_update/Features/backround_manager.dart';
import 'package:qequalizer_update/Features/Ads/google_ads.dart';
import 'package:qequalizer_update/Features/local_notifications.dart';
import '../Features/Equalizer/equalizer_builder.dart';
import '../Features/VolumeControl/volume_slider.dart';
import '../Providers/screen_config.dart';
import '../Providers/themes.dart';

class EQ extends StatefulWidget {
  const EQ({super.key});

  @override
  EQState createState() => EQState();
}

class EQState extends State<EQ> {
  Future<List<int>>? _bandLvlRange;
  // BassBoost boost;
  bool enable = false;

  @override
  void initState() {
    // boost = BassBoost(audioSessionId: 0);
    EqualizerFlutter.init(0);
    EqualizerFlutter.setEnabled(true);
    _bandLvlRange = EqualizerFlutter.getBandLevelRange();
    super.initState();
  }

  @override
  void dispose() {
    // boost.setEnabled(enabled: false);
    EqualizerFlutter.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);
    SizeConfig().init(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: IconButton(
        color: (enable) ? theme.color : Colors.grey,
        onPressed: () {
          setState(() {
            enable = (enable == true) ? false : true;
            EqualizerFlutter.setEnabled(enable);
            // BackroundManager.backroundLogic(enable);
            // boost.setEnabled(enabled: enable);
          });
        },
        icon: Builder(builder: (context) {
          if (!enable) {
            return AvatarGlow(
                glowColor: theme.color!,
                // endRadius: IconTheme.of(context).size! * 3,

                child: const Icon(Icons.power_settings_new_rounded));
          } else {
            return const Icon(Icons.power_settings_new_rounded);
          }
        }),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            ignoring: !enable,
            child: EqualizerBuilder(bandLvlRange: _bandLvlRange!, enable: enable),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: GoogleAdsService().getBannerAdWidget(),
          ),
        ],
      ),
    );
  }
}
