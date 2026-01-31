import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/theme/AppColors.dart';

class CustomNoteVisualisationPopup extends StatelessWidget {
  final String title;
  final String date;
  final String content;

  const CustomNoteVisualisationPopup({
    super.key,
    required this.title,
    required this.date,
    required this.content
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: totalWidth * 0.06),
      child: Container(
        padding: EdgeInsets.all(totalHeight * 0.02),
        decoration: BoxDecoration(
          color: colors.containerBackground1,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.dropShadow,
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: totalHeight * 0.02,
          children: [
            // Title + Cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: colors.text3,
                  ),
                ),

                // Cancel Button
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: SvgPicture.asset(
                    "assets/svg/cancel.svg",
                    colorFilter: ColorFilter.mode(colors.text3, BlendMode.srcIn),
                    width: totalHeight * 0.03,
                    height: totalHeight * 0.03,
                  ),
                ),

              ],
            ),

            // Date
            Text(
              "Créée le $date",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.text4,
              ),
            ),

            // Content
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: totalHeight * 0.4,
              ),
              child: Container(
                padding: EdgeInsets.all(totalHeight * 0.02),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colors.containerBackground2,
                  border: Border.all(color: colors.text4.withAlpha(127), width: 1)
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Text(
                    content,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.text3,
                    ),

                  ),
                ),
              ),
            ),

            // Close Button
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                height: totalHeight * 0.055,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(colors: [colors.gradientButtonsStart, colors.gradientButtonsEnd])
                ),
                child: Center(
                  child: Text(
                    'Fermer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.text1,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}