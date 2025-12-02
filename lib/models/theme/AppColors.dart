import 'package:flutter/material.dart';

class AppColors extends ThemeExtension<AppColors> {
  // Colors
  final Color text1;
  final Color text2;
  final Color text3;
  final Color text4;
  final Color text5;
  final Color hintText;
  final Color background;
  final Color containerBackground1;
  final Color containerBackground2;
  final Color dropShadow;
  final Color pinkLight;
  final Color orangeLight;
  final Color greenLight;
  final Color purpleLight;
  final Color pinkDarker;
  final Color orangeDarker;
  final Color greenDarker;
  final Color purpleDarker;
  final Color navbarIconsBackground;
  final Color navbarIconsColor;

  // Colors for gradient
  final Color gradientButtonsStart;
  final Color gradientButtonsEnd;
  final Color gradientButtonsUnavailableStart;
  final Color gradientButtonsUnavailableEnd;
  final Color gradientTopStart;
  final Color gradientTopEnd;


  const AppColors({
    required this.text1,
    required this.text2,
    required this.text3,
    required this.text4,
    required this.text5,
    required this.hintText,
    required this.background,
    required this.containerBackground1,
    required this.containerBackground2,
    required this.dropShadow,
    required this.pinkLight,
    required this.orangeLight,
    required this.greenLight,
    required this.purpleLight,
    required this.pinkDarker,
    required this.orangeDarker,
    required this.greenDarker,
    required this.purpleDarker,
    required this.navbarIconsBackground,
    required this.navbarIconsColor,
    required this.gradientButtonsStart,
    required this.gradientButtonsEnd,
    required this.gradientButtonsUnavailableStart,
    required this.gradientButtonsUnavailableEnd,
    required this.gradientTopStart,
    required this.gradientTopEnd,
  });

  @override
  AppColors copyWith({
    Color? text1,
    Color? text2,
    Color? text3,
    Color? text4,
    Color? text5,
    Color? hintText,
    Color? background,
    Color? containerBackground1,
    Color? containerBackground2,
    Color? dropShadow,
    Color? pinkLight,
    Color? orangeLight,
    Color? greenLight,
    Color? purpleLight,
    Color? pinkDarker,
    Color? orangeDarker,
    Color? greenDarker,
    Color? purpleDarker,
    Color? navbarIconsBackground,
    Color? navbarIconsColor,
    Color? gradientButtonsStart,
    Color? gradientButtonsEnd,
    Color? gradientButtonsUnavailableStart,
    Color? gradientButtonsUnavailableEnd,
    Color? gradientTopStart,
    Color? gradientTopEnd,
  }) {
    return AppColors(
      text1: text1 ?? this.text1,
      text2: text2 ?? this.text2,
      text3: text3 ?? this.text3,
      text4: text4 ?? this.text4,
      text5: text5 ?? this.text5,
      hintText: hintText ?? this.hintText,
      background: background ?? this.background,
      containerBackground1: containerBackground1 ?? this.containerBackground1,
      containerBackground2: containerBackground2 ?? this.containerBackground2,
      dropShadow: dropShadow ?? this.dropShadow,
      pinkLight: pinkLight ?? this.pinkLight,
      orangeLight: orangeLight ?? this.orangeLight,
      greenLight: greenLight ?? this.greenLight,
      purpleLight: purpleLight ?? this.purpleLight,
      pinkDarker: pinkDarker ?? this.pinkDarker,
      orangeDarker: orangeDarker ?? this.orangeDarker,
      greenDarker: greenDarker ?? this.greenDarker,
      purpleDarker: purpleDarker ?? this.purpleDarker,
      navbarIconsBackground:
      navbarIconsBackground ?? this.navbarIconsBackground,
      navbarIconsColor: navbarIconsColor ?? this.navbarIconsColor,
      gradientButtonsStart : gradientButtonsStart ?? this.gradientButtonsStart,
      gradientButtonsEnd : gradientButtonsEnd ?? this.gradientButtonsEnd,
      gradientButtonsUnavailableStart : gradientButtonsUnavailableStart ?? this.gradientButtonsUnavailableStart,
      gradientButtonsUnavailableEnd : gradientButtonsUnavailableEnd ?? this.gradientButtonsUnavailableEnd,
      gradientTopStart : gradientTopStart ?? this.gradientTopStart,
      gradientTopEnd : gradientTopEnd ?? this.gradientTopEnd,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;

    return AppColors(
      text1: Color.lerp(text1, other.text1, t)!,
      text2: Color.lerp(text2, other.text2, t)!,
      text3: Color.lerp(text3, other.text3, t)!,
      text4: Color.lerp(text4, other.text4, t)!,
      text5: Color.lerp(text5, other.text5, t)!,
      hintText: Color.lerp(hintText, other.hintText, t)!,
      background: Color.lerp(background, other.background, t)!,
      containerBackground1:
      Color.lerp(containerBackground1, other.containerBackground1, t)!,
      containerBackground2:
      Color.lerp(containerBackground2, other.containerBackground2, t)!,
      dropShadow: Color.lerp(dropShadow, other.dropShadow, t)!,
      pinkLight: Color.lerp(pinkLight, other.pinkLight, t)!,
      orangeLight: Color.lerp(orangeLight, other.orangeLight, t)!,
      greenLight: Color.lerp(greenLight, other.greenLight, t)!,
      purpleLight: Color.lerp(purpleLight, other.purpleLight, t)!,
      pinkDarker: Color.lerp(pinkDarker, other.pinkDarker, t)!,
      orangeDarker: Color.lerp(orangeDarker, other.orangeDarker, t)!,
      greenDarker: Color.lerp(greenDarker, other.greenDarker, t)!,
      purpleDarker: Color.lerp(purpleDarker, other.purpleDarker, t)!,
      gradientButtonsStart: Color.lerp(gradientButtonsStart, other.gradientButtonsStart, t)!,
      gradientButtonsEnd: Color.lerp(gradientButtonsEnd, other.gradientButtonsEnd, t)!,
      gradientButtonsUnavailableStart: Color.lerp(gradientButtonsUnavailableStart, other.gradientButtonsUnavailableStart, t)!,
      gradientButtonsUnavailableEnd: Color.lerp(gradientButtonsUnavailableEnd, other.gradientButtonsUnavailableEnd, t)!,
      gradientTopStart: Color.lerp(gradientTopStart, other.gradientTopStart, t)!,
      gradientTopEnd: Color.lerp(gradientTopEnd, other.gradientTopEnd, t)!,
      navbarIconsBackground: Color.lerp(
          navbarIconsBackground, other.navbarIconsBackground, t)!,
      navbarIconsColor:
      Color.lerp(navbarIconsColor, other.navbarIconsColor, t)!,
    );
  }
}
