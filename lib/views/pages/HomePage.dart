import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/models/SharedPreferencesRepository.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
import 'package:safe_vault/views/widgets/CustomCard.dart';
import 'package:safe_vault/views/widgets/CustomSvgButton.dart';
import 'package:safe_vault/models/theme/AppColors.dart';

import '../../viewmodels/theme/ThemeController.dart';

class HomePage extends StatefulWidget {
  final PageController pageController;

  const HomePage({
      super.key,
      required this.pageController
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> currentGradient = [];

  @override
  void initState() {
    super.initState();
  }

  List<Color> _getGradientForScore(int score, AppColors colors) {
    if (score < 25) {
      return [ Color(0xFFFF3939).withAlpha(76), Color(0xFFFF3939)];
    } else if (score < 50) {
      return [Color(0xFFFF8239).withAlpha(76), Color(0xFFFF8239)];
    } else if (score < 75) {
      return [Color(0xFFFFD739).withAlpha(76), Color(0xFFFFD739)];
    } else {
      return [Color(0xFF16A34A).withAlpha(76), Color(0xFF16A34A)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    final SharedPreferencesRepository sharedPreferences = context.read<SharedPreferencesRepository>();
    final ThemeController themeController = context.read<ThemeController>();

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
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
                gradient: LinearGradient(colors: [colors.gradientTopStart, colors.gradientTopEnd], begin: AlignmentGeometry.topCenter, end: AlignmentGeometry.bottomCenter),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45), bottomRight: Radius.circular(45)),
              ),

              child: Column(
                children: [
                  // Titles + Top Right Icon
                  Container(
                    padding: EdgeInsets.fromLTRB(totalWidth * 0.02, totalHeight * 0.00, 0, totalHeight * 0.01),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Titles
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Bonjour  👋",
                              style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w400, color: colors.text1),
                            ),
                            Text(
                              "Mon Coffre-Fort",
                              style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w500, color: colors.text1),
                            ),
                          ],
                        ),

