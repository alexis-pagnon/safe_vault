import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:safe_vault/viewmodels/PageNavigatorProvider.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
import 'package:safe_vault/views/widgets/CustomCard.dart';
import 'package:safe_vault/views/widgets/CustomSvgButton.dart';
import 'package:safe_vault/models/theme/AppColors.dart';
import '../widgets/CustomThemeSwitcher.dart';

class HomePage extends StatefulWidget {

  const HomePage({
      super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Color> currentGradient = [];
  double globalOpacity = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        globalOpacity = 1;
      });
    });
  }

  /// Get the gradient for the score.<br>
  /// @param score The score.<br>
  List<Color> _getGradientForScore(int score) {
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

    final pageNavigator = Provider.of<PageNavigatorProvider>(context, listen: false);
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

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
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: colors.text1),
                            ),
                            Text(
                              "Mon Coffre-Fort",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: colors.text1),
                            ),
                          ],
                        ),

                        // Icon
                        CustomThemeSwitcher(),
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
                          currentGradient = _getGradientForScore(robustnessProvider.totalScore);

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
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colors.text2),
                                ),
                              ),

                              // Score
                              Expanded(
                                child: Center(
                                  child: SleekCircularSlider(
                                    appearance: CircularSliderAppearance(
                                      customWidths: CustomSliderWidths(progressBarWidth: 10, trackWidth: 8),
                                      infoProperties: InfoProperties(
                                        mainLabelStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.w500, color: currentGradient.last),

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
                                  AnimatedOpacity(
                                    opacity: globalOpacity,
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 300),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        // Navigate to compromised passwords page
                                        pageNavigator.updateFilterPassword(9);
                                        dbProvider.setCategory(6);
                                        dbProvider.setIdsToFilter(robustnessProvider.compromisedPasswords);
                                        pageNavigator.jumpToPage(1);
                                      },
                                      child: Container(
                                        height: totalHeight * 0.095,
                                        width: totalWidth * 0.33,
                                        decoration: BoxDecoration(color: colors.pinkLight, borderRadius: BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${robustnessProvider.compromised}",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: colors.pinkDarker),
                                            ),
                                            Text(
                                              "Compromis",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Weak
                                  AnimatedOpacity(
                                    opacity: globalOpacity,
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 400),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        pageNavigator.updateFilterPassword(7);
                                        dbProvider.setCategory(6);
                                        dbProvider.setIdsToFilter(robustnessProvider.weakPasswords);
                                        pageNavigator.jumpToPage(1);
                                      },
                                      child: Container(
                                        height: totalHeight * 0.095,
                                        width: totalWidth * 0.33,
                                        decoration: BoxDecoration(color: colors.purpleLight, borderRadius: BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${robustnessProvider.weak}",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: colors.purpleDarker),
                                            ),

                                            Text(
                                              "Faibles",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  // Reused
                                  AnimatedOpacity(
                                    opacity: globalOpacity,
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 500),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        pageNavigator.updateFilterPassword(8);
                                        dbProvider.setCategory(6);
                                        dbProvider.setIdsToFilter(robustnessProvider.allReusedPasswords);
                                        pageNavigator.jumpToPage(1);
                                      },
                                      child: Container(
                                        height: totalHeight * 0.095,
                                        width: totalWidth * 0.33,
                                        decoration: BoxDecoration(color: colors.orangeLight, borderRadius: BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${robustnessProvider.reused}",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: colors.orangeDarker),
                                            ),

                                            Text(
                                              "Réutilisés",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Safe
                                  AnimatedOpacity(
                                    opacity: globalOpacity,
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 600),
                                    child: GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        pageNavigator.updateFilterPassword(6);
                                        dbProvider.setCategory(6);
                                        dbProvider.setIdsToFilter(robustnessProvider.strongPasswords);
                                        pageNavigator.jumpToPage(1);
                                      },
                                      child: Container(
                                        height: totalHeight * 0.095,
                                        width: totalWidth * 0.33,
                                        decoration: BoxDecoration(color: colors.greenLight, borderRadius: BorderRadius.circular(20)),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "${robustnessProvider.strong}",
                                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: colors.greenDarker),
                                            ),

                                            Text(
                                              "Sûrs",
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: colors.text5),
                                            ),
                                          ],
                                        ),
                                      ),
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
                      // Title
                      Text(
                        "Catégories",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: colors.text2),
                      ),

                      // Categories
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Website
                          AnimatedOpacity(
                            opacity: globalOpacity,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 800),
                            child: CustomCard(svgPath: 'assets/svg/internet.svg', title: 'Sites Web', subtitle: '${db.categoryWebPasswords.length} mots de passe',
                              onPressed: () {
                                pageNavigator.updateFilterPassword(2);
                                dbProvider.setCategory(2);
                                pageNavigator.jumpToPage(1);
                            },),
                          ),

                          // Social Network
                          AnimatedOpacity(
                            opacity: globalOpacity,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 900),
                            child: CustomCard(svgPath: 'assets/svg/social_network.svg', title: 'Réseaux Sociaux', subtitle: '${db.categorySocialPasswords.length} mots de passe', onPressed: () {
                              pageNavigator.updateFilterPassword(3);
                              dbProvider.setCategory(3);
                              pageNavigator.jumpToPage(1);
                            },),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Apps
                          AnimatedOpacity(
                            opacity: globalOpacity,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 1000),
                            child: CustomCard(svgPath: 'assets/svg/smartphone.svg', title: 'Applications', subtitle: '${db.categoryAppPasswords.length} mots de passe', onPressed: () {
                              pageNavigator.updateFilterPassword(4);
                              dbProvider.setCategory(4);
                              pageNavigator.jumpToPage(1);
                            },),
                          ),

                          // Payments
                          AnimatedOpacity(
                            opacity: globalOpacity,
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 1100),
                            child: CustomCard(svgPath: 'assets/svg/shopping_cart.svg', title: 'Paiements', subtitle: '${db.categoryPaymentPasswords.length} mots de passe', onPressed: () {
                              pageNavigator.updateFilterPassword(5);
                              dbProvider.setCategory(5);
                              pageNavigator.jumpToPage(1);
                            },),
                          ),
                        ],
                      ),

                      // Generate Password Button
                      AnimatedOpacity(
                        opacity: globalOpacity,
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 1200),
                        child: CustomSvgButton(title: 'Générateur de mots de passe', svgPath: 'assets/svg/stars.svg', onPressed: () {
                          pageNavigator.jumpToPage(3);
                        }),
                      ),

                      // Secured Notes Button
                      AnimatedOpacity(
                        opacity: globalOpacity,
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 1200),
                        child: CustomSvgButton(title: 'Notes sécurisées', svgPath: 'assets/svg/notes.svg', onPressed: () {
                          pageNavigator.jumpToPage(4);
                        }),
                      ),
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
