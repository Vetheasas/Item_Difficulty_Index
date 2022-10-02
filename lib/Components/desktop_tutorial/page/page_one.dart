import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class PageOne extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;
  final double addedVertical = -0.2;
  PageOne(this.page, this.notifier);

  @override
  Widget build(BuildContext context) {
    return SlidingPage(
      page: page,
      notifier: notifier,
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: FractionallySizedBox(
                widthFactor: 1,
                heightFactor: 1,
                child: SlidingContainer(
                    child: Image.asset(
                      "desktop_tutorial_img/img.png",
                    ),
                    offset: 300),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.78),
              child: SlidingContainer(
                offset: 250,
                child: Text(
                  "Open the quiz in your drive",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFF489f75),
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