                        // Icon
                        SizedBox(
                          height: totalHeight * 0.05,
                          width: totalHeight * 0.05,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashFactory: NoSplash.splashFactory, // Remove splash effect
                            ),

                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.all(0),
                              icon: Icon(
                                Icons.menu_rounded,
                                color: colors.text2,
                              ),

                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(colors.containerBackground1),
                              ),

                              onSelected: (String value) {
                                if (value == 'changeTheme') {
                                  // Toggle theme
                                  themeController.toggleTheme();
                                  sharedPreferences.setTheme(themeController.isDark ? 'dark' : 'light');
                                }
                                else if (value == 'notifications') {
                                  // TODO: Jsp comment on fait ici, faut en discuter
                                }
                              },

                              color: colors.containerBackground2,
                              offset: Offset(0, 0),
                              menuPadding: EdgeInsets.all(0),
                              borderRadius: BorderRadius.circular(10),
                              shadowColor: colors.dropShadow,
                              popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut, duration: Duration(milliseconds: 500)),
                              splashRadius: 0.1,
                              elevation: 150,
                              clipBehavior: Clip.none,

                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'changeTheme',
                                  child: Text(
                                    'Changer de thème',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.text3,
                                    ),
                                  ),

                                ),
                                PopupMenuItem<String>(
                                  value: 'notifications',
                                  child: Text(
                                    'Notifications',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.text3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Score + Infos
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: colors.containerBackground1, borderRadius: BorderRadius.circular(45)),
                      padding: EdgeInsets.symmetric(horizontal: totalWidth * 0.05, vertical: totalHeight * 0.02),

                      child: Consumer<RobustnessProvider>(
                        builder: (BuildContext context, RobustnessProvider robustnessProvider, Widget? child) {

                          // Update the gradient based on the score
                          currentGradient = _getGradientForScore(robustnessProvider.totalScore, colors);

                          print("score: ${robustnessProvider.totalScore}");
                          print("gradient: $currentGradient");

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: totalHeight * 0.02,
                            children: [
                              // Title
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Santé des mots de passe",
                                  style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w500, color: colors.text2),
                                ),
                              ),

                              // Score
                              Expanded(
                                child: Center(
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      customWidths: CustomSliderWidths(progressBarWidth: 10, trackWidth: 8),
                                      infoProperties: InfoProperties(
                                        mainLabelStyle: GoogleFonts.montserrat(fontSize: 30, fontWeight: FontWeight.w500, color: currentGradient.last),

                                        modifier: (double value) {
                                          return '${value.toInt()}';
                                        },
                                      ),

                                      customColors: CustomSliderColors(
                                        dotColor: Colors.transparent,
                                        progressBarColors: currentGradient,
                                        trackColor: Color(0xFFD9D9D9),
                                        gradientStartAngle: -150,
                                        shadowColor: currentGradient.first.withAlpha(125),

                                      ),
                                      size: 140,
                                    ),
                                    min: 0,
                                    max: 100,
                                    initialValue: robustnessProvider.totalScore.toDouble(),
                                  ),
                                ),
                              ),

                              // Infos
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Compromised
                                  Container(
                                    height: totalHeight * 0.095,
                                    width: totalWidth * 0.33,
                                    decoration: BoxDecoration(color: colors.pinkLight, borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${robustnessProvider.compromised}",
                                          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: colors.pinkDarker),
                                        ),
                                        Text(
                                          "Compromis",
                                          style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Weak
                                  Container(
                                    height: totalHeight * 0.095,
                                    width: totalWidth * 0.33,
                                    decoration: BoxDecoration(color: colors.purpleLight, borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${robustnessProvider.weak}",
                                          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: colors.purpleDarker),
                                        ),

                                        Text(
                                          "Faibles",
                                          style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
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
                                    decoration: BoxDecoration(color: colors.orangeLight, borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${robustnessProvider.reused}",
                                          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: colors.orangeDarker),
                                        ),

                                        Text(
                                          "Réutilisés",
                                          style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Safe
                                  Container(
                                    height: totalHeight * 0.095,
                                    width: totalWidth * 0.33,
                                    decoration: BoxDecoration(color: colors.greenLight, borderRadius: BorderRadius.circular(20)),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "${robustnessProvider.strong}",
                                          style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.w500, color: colors.greenDarker),
                                        ),

                                        Text(
                                          "Sûrs",
                                          style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Side
            Container(
              margin: EdgeInsets.symmetric(horizontal: totalWidth * 0.07),
              child: Consumer<DatabaseProvider>(
                builder: (BuildContext context, DatabaseProvider db, Widget? child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: totalHeight * 0.022,
                    children: [
                      Text(
                        "Catégories",
                        style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.w500, color: colors.text2),
                      ),

                      // Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Website
                          CustomCard(svgPath: 'assets/svg/internet.svg', title: 'Sites Web', subtitle: '${db.categoryWebPasswords.length} mots de passe',
                            onPressed: () {

                          },),

                          // Website
                          CustomCard(svgPath: 'assets/svg/social_network.svg', title: 'Réseaux Sociaux', subtitle: '${db.categorySocialPasswords.length} mots de passe', onPressed: () {

                          },),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Apps
                          CustomCard(svgPath: 'assets/svg/smartphone.svg', title: 'Applications', subtitle: '${db.categoryAppPasswords.length} mots de passe', onPressed: () {

                          },),

                          // Website
                          CustomCard(svgPath: 'assets/svg/shopping_cart.svg', title: 'Paiements', subtitle: '${db.categoryPaymentPasswords.length} mots de passe', onPressed: () {

                          },),
                        ],
                      ),

                      // Generate Password Button
                      CustomSvgButton(title: 'Générateur de mots de passe', svgPath: 'assets/svg/stars.svg', onPressed: () {
                        widget.pageController.jumpToPage(3);
                      }),

                      // Secured Notes Button
                      CustomSvgButton(title: 'Notes sécurisées', svgPath: 'assets/svg/notes.svg', onPressed: () {
                        widget.pageController.jumpToPage(4);
                      }),
                    ],
                  );
                },
              ),
            ),

            // Spacing
            SizedBox(height: totalHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
