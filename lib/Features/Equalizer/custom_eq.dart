import 'package:equalizer_flutter/equalizer_flutter.dart';
import 'package:flutter/material.dart';

import '../../Providers/screen_config.dart';
import 'slider_band.dart';

class CustomEQ extends StatefulWidget {
  const CustomEQ(this.enabled, this.bandLevelRange, {super.key});

  final bool enabled;
  final List<int> bandLevelRange;

  @override
  CustomEQState createState() => CustomEQState();
}

class CustomEQState extends State<CustomEQ> {
  late double min, max;
  late String _selectedValue;
  late Future<List<String>> fetchPresets;
  late Future<List<int>> fetchCenterBandfreqs;

  @override
  void initState() {
    super.initState();
    min = widget.bandLevelRange[0].toDouble();
    max = widget.bandLevelRange[1].toDouble();
    fetchPresets = EqualizerFlutter.getPresetNames();
    fetchCenterBandfreqs = EqualizerFlutter.getCenterBandFreqs();
    _selectedValue = 'Normal';
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    int bandId = 0;
    return FutureBuilder<List<int>>(
      future: fetchCenterBandfreqs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: snapshot.data!
                    .map((freq) => SliderBands(
                          bandId: bandId++,
                          freq: freq,
                          enabled: widget.enabled,
                          max: max,
                          min: min,
                        ))
                    .toList(),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: FutureBuilder<List<String>>(
                  future: fetchPresets,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final presets = snapshot.data;
                      if (presets!.isEmpty) return const Text('No presets available!');
                      return SizedBox(
                        height: SizeConfig.blockSizeVertical! * 8,
                        width: SizeConfig.blockSizeHorizontal! * 90,
                        child: DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Available Presets',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          value: _selectedValue,
                          onChanged: widget.enabled
                              ? (String? value) {
                                  setState(() {
                                    _selectedValue = value!;
                                    EqualizerFlutter.setPreset(value);
                                    fetchCenterBandfreqs = EqualizerFlutter.getCenterBandFreqs();
                                  });
                                }
                              : null,
                          items: presets.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: MediaQuery.of(context).size.height / 2.8,
          );
        }
      },
    );
  }
}
