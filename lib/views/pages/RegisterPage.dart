import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/models/PasswordGenerator.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
import 'package:safe_vault/views/widgets/CustomStrengthWidget.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';
import '../../models/theme/AppColors.dart';
import '../widgets/CustomButton.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';


// TODO: Adam: Faire des animations de FadeIn pour le texte en mode Pro


class RegisterPage extends StatefulWidget {
  //final PageController pageController;

  const RegisterPage({
    super.key,
    //required this.pageController,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with WidgetsBindingObserver {
  // Creation of a list of 2 TextEditingController for the 2 TextFields
  List<TextEditingController> controllers = List.generate(2, (index) => TextEditingController());

  bool _hasKeyboard = false;

  bool _computeHasKeyboard() {
    // Source la plus fiable: insets du moteur (ne dépend pas du BuildContext)
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    return view.viewInsets.bottom > 0;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Valeur initiale après le premier layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final hasKeyboard = _computeHasKeyboard();
      if (_hasKeyboard != hasKeyboard) {
        setState(() => _hasKeyboard = hasKeyboard);
      }
    });
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final hasKeyboard = _computeHasKeyboard();
      if (_hasKeyboard != hasKeyboard) {
        setState(() => _hasKeyboard = hasKeyboard);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

    final authenticationProvider = Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: colors.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: totalWidth * 0.04),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: totalHeight * 0.035,
                    children: <Widget>[
                      // First Part
                      if(!_hasKeyboard)
                        Column(
                          spacing: totalHeight * 0.015,
                          children: [
                            // Logo
                            Container(
                              height: totalWidth * 0.2,
                              width: totalWidth * 0.2,
                              padding: EdgeInsets.all(totalWidth * 0.05),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [colors.gradientButtonsStart, colors.gradientButtonsEnd],
                                  begin: AlignmentGeometry.centerLeft,
                                  end: AlignmentGeometry.centerRight,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(totalWidth * 0.06)),
                              ),
                              child: SvgPicture.asset(
                                'assets/svg/lock.svg',
                                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                              ),
                            ),

                            // Title
                            Text(
                              "Créer un mot de passe maître",
                              style: TextStyle(
                                color: colors.text2,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            // Subtitle
                            Text(
                              "Ce mot de passe protégera toutes\nvos données",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: colors.text2,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                      // TextFields + Strength Widget
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
                          spacing: totalHeight * 0.02,
                          children: [
                            // First One
                            CustomTextField(
                              controller: controllers[0],
                              hintText: "Mot de passe maître",
                              eye: true,
                              delete: true,
                            ),

                            // Second One
                            CustomTextField(
                              controller: controllers[1],
                              hintText: "Confirmer le mot de passe",
                              eye: true,
                              delete: true,
                            ),

                            // Strength Widget
                            CustomStrengthWidget(
                              controller: controllers[0],
                              obligation: true,
                            ),
                          ],
                        ),
                      ),

                      // Button
                      CustomButton(
                        title: "Créer mon coffre-fort",
                        onPressed: () async {

                          final isPasswordsSimilar = controllers[0].text == controllers[1].text;
                          bool isPasswordRespectRequirements = false;

                          if(isPasswordsSimilar) {
                            final Map<String,dynamic> analysis = PasswordGenerator.completePasswordStrengthAnalysis(controllers[0].text);
                            isPasswordRespectRequirements = analysis['length'] && analysis['uppercase'] && analysis['numbers'] && analysis['specialChars'];
                          }

                          if (isPasswordsSimilar && isPasswordRespectRequirements) {
                            await authenticationProvider.registerNewUser(controllers[0].text);
                          }
                          else {
                            final SnackBar snackBar;
                            if(!isPasswordsSimilar){
                              snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,

                                content: AwesomeSnackbarContent(
                                  title: 'Erreur',
                                  message: 'Vos mots de passe ne correspondent pas.',
                                  contentType: ContentType.failure,
                                ),
                              );
                            }
                            else{
                              snackBar = SnackBar(
                                elevation: 0,
                                behavior: SnackBarBehavior.floating,
                                backgroundColor: Colors.transparent,

                                content: AwesomeSnackbarContent(
                                  title: 'Erreur',
                                  message: 'Votre mot de passe ne respecte pas les critères de sécurité.',
                                  contentType: ContentType.failure,
                                ),
                              );
                            }

                            ScaffoldMessenger.of(context).showSnackBar(snackBar, snackBarAnimationStyle: AnimationStyle(curve: Curves.easeIn, duration: Duration(milliseconds: 100)));
                          }
                        },
                      ),

                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
