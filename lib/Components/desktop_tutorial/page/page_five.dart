import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class PageFive extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;
  final double addedVertical = -0.2;
  PageFive(this.page, this.notifier);

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
                      "desktop_tutorial_img/img_4.png",
                    ),
                    offset: 300),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.78),
              child: SlidingContainer(
                offset: 250,
                child: Text(
                  "Find the file in your download folder\n"
                  "Right click on the file. Click Open",
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
