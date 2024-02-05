import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prefs/prefs.dart';
import 'package:provider/provider.dart';
import 'package:qequalizer_update/Features/Ads/google_ads.dart';
import 'package:qequalizer_update/firebase_options.dart';
import 'package:move_to_background/move_to_background.dart';
import 'Features/Ads/AppOpen/app_open_manager.dart';
import 'Features/Ads/AppOpen/app_lifecycle_reactor.dart';
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

  GoogleAdsService().init();

  Prefs.init();

  // Init notification

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  late AppLifecycleReactor appLifecycleReactor;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: AppOpenAdManager()..loadAd(),
    );
    appLifecycleReactor.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

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
