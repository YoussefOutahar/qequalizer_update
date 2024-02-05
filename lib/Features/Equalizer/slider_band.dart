import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:provider/provider.dart';

import '../../Providers/screen_config.dart';
import '../../Providers/themes.dart';

class SliderBands extends StatefulWidget {
  const SliderBands(
      {super.key,
      required this.bandId,
      required this.freq,
      required this.enabled,
      required this.max,
      required this.min});

  final int freq;
  final int bandId;
  final bool enabled;
  final double min, max;

  @override
  SliderBandsState createState() => SliderBandsState();
}

class SliderBandsState extends State<SliderBands> {
  late Future<int> _getBandLevel;
  @override
  void initState() {
    _getBandLevel = EqualizerFlutter.getBandLevel(widget.bandId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);
    return Column(
      children: [
        SizedBox(
          height: SizeConfig.blockSizeVertical! * 30,
          width: SizeConfig.blockSizeHorizontal! * 15,
          child: FutureBuilder<int>(
            future: _getBandLevel,
            builder: (context, snapshot) {
              return FlutterSlider(
                handler: FlutterSliderHandler(
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    type: MaterialType.canvas,
                    elevation: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: (widget.enabled) ? theme.color! : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(
                        Icons.arrow_drop_up_rounded,
                        size: 25,
                      ),
                    ),
                  ),
                ),
                trackBar: FlutterSliderTrackBar(
                  inactiveTrackBar: BoxDecoration(color: Colors.grey[300]),
                  activeTrackBar: BoxDecoration(
                    color: (widget.enabled) ? theme.color : Colors.grey,
                  ),
                ),
                disabled: !widget.enabled,
                tooltip: FlutterSliderTooltip(disabled: true),
                axis: Axis.vertical,
                rtl: true,
                min: widget.min,
                max: widget.max,
                values: [snapshot.hasData ? snapshot.data!.toDouble() : 0],
                onDragCompleted: (handlerIndex, lowerValue, upperValue) {
                  EqualizerFlutter.setBandLevel(widget.bandId, lowerValue.toInt());
                },
              );
            },
          ),
        ),
        Text(
          '${widget.freq ~/ 1000}Hz',
          style: const TextStyle(letterSpacing: 0.2, wordSpacing: 0.5),
        ),
      ],
    );
  }
}
