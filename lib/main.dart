import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:prefs/prefs.dart';
import 'package:provider/provider.dart';
import 'package:qequalizer_update/Features/Ads/AppOpen/app_open_wrapper_widget.dart';
// import 'package:move_to_background/move_to_background.dart';
import 'Features/Ads/google_ads.dart';
import 'Features/local_notifications.dart';
import 'Providers/themes.dart';
import 'Pages/eq_page.dart';
import 'firebase_options.dart';
import 'page_design.dart';
import 'Pages/settings_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Prefs.init();
  Provider.debugCheckInvalidValueType = null;
  await dotenv.load(fileName: ".env");
  // BackroundManager.initBackround();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // init Ads
  GoogleAdsService().init();

  // Init notification
  await LocalNotifications.init();

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);

    theme.getData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.themeData,
      title: 'QEqualizer',
      home: AppOpenWraperWidget(
        child: WillPopScope(
          onWillPop: () async {
            if (Platform.isAndroid) {
              if (Navigator.of(context).canPop()) {
                return true;
              } else {
                // MoveToBackground.moveTaskToBack();
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
      ),
    );
  }
}
