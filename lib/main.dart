import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:prefs/prefs.dart';
import 'package:provider/provider.dart';
import 'package:qequalizer_update/firebase_options.dart';
import 'package:move_to_background/move_to_background.dart';
import 'Features/backround_manager.dart';
import 'Providers/themes.dart';
import 'Pages/eq_page.dart';
import 'page_design.dart';
import 'Pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  MobileAds.instance.initialize();

  Prefs.init();

  Provider.debugCheckInvalidValueType = null;
  BackroundManager.initBackround();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) async {
      runApp(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<Themes>(create: (_) => Themes()),
          ],
          child: const MyApp(),
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);

    theme.getData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.themeData,
      title: 'QEqualizer',
      home: WillPopScope(
        onWillPop: () async {
          if (Platform.isAndroid) {
            if (Navigator.of(context).canPop()) {
              return true;
            } else {
              MoveToBackground.moveTaskToBack();
              print('Moved to background');
              return false;
            }
          } else {
            return true;
          }
        },
        child: const PageDesign(
          body: SafeArea(child: EQ()),
          drawer: SettingsPage(),
        ),
      ),
    );
  }
}
