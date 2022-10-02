import 'sliding_mechanic.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class MobileTutorial extends StatefulWidget {
  MobileTutorial({
    Key? key,
  }) : super(key: key);

  @override
  _MobileTutorialState createState() => _MobileTutorialState();
}

class _MobileTutorialState extends State<MobileTutorial> {
  final ValueNotifier<double> notifier = ValueNotifier(0);
  final _pageCtrl = PageController();
  int pageCount = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        children: <Widget>[
          /// [StatefulWidget] with [PageView] and [AnimatedBackgroundColor].
          SlidingMechanic(
            controller: _pageCtrl,
            pageCount: pageCount,
            notifier: notifier,
          ),

          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                _pageCtrl.previousPage(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.linear,
                );
              },
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                _pageCtrl.nextPage(
                  duration: Duration(milliseconds: 600),
                  curve: Curves.linear,
                );
              },
            ),
          ),
        ],
      )),
    );
  }
}
