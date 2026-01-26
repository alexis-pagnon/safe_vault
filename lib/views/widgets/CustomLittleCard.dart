import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/theme/AppColors.dart';

class CustomLittleCard extends StatefulWidget {
  final String svgPath;
  final String title;
  final int index;
  final ValueNotifier<int> selectedIndexNotifier;


  const CustomLittleCard({
    super.key,
    required this.svgPath,
    required this.title,
    required this.index,
    required this.selectedIndexNotifier,
  });

  @override
  State<CustomLittleCard> createState() => _CustomLittleCardState();

}

class _CustomLittleCardState extends State<CustomLittleCard> {
  @override
  void initState() {
    super.initState();
    widget.selectedIndexNotifier.addListener(_updateState);
  }

  @override
  void dispose() {
    widget.selectedIndexNotifier.removeListener(_updateState);
    super.dispose();
  }

  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;
    int selectedIndex = widget.selectedIndexNotifier.value;

    return InkWell(
      onTap: () {
        setState(() {
          widget.selectedIndexNotifier.value = widget.index;
        });
      },

      child: Container(
        height: totalHeight * 0.12,
        width: totalWidth * 0.365,

        decoration: BoxDecoration(
          //color: selectedIndex == widget.index ? Color(0xFF0069FF).withOpacity(0.1) : colors.containerBackground1,
          gradient: selectedIndex == widget.index
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.gradientButtonsStart.withValues(alpha: 0.1),
                  colors.gradientButtonsEnd.withValues(alpha: 0.1),
                ],
              )
            : LinearGradient(
                colors: [
                  colors.containerBackground1,
                  colors.containerBackground1,
                ],
              ),
          borderRadius: BorderRadius.circular(20),
          border: BoxBorder.all(color: selectedIndex == widget.index ? colors.gradientButtonsStart : Color(0xFFE5E7EB), width: 1)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.svgPath,
              height: totalHeight * 0.04,
              colorFilter: ColorFilter.mode(colors.text3, BlendMode.srcIn),
            ),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}