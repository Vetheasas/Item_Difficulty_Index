import 'package:flutter/material.dart';
import 'package:item_performance/constant.dart';

class DesktopSplashScreen extends StatelessWidget {
  const DesktopSplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Color(0xFF46486c)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  'Item Difficulty Index',
                  style: defaultTextStyle.copyWith(
                      fontSize: 80, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 250),
                  child: Transform.scale(
                    scale: 1.5,
                    child: Image.asset(
                      'images/test_logo.png',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
