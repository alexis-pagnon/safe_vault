import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/theme/AppColors.dart';

class CustomCard extends StatelessWidget {
  final String svgPath;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;


  const CustomCard({
    super.key,
    required this.svgPath,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: totalHeight * 0.15,
        width: totalWidth * 0.40,
        decoration: BoxDecoration(
          color: colors.containerBackground1,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.dropShadow,
              blurRadius: 6,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(totalWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              svgPath,
              height: totalHeight * 0.04,
              colorFilter: ColorFilter.mode(colors.text3, BlendMode.srcIn),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.text3,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: colors.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}