import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/theme/AppColors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(decelerationRate: ScrollDecelerationRate.normal),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                            Placeholder(
                              fallbackHeight: totalHeight * 0.13,
                              color: Colors.red,
                              strokeWidth: 1,
                            ),

                            // Infos
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
          
              // Middle Buttons
              Container(color: Colors.black, height: 500, width: totalWidth,),
              Container(color: Colors.red, height: 500, width: totalWidth,),
              Container(color: Colors.orange, height: 500, width: totalWidth,),
          
          
            ],
          ),
        ),
      ),
    );
  }
}