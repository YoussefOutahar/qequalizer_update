import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';

class BackroundManager {
  static void initBackround() async {
    const androidConfig = FlutterBackgroundAndroidConfig(
      notificationTitle: "QEqualizer",
      notificationImportance: AndroidNotificationImportance.Default,
      notificationIcon: AndroidResource(name: 'background_icon'),
      shouldRequestBatteryOptimizationsOff: true,
      showBadge: true,
      notificationText: "Running in background",
      enableWifiLock: true,
    );
    bool succes = await FlutterBackground.initialize(androidConfig: androidConfig);

    debugPrint("Background init succes: $succes");
  }

  static void backroundLogic(bool enable) async {
    bool hasPermissions = await FlutterBackground.hasPermissions;

    debugPrint("Background has permissions: $hasPermissions");

    if (hasPermissions && enable) {
      await FlutterBackground.enableBackgroundExecution();
      debugPrint("Background enabled");
    } else if (enable) {
      FlutterBackground.disableBackgroundExecution();
      debugPrint("Background disabled");
    }
  }
}
