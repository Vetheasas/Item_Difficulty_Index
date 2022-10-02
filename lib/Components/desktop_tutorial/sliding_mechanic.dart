import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sliding_tutorial/flutter_sliding_tutorial.dart';

import 'package:item_performance/Components/desktop_tutorial/page/page_five.dart';
import 'package:item_performance/Components/desktop_tutorial/page/page_four.dart';

import 'package:item_performance/Components/desktop_tutorial/page/page_seven.dart';
import 'package:item_performance/Components/desktop_tutorial/page/page_six.dart';

import 'package:item_performance/Components/desktop_tutorial/page/page_three.dart';

import 'package:item_performance/Components/desktop_tutorial/page/page_two.dart';

import 'page/page_one.dart';

int finalIndex = 0;

class SlidingMechanic extends StatefulWidget {
  const SlidingMechanic({
    required this.controller,
    required this.notifier,
    required this.pageCount,
    Key? key,
  }) : super(key: key);

  final ValueNotifier<double> notifier;
  final int pageCount;
  final PageController controller;

  @override
  State<StatefulWidget> createState() => _SlidingTutorial();
}

class _SlidingTutorial extends State<SlidingMechanic> {
  late PageController _pageController;

  @override
  void initState() {
    _pageController = widget.controller;

    /// Listen to [PageView] position updates.
    _pageController..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackgroundColor(
      pageController: _pageController,
      pageCount: widget.pageCount,

      /// You can use your own color list for page background
      colors: const [
        Color(0xFF1f1f1f),
        Color(0xFF1b1b1d),
        Color(0xFF202124), //Color(0xFF71bfd2), 4673f4 Color(0xFF233ea0)
        Color(0xFF202124),
        Color(0xFF2b2d35),
        Color(0xFF252525),
        Color(0xFF1f1f1f),
      ],
      child: Container(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: List<Widget>.generate(
                widget.pageCount,
                (index) {
                  return _getPageByIndex(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Create different [SlidingPage] for indexes.
  Widget _getPageByIndex(int index) {
    switch (index % 7) {
      case 0:
        return PageOne(index, widget.notifier);
      case 1:
        return PageTwo(index, widget.notifier);
      case 2:
        return PageThree(index, widget.notifier);
      case 3:
        return PageFour(index, widget.notifier);
      case 4:
        return PageFive(index, widget.notifier);
      case 5:
        return PageSix(index, widget.notifier);
      case 6:
        return PageSeven(index, widget.notifier);

      default:
        throw ArgumentError("Unknown position: $index");
    }
  }

  /// Notify [SlidingPage] about current page changes.
  _onScroll() {
    widget.notifier.value = _pageController.page ?? 0;
  }
}
