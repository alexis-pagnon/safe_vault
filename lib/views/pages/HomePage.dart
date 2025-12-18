import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_vault/views/widgets/CustomCard.dart';
import 'package:safe_vault/views/widgets/CustomSvgButton.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import '../../models/theme/AppColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: totalHeight * 0.022,
            children: <Widget>[
              // Top Side
              Container(
                height: totalHeight * 0.56,
                padding: EdgeInsets.all(totalWidth * 0.04),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colors.gradientTopStart, colors.gradientTopEnd],
                    begin: AlignmentGeometry.topCenter,
                    end: AlignmentGeometry.bottomCenter,
                  ),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45), bottomRight: Radius.circular(45)),
                ),

                child: Column(
                  children: [
                    // Titles + Top Right Icon
                    Container(
                      padding: EdgeInsets.fromLTRB(totalWidth * 0.02, totalHeight * 0.00, 0, totalHeight * 0.01),
                      child: Row(
                        children: [
                          // Titles
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Bonjour  👋",
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: colors.text1,
                                ),
                              ),
                              Text(
                                "Mon Coffre-Fort",
                                style: GoogleFonts.montserrat(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colors.text1,
                                ),
                              ),

                            ],
                          ),

                          // Icon

                        ],

                      ),
                    ),

                    // Score + Infos
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colors.containerBackground1,
                          borderRadius: BorderRadius.circular(45),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: totalWidth * 0.05, vertical: totalHeight * 0.02),

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: totalHeight * 0.02,
                          children: [
                            // Title
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Santé des mots de passe",
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: colors.text2,
                                ),
                              ),
                            ),

                            // Score
                            // TODO: Alexis: Changer la valeur initiale du SleekCircularSlider avec la vraie
                            Expanded(
                              child: Center(
                                child: SleekCircularSlider(
                                  appearance: CircularSliderAppearance(
                                    customWidths: CustomSliderWidths(progressBarWidth: 10, trackWidth: 8),
                                    infoProperties: InfoProperties(
                                      mainLabelStyle: GoogleFonts.montserrat(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w500,
                                        color: colors.greenDarker,
                                      ),

                                      modifier: (double value) {
                                        return '${value.toInt()}';
                                      },
                                    ),
                                    customColors: CustomSliderColors(
                                      dotColor: Colors.transparent,
                                      progressBarColors: [colors.greenLight, colors.greenDarker,],
                                      gradientStartAngle: 0,
                                      gradientEndAngle: 270,
                                      trackColor: Color(0xFFD9D9D9),
                                    ),
                                    size: 140,
                                  ),
                                  min: 0,
                                  max: 100,
                                  initialValue: 80,
                                ),
                              ),
                            ),

                            // Infos
                            // TODO: Alexis: Changer les chiffres avec les vrais
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Compromised
                                Container(
                                  height: totalHeight * 0.095,
                                  width: totalWidth * 0.33,
                                  decoration: BoxDecoration(
                                    color: colors.pinkLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "12",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: colors.pinkDarker,
                                        ),
                                      ),

                                      Text(
                                        "Compromis",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: colors.text5,
                                        ),
                                      ),
                                    ],


                                  ),

                                ),

                                // Weak
                                Container(
                                  height: totalHeight * 0.095,
                                  width: totalWidth * 0.33,
                                  decoration: BoxDecoration(
                                    color: colors.purpleLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "21",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: colors.purpleDarker,
                                        ),
                                      ),

                                      Text(
                                        "Faibles",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: colors.text5,
                                        ),
                                      ),
                                    ],


                                  ),

                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Reused
                                Container(
                                  height: totalHeight * 0.095,
                                  width: totalWidth * 0.33,
                                  decoration: BoxDecoration(
                                    color: colors.orangeLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "12",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: colors.orangeDarker,
                                        ),
                                      ),

                                      Text(
                                        "Réutilisés",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: colors.text5,
                                        ),
                                      ),
                                    ],


                                  ),

                                ),

                                // Safe
                                Container(
                                  height: totalHeight * 0.095,
                                  width: totalWidth * 0.33,
                                  decoration: BoxDecoration(
                                    color: colors.greenLight,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "21",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: colors.greenDarker,
                                        ),
                                      ),

                                      Text(
                                        "Sûrs",
                                        style: GoogleFonts.montserrat(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: colors.text5,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),

              // Bottom Side
              Container(
                margin: EdgeInsets.symmetric(horizontal: totalWidth * 0.07),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: totalHeight * 0.022,
                  children: [
                    Text(
                      "Catégories",
                      style: GoogleFonts.montserrat(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: colors.text2,
                      ),
                    ),

                    // Categories
                    // TODO: ALEXIS: Change le subtitle avec le vrai nombre de mots de passe
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Website
                        CustomCard(
                          svgPath: 'assets/svg/internet.svg',
                          title: 'Sites Web',
                          subtitle: '12 mots de passe',
                        ),

                        // Website
                        CustomCard(
                          svgPath: 'assets/svg/social_network.svg',
                          title: 'Réseaux Sociaux',
                          subtitle: '24 mots de passe',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Apps
                        CustomCard(
                          svgPath: 'assets/svg/smartphone.svg',
                          title: 'Applications',
                          subtitle: '56 mots de passe',
                        ),

                        // Website
                        CustomCard(
                          svgPath: 'assets/svg/shopping_cart.svg',
                          title: 'Paiements',
                          subtitle: '41 mots de passe',
                        ),
                      ],
                    ),

                    // Generate Password Button
                    CustomSvgButton(
                      title: 'Générateur de mots de passe',
                      svgPath: 'assets/svg/stars.svg',
                      onPressed: () {},
                    ),

                    // Secured Notes Button
                    CustomSvgButton(
                      title: 'Notes sécurisées',
                      svgPath: 'assets/svg/notes.svg',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),

              // Spacing
              SizedBox(height: totalHeight * 0.05),

            ],
          ),
        ),
      ),
    );
  }
}
