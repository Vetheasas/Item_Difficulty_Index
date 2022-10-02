import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class PageEleven extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;
  final double addedVertical = -0.2;
  PageEleven(this.page, this.notifier);

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
                      "mobile_tutorial_img/10.png",
                    ),
                    offset: 300),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.78),
              child: SlidingContainer(
                offset: 250,
                child: Text(
                  "Find the csv file located in\n"
                  " the extracted location of your choice",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 22,
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
