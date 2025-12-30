import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/models/PasswordGenerator.dart';
import 'package:safe_vault/views/widgets/CustomLittleCard.dart';
import 'package:safe_vault/views/widgets/CustomSvgButton.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';
import '../../models/database/Password.dart';
import '../../models/theme/AppColors.dart';
import '../../viewmodels/DatabaseProvider.dart';
import '../widgets/CustomButton.dart';
import '../widgets/CustomStrengthWidget.dart';

class NewPasswordPage extends StatefulWidget {
  final PageController? pageController;
  final Password? initialPassword;

  const NewPasswordPage({
    super.key,
    this.pageController,
    this.initialPassword,
  });

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);

  // Creation of a list of 4 TextEditingController for the 4 TextFields
  List<TextEditingController> controllers = List.generate(4, (index) => TextEditingController());


  @override
  void initState() {
    super.initState();
    // If an initialPassword is provided, pre-fill the TextFields
    if (widget.initialPassword != null) {
      controllers[0].text = widget.initialPassword!.service;
      controllers[1].text = widget.initialPassword!.username;
      controllers[2].text = widget.initialPassword!.website;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        controllers[3].text = widget.initialPassword!.password;
      });

      selectedIndex.value = widget.initialPassword!.id_category - 1;
    }
  }


  @override
  void dispose() {
    // Dispose all controllers when the widget is disposed
    for (var controller in controllers) {
      controller.dispose();
    }
    selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;
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
              //height: totalHeight * 0.1,
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
                    "Nouveau mot de passe",
                    style: GoogleFonts.montserrat(
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
                  // Categories
                  Container(
                    width: double.infinity,
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
                    padding: EdgeInsets.all(totalWidth * 0.04),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: totalHeight * 0.015,
                      children: [
                        // Categories Title
                        Padding(
                          padding: EdgeInsets.only(left: totalWidth * 0.01),
                          child: Text(
                            "Catégories",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                            ),
                          ),
                        ),

                        // Categories Cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Website
                            CustomLittleCard(
                              svgPath: 'assets/svg/internet.svg',
                              title: 'Sites Web',
                              index: 0,
                              selectedIndexNotifier: selectedIndex,
                            ),

                            // Social Network
                            CustomLittleCard(
                              svgPath: 'assets/svg/social_network.svg',
                              title: 'Réseaux Sociaux',
                              index: 1,
                              selectedIndexNotifier: selectedIndex,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Apps
                            CustomLittleCard(
                              svgPath: 'assets/svg/smartphone.svg',
                              title: 'Applications',
                              index: 2,
                              selectedIndexNotifier: selectedIndex,
                            ),

                            // Shopping
                            CustomLittleCard(
                              svgPath: 'assets/svg/shopping_cart.svg',
                              title: 'Paiements',
                              index: 3,
                              selectedIndexNotifier: selectedIndex,
                            ),
                          ],
                        ),

                      ],
                    ),

                  ),

                  // Inputs
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
                        // Name Title
                        Padding(
                          padding: EdgeInsets.only(left: totalWidth * 0.01),
                          child: Text(
                            "Nom du service",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                            ),
                          ),
                        ),
                        // Name Input
                        CustomTextField(
                          hintText: 'ex: Facebook',
                          controller: controllers[0],
                        ),


                        // Id Title
                        Padding(
                          padding: EdgeInsets.only(left: totalWidth * 0.01),
                          child: Text(
                            "Identifiant / Email",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                            ),
                          ),
                        ),
                        // Id Input
                        CustomTextField(
                          hintText: 'ex: test@gmail.com',
                          controller: controllers[1],
                        ),


                        // Web Title
                        Padding(
                          padding: EdgeInsets.only(left: totalWidth * 0.01),
                          child: Text(
                            "Site web (optionnel)",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                            ),
                          ),
                        ),
                        // Web Input
                        CustomTextField(
                          hintText: 'ex: www.facebook.com',
                          controller: controllers[2],
                        ),

                      ],
                    ),

                  ),

                  // Password
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
                            "Mot de passe",
                            style: GoogleFonts.montserrat(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: colors.text2,
                            ),
                          ),
                        ),
                        // Name Input
                        CustomTextField(
                          hintText: 'ex: w!qn&fXI)4+FVL8jFZ',
                          eye: true,
                          delete: true,
                          controller: controllers[3],
                        ),

                        // TODO : Update case : must check the strength of the initial password
                        // Strength Widget
                        CustomStrengthWidget(controller: controllers[3]),

                        // Generate Password Button
                        CustomSvgButton(
                            title: 'Générer un mot de passe',
                            svgPath: 'assets/svg/stars.svg',
                            onPressed: (){
                              controllers[3].text = PasswordGenerator.generateRandomPassword(20, true, true, true, true);
                              setState(() {});
                            }
                        ),
                      ],
                    ),

                  ),

                  // Save Button
                  CustomButton(
                      title: "Enregistrer",
                      onPressed: () {

                        if(widget.initialPassword == null) {
                          // Insert the new password into the database
                          dbProvider.insertPassword(Password(
                            password: controllers[3].text,
                            username: controllers[1].text,
                            service: controllers[0].text,
                            id_category: selectedIndex.value + 1,
                            website: controllers[2].text,
                            is_favorite: false,
                          ));
                        }
                        else {
                          // Update the existing password in the database
                          dbProvider.updatePassword(Password(
                            id_pwd: widget.initialPassword!.id_pwd,
                            password: controllers[3].text,
                            username: controllers[1].text,
                            service: controllers[0].text,
                            id_category: selectedIndex.value + 1,
                            website: controllers[2].text,
                            is_favorite: widget.initialPassword!.is_favorite,
                          ));
                        }


                        // Clear all TextFields
                        for (var controller in controllers) {
                          controller.clear();
                        }

                        // Return to the home page
                        if(widget.pageController != null) {
                          widget.pageController!.jumpToPage(0);
                        }
                        else {
                          Navigator.pop(context);
                        }


                      },
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
