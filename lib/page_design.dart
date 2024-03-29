import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qequalizer_update/Providers/themes.dart';

class PageDesign extends StatefulWidget {
  const PageDesign({super.key, required this.drawer, required this.body});
  final Widget drawer;
  final Widget body;
  @override
  PageDesignState createState() => PageDesignState();
}

class PageDesignState extends State<PageDesign> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool shouldDrag = false;
  bool isUIHidden = false;
  _open() {
    isUIHidden = true;
    animationController.forward();
  }

  _close() {
    isUIHidden = false;
    animationController.reverse();
  }

  _doAnimation() {
    animationController.isCompleted ? _close() : _open();
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Themes theme = Provider.of<Themes>(context);
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      floatingActionButton: SafeArea(
        child: AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget? child) {
            return Row(
              children: [
                IconButton(
                  iconSize: 28,
                  color: theme.color,
                  icon: const Icon(Icons.menu_rounded),
                  onPressed: _doAnimation,
                ),
                Opacity(
                  opacity: 1 - animationController.value,
                  child: Text(
                    "QEqualizer",
                    style: TextStyle(
                      color: theme.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      body: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget? child) {
          double slide = deviceSize.width * animationController.value * 1.354;
          double scale = 1 - (animationController.value * 0.5);
          return Stack(
            children: [
              Opacity(
                opacity: animationController.value,
                child: widget.drawer,
              ),
              Transform(
                alignment: Alignment.centerLeft,
                transform: Matrix4.identity()
                  ..scale(scale)
                  ..translate(slide),
                child: SafeArea(
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: animationController.value,
                        child: Center(
                          child: GestureDetector(
                            onTap: _doAnimation,
                            child: Container(
                              width: 250,
                              height: 250,
                              decoration: BoxDecoration(
                                color: theme.color,
                                borderRadius: BorderRadius.circular(1000),
                              ),
                              child: const Icon(
                                Icons.graphic_eq_rounded,
                                size: 150,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: 1 - animationController.value,
                        child: IgnorePointer(
                          ignoring: isUIHidden,
                          child: widget.body,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
