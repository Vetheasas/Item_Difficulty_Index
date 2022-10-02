
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:item_performance/constant.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../menu/menu.dart';

import 'dart:async';

import 'desktop_splash_screen.dart';
import 'mobile_splash_screen.dart';

class SplashPage extends StatefulWidget {
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainMenu()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // GoogleSignInAccount? user = currentUser;
    return ScreenTypeLayout(
      desktop: const DesktopSplashScreen(),
      mobile: const MobileSplashScreen(),
    );
  }
}

