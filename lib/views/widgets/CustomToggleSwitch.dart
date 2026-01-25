import 'package:flutter/material.dart';

class CustomToggleSwitch extends StatefulWidget {
  final int initialValue;
  final List<Color> thumbColor;
  final List<Color> circleColor;
  final List<Color> svgColor;
  final List<IconData> icons;
  final VoidCallback onToggle;

  const CustomToggleSwitch({
    super.key,
    required this.initialValue,
    required this.thumbColor,
    required this.circleColor,
    required this.svgColor,
    required this.icons,
    required this.onToggle,
  });

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
    print("initial value: $value");
  }

  @override
  Widget build(BuildContext context) {
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        setState(() {
          value = value == 0 ? 1 : 0;
          widget.onToggle();
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: totalWidth * 0.15,
        height: totalHeight * 0.035,
        decoration: BoxDecoration(
          color: widget.thumbColor[value],
          borderRadius: BorderRadius.circular(30),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: value == 1 ? Alignment.centerRight : Alignment.centerLeft,
          child: AnimatedContainer(
            height: totalHeight * 0.035,
            width: totalHeight * 0.035,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: widget.circleColor[value],
              shape: BoxShape.circle,
            ),
            child: Padding(
              padding: EdgeInsets.all(totalHeight * 0.000),
              child: Icon(
                widget.icons[value],
                color: widget.svgColor[value],
              ),
            ),
          ),
        ),
      ),
    );
  }
}