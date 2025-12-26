import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/theme/AppColors.dart';

class CustomCategoryButton extends StatefulWidget {
  final int index;
  final ValueNotifier<int> selectedIndexNotifier;
  final String text;
  final VoidCallback? onPressed;

  const CustomCategoryButton({
    super.key,
    required this.index,
    required this.selectedIndexNotifier,
    required this.text,
    required this.onPressed,
  });

  @override
  State<CustomCategoryButton> createState() => _CustomCategoryButtonState();
}

class _CustomCategoryButtonState extends State<CustomCategoryButton> {

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
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: widget.selectedIndexNotifier.value == widget.index ? colors.gradientButtonsStart : colors.containerBackground1,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: totalWidth * 0.04,
          vertical: totalHeight * 0.008,
        ),

        child: Text(
          widget.text,
          style: GoogleFonts.montserrat(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: widget.selectedIndexNotifier.value == widget.index ? Colors.white : colors.text2,
          ),
        ),
      ),
    );
  }
}

