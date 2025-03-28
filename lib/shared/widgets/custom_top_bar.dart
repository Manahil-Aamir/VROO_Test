import 'package:flutter/material.dart';
import '../../core/theme/color/color_theme.dart';

class CustomTabBar extends StatefulWidget {
  final TabController tabController;
  final List<String> tabTitles;

  const CustomTabBar({super.key, required this.tabController, required this.tabTitles});

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      setState(() {}); // Rebuild when tab index changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Increased height
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade800, // Background color for inactive tabs
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Moving Background for Active Tab
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            left: widget.tabController.index == 0 ? 0 : MediaQuery.of(context).size.width / 2 - 32,
            right: widget.tabController.index == 1 ? 0 : MediaQuery.of(context).size.width / 2 - 32,
            child: Container(
              height: 50, // Match container height
              decoration: BoxDecoration(
                color: ThemeColors.primaryColor, // Orange active tab color
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // Gesture Detector for Full Tab Clickability
          Row(
            children: List.generate(widget.tabTitles.length, (index) {
              return Expanded(
                child: GestureDetector(
                  onTap: () => widget.tabController.animateTo(index), // Detects tap anywhere in tab
                  behavior: HitTestBehavior.opaque, // Ensures the entire area is clickable
                  child: Container(
                    alignment: Alignment.center,
                    height: 50, // Match parent height
                    child: Text(
                      widget.tabTitles[index],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16, // Slightly larger text
                        color: widget.tabController.index == index
                            ? Colors.black
                            : Colors.white, // Text color changes dynamically
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
