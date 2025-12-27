import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';
import '../../models/theme/AppColors.dart';
import '../widgets/CustomButton.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


// TODO: Adam: Faire des animations de FadeIn pour le texte en mode Pro


class CreationPage extends StatefulWidget {

  const CreationPage({
    super.key,
  });

  @override
  State<CreationPage> createState() => _CreationPageState();
}

class _CreationPageState extends State<CreationPage> {
  TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: colors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: totalWidth * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: totalHeight * 0.022,
          children: <Widget>[
            // Logo
            Container(
              height: totalWidth * 0.2,
              width: totalWidth * 0.2,
              padding: EdgeInsets.all(totalWidth * 0.04),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [colors.gradientButtonsStart, colors.gradientButtonsEnd],
                  begin: AlignmentGeometry.centerLeft,
                  end: AlignmentGeometry.centerRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(totalWidth * 0.05)),
              ),
              child: Icon(
                Icons.lock_outline_rounded,
                color: colors.text1,
              )
            ),

            // Title
            Text(
              "Bienvenue",
              style: GoogleFonts.montserrat(
                color: colors.text2,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            // Subtitle
            Text(
              "Entrez votre mot de passe maître",
              style: GoogleFonts.montserrat(
                color: colors.text2,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),

            // TextField
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

              child: CustomTextField(
                controller: controller,
                hintText: "Mot de passe maître",
                eye: true,
              ),
            ),


            // Button
            CustomButton(
              title: "Déverrouiller",
              onPressed: () {
                // TODO: Alexis: Vérifier le mot de passe maître
                final isPasswordCorrect = false;

                if (isPasswordCorrect) {
                  // Go to the Home Page
                  // widget.pageController.jumpToPage(0);
                }
                else {
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,

                    content: AwesomeSnackbarContent(
                      title: 'Erreur',
                      message: 'Mot de passe maître incorrect. Veuillez réessayer.',
                      contentType: ContentType.failure,
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar, snackBarAnimationStyle: AnimationStyle(curve: Curves.easeIn, duration: Duration(milliseconds: 100)));
                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
