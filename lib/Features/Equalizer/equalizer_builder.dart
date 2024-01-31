import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../../Providers/themes.dart';
import 'custom_eq.dart';

class EqualizerBuilder extends StatelessWidget {
  const EqualizerBuilder({
    super.key,
    required Future<List<int>> bandLvlRange,
    required this.enable,
  }) : _bandLvlRange = bandLvlRange;

  final Future<List<int>> _bandLvlRange;
  final bool enable;

  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);
    return FutureBuilder(
      future: _bandLvlRange,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CustomEQ(enable, snapshot.data!);
        } else {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2.8,
            child: Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                color: theme.color!,
                size: 200,
              ),
            ),
          );
        }
      },
    );
  }
}
