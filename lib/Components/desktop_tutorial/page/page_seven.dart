import 'package:flutter/material.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

class PageSeven extends StatelessWidget {
  final int page;
  final ValueNotifier<double> notifier;
  final double addedVertical = -0.2;
  PageSeven(this.page, this.notifier);

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
                      "desktop_tutorial_img/img_6.png",
                    ),
                    offset: 300),
              ),
            ),
            Align(
              alignment: Alignment(0, 0.78),
              child: SlidingContainer(
                offset: 250,
                child: Text(
                  "Write the Test Name\n Click Done",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    color: Color(0xFF489f75),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0, 1),
              child: Container(
                color: Color(0xFF35354f),
                height: 50,
                width: double.infinity,
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Exit', //TODO: fix weird tutorial bug
                      style: TextStyle(color: Colors.black, fontSize: 35),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
