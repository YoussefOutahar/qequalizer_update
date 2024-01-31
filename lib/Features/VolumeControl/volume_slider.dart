import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../Providers/screen_config.dart';
import '../../Providers/themes.dart';

class VolumeV extends StatefulWidget {
  const VolumeV({super.key, required this.enable});
  final bool enable;
  @override
  VolumeVState createState() => VolumeVState();
}

class VolumeVState extends State<VolumeV> {
  late Future<double> _val;
  initVolControls() {
    _val = VolumeController().getVolume();
  }

  @override
  void initState() {
    super.initState();
    initVolControls();
  }

  @override
  void dispose() {
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);
    SizeConfig().init(context);
    return FutureBuilder(
        future: _val,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            double val = snapshot.data as double;
            return SizedBox(
              height: SizeConfig.blockSizeVertical! * 23,
              width: SizeConfig.blockSizeHorizontal! * 35,
              child: SleekCircularSlider(
                initialValue: val * 100,
                appearance: CircularSliderAppearance(
                  infoProperties: InfoProperties(
                    bottomLabelText: 'Volume',
                    bottomLabelStyle: Theme.of(context).textTheme.labelLarge,
                    mainLabelStyle: Theme.of(context).textTheme.headlineSmall,
                    modifier: (double value) {
                      final roundedValue = value.ceil().toInt().toString();
                      return '$roundedValue ';
                    },
                  ),
                  customWidths: CustomSliderWidths(
                    progressBarWidth: 8,
                  ),
                  customColors: CustomSliderColors(
                    hideShadow: true,
                    trackColor: Colors.grey[300],
                    progressBarColor: widget.enable ? theme.color : Colors.grey[400],
                  ),
                ),
                onChange: (double value) {
                  setState(() {
                    val = value / 100;
                    VolumeController().setVolume(
                      val,
                      showSystemUI: true,
                    );
                    val = val * 100;
                  });
                },
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
