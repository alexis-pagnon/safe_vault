import 'package:flutter/material.dart';
import 'package:safe_vault/models/PasswordGenerator.dart';
import 'package:safe_vault/views/widgets/CustomSvgButton.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';
import 'package:safe_vault/views/widgets/CustomToggleSwitch.dart';
import '../../models/theme/AppColors.dart';
import '../widgets/CustomStrengthWidget.dart';

class GenerationPage extends StatefulWidget {

  const GenerationPage({
    super.key,
  });

  @override
  State<GenerationPage> createState() => _GenerationPageState();
}

class _GenerationPageState extends State<GenerationPage> {
  // Creation of a list of 2 TextEditingController for the 2 TextFields
  List<TextEditingController> controllers = List.generate(2, (index) => TextEditingController());
  int passwordLength = 20;

  // Settings for the generator
  bool lowerCase = true;
  bool upperCase = true;
  bool numbers = true;
  bool charactSpecial = true;

  @override
  void dispose() {
    // Dispose all controllers when the widget is disposed
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    final bool isAtLeastOneTypeSelected =
        lowerCase || upperCase || numbers || charactSpecial;

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
              width: double.infinity,
              padding: EdgeInsets.all(totalWidth * 0.08),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.gradientTopStart, colors.gradientTopEnd],
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45), bottomRight: Radius.circular(45)),
              ),

              child: Center(
                  child: Text(
                    "Générateur & Vérificateur",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.text1,
                    ),
                  )
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
                  // Password Generation
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(totalWidth * 0.04),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: totalHeight * 0.015,
                      children: [
                        // Title
                        Padding(
                          padding: EdgeInsets.only(left: totalWidth * 0.01),
                          child: Text(
                            "Générateur de mot de passe",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),

                        // Input
                        CustomTextField(
                          hintText: 'Mot de passe généré',
                          controller: controllers[0],
                          copy: true,
                          eye: true,
                          editable: false,
                        ),

                        // Slider
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            showValueIndicator: ShowValueIndicator.onDrag,
                            activeTrackColor: colors.gradientButtonsStart,
                            valueIndicatorColor: colors.gradientButtonsStart,
                            inactiveTrackColor: colors.gradientButtonsUnavailableStart,
                            overlayColor: Colors.transparent,
                            thumbColor: colors.gradientButtonsStart,
                            valueIndicatorTextStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: colors.text1,
                            ),
                          ),
                          child: Slider(
                            min: 12,
                            max: 40,
                            value: passwordLength.toDouble(),
                            label: passwordLength.toString(),
                            onChanged: (value) {
                              setState(() => passwordLength = value.round());
                            },
                          ),
                        ),

                        // Settings for generator
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Minuscules
                            Text(
                              'Minuscules',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.text3,
                                fontFamily: 'Montserrat',
                              ),
                            ),

                            // Toggle Switch
                            CustomToggleSwitch(
                              initialValue: 1,
                              thumbColor: [Color(0xFFCC3C3C), Color(0xFF5C9828)],
                              circleColor:[Color(0xFFFF4B4B), Color(0xFF77C433)],
                              svgColor: [Colors.white, Colors.white],
                              icons: [Icons.close_rounded, Icons.check_rounded],
                              onToggle: () {
                                setState(() {
                                  lowerCase = !lowerCase;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Minuscules
                            Text(
                              'Majuscules',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.text3,
                                fontFamily: 'Montserrat',
                              ),
                            ),

                            // Toggle Switch
                            CustomToggleSwitch(
                              initialValue: 1,
                              thumbColor: [Color(0xFFCC3C3C), Color(0xFF5C9828)],
                              circleColor:[Color(0xFFFF4B4B), Color(0xFF77C433)],
                              svgColor: [Colors.white, Colors.white],
                              icons: [Icons.close_rounded, Icons.check_rounded],
                              onToggle: () {
                                setState(() {
                                  upperCase = !upperCase;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Minuscules
                            Text(
                              'Chiffres',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.text3,
                                fontFamily: 'Montserrat',
                              ),
                            ),

                            // Toggle Switch
                            CustomToggleSwitch(
                              initialValue: 1,
                              thumbColor: [Color(0xFFCC3C3C), Color(0xFF5C9828)],
                              circleColor:[Color(0xFFFF4B4B), Color(0xFF77C433)],
                              svgColor: [Colors.white, Colors.white],
                              icons: [Icons.close_rounded, Icons.check_rounded],
                              onToggle: () {
                                setState(() {
                                  numbers = !numbers;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Minuscules
                            Text(
                              'Caractères spéciaux',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: colors.text3,
                                fontFamily: 'Montserrat',
                              ),
                            ),

                            // Toggle Switch
                            CustomToggleSwitch(
                              initialValue: 1,
                              thumbColor: [Color(0xFFCC3C3C), Color(0xFF5C9828)],
                              circleColor:[Color(0xFFFF4B4B), Color(0xFF77C433)],
                              svgColor: [Colors.white, Colors.white],
                              icons: [Icons.close_rounded, Icons.check_rounded],
                              onToggle: () {
                                setState(() {
                                  charactSpecial = !charactSpecial;
                                });
                              },
                            ),
                          ],
                        ),

                        // Generate Password Button
                        CustomSvgButton(
                            title: 'Générer un mot de passe',
                            svgPath: 'assets/svg/stars.svg',
                            isAvailable: isAtLeastOneTypeSelected,
                            onPressed: () {
                              controllers[0].text = PasswordGenerator.generateRandomPassword(passwordLength, lowerCase, upperCase, numbers, charactSpecial);
                            },
                        ),
                      ],
                    ),

                  ),

                  // Password Verification
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(totalWidth * 0.04),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: totalHeight * 0.015,
                      children: [
                        // Password Title
                        Padding(
                          padding: EdgeInsets.only(left: totalWidth * 0.01),
                          child: Text(
                            "Vérificateur de mot de passe",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                            ),
                          ),
                        ),

                        // Name Input
                        CustomTextField(
                          hintText: 'Votre mot de passe',
                          eye: true,
                          delete: true,
                          controller: controllers[1],
                        ),

                        // Strength Widget
                        CustomStrengthWidget(
                          controller: controllers[1],
                        ),

                      ],
                    ),
                  ),
                ],
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
