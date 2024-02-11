import 'package:flutter/material.dart';

import 'app_lifecycle_reactor.dart';
import 'app_open_manager.dart';

class AppOpenWraperWidget extends StatefulWidget {
  const AppOpenWraperWidget({super.key, required this.child});

  final Widget child;

  @override
  State<AppOpenWraperWidget> createState() => _AppOpenWraperWidgetState();
}

class _AppOpenWraperWidgetState extends State<AppOpenWraperWidget> with WidgetsBindingObserver {
  late AppLifecycleReactor appLifecycleReactor;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    appLifecycleReactor = AppLifecycleReactor(
      appOpenAdManager: AppOpenAdManager()..loadAd(),
    );
    appLifecycleReactor.initState();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    appLifecycleReactor.listenToAppStateChanges();
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
