import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/theme/AppColors.dart';

class CustomSvgButton extends StatelessWidget {
  final String title;
  final String svgPath;
  final VoidCallback? onPressed;
  final bool isAvailable;

  const CustomSvgButton({
    super.key,
    required this.title,
    required this.svgPath,
    required this.onPressed,
    this.isAvailable = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: isAvailable ? onPressed : null, // Disable button if not available
      child: Container(
        width: double.infinity,
        height: totalHeight * 0.06,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: isAvailable
            ? [colors.gradientButtonsStart, colors.gradientButtonsEnd]
            : [colors.gradientButtonsUnavailableStart, colors.gradientButtonsUnavailableEnd],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          children: [
            // Svg
            Padding(
              padding: EdgeInsets.symmetric(horizontal: totalWidth * 0.025),
              child: SvgPicture.asset(
                svgPath,
                height: totalHeight * 0.04,
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),

            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}