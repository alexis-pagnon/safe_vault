import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/theme/AppColors.dart';

class CustomStrengthWidget extends StatefulWidget {
  final TextEditingController controller;


  const CustomStrengthWidget({
    super.key,
    required this.controller,
  });

  @override
  State<CustomStrengthWidget> createState() => _CustomStrengthWidgetState();

}

class _CustomStrengthWidgetState extends State<CustomStrengthWidget> {
  Color currentColor = Color(0xFFFB2C36); // Default to very weak color
  String currentStrength = "Très faible"; // Default strength to very weak

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void changeColor(String strength) {
    switch (strength) {
      case "Très faible":
        currentColor = Color(0xFFFB2C36);
        break;
      case "Faible":
        currentColor = Color(0xFFFFA500);
        break;
      case "Moyen":
        currentColor = Color(0xFFFFD700);
        break;
      case "Fort":
        currentColor = Color(0xFF9ACD32);
        break;
      case "Très fort":
        currentColor = Color(0xFF008000);
        break;
      default:
        currentColor = Color(0xFFFB2C36);
    }
  }

  double getValue(String strength) {
    switch (strength) {
      case "Très faible":
        return 0.2;
      case "Faible":
        return 0.4;
      case "Moyen":
        return 0.6;
      case "Fort":
        return 0.8;
      case "Très fort":
        return 1.0;
      default:
        return 0.2;
    }
  }

  void _onTextChanged() {
    String password = widget.controller.text;

    // TODO: ALEXIS: Met ici l'appel de ta fonction d'évaluation de mot de passe avec l'attribut password ci-dessus

    setState(() {
      // TODO: ALEXIS: Met à jour la variable currentStrength avec le résultat de l'évaluation
      // currentStrength = ...
      changeColor(currentStrength);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,

      spacing: totalHeight * 0.01,
      children: [

        // Title + Indicator Title
        Row(
          children: [
            // Title
            Text(
              "Force du mot de passe",
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colors.text3,
              ),
            ),

            Spacer(),

            // Indicator Title
            Text(
              currentStrength,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: currentColor,
              ),
            ),
          ],
        ),

        // Progression Bar
        LinearProgressIndicator(
          value: getValue(currentStrength),
          minHeight: totalHeight * 0.015,
          backgroundColor: colors.containerBackground2,
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFB2C36)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),

        // Recommendations Card
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.containerBackground2,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(totalWidth * 0.04),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: totalHeight * 0.01,
            children: [
              // Title
              Text(
                "Recommandations :",
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: colors.text2,
                ),
              ),

              // TODO: ALEXIS: Remplace les if (true) par les vraies conditions

              // 12 characters
              if(true)
                Row(
                spacing: totalWidth * 0.02,
                children: [
                  SvgPicture.asset(
                    "assets/svg/cancel.svg",
                    height: totalHeight * 0.028,
                  ),

                  Text(
                    "Au moins 12 caractères",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.text2,
                    ),
                  ),
                ],
              ),

              // Uppercase letters
              if(true)
                Row(
                spacing: totalWidth * 0.02,
                children: [
                  SvgPicture.asset(
                    "assets/svg/cancel.svg",
                    height: totalHeight * 0.028,
                  ),

                  Text(
                    "Ajouter des majuscules",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.text2,
                    ),
                  ),
                ],
              ),

              // Numbers
              if(true)
                Row(
                spacing: totalWidth * 0.02,
                children: [
                  SvgPicture.asset(
                    "assets/svg/cancel.svg",
                    height: totalHeight * 0.028,
                  ),

                  Text(
                    "Ajouter des chiffres",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.text2,
                    ),
                  ),
                ],
              ),

              // Special characters
              if(true)
                Row(
                spacing: totalWidth * 0.02,
                children: [
                  SvgPicture.asset(
                    "assets/svg/cancel.svg",
                    height: totalHeight * 0.028,
                  ),

                  Text(
                    "Ajoutez des symboles",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: colors.text2,
                    ),
                  ),
                ],
              ),

            ],
          ),
        )
      ],
    );
  }
}