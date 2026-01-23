import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/theme/AppColors.dart';

class CustomCategoryButton extends StatelessWidget {
  final int index;
  final int selectedIndex;
  final String text;
  final VoidCallback onPressed;

  const CustomCategoryButton({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    final bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.gradientButtonsStart
              : colors.containerBackground1,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: totalWidth * 0.04,
          vertical: totalHeight * 0.008,
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : colors.text2,
          ),
        ),
      ),
    );
  }
}
