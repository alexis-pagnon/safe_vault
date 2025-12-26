import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/views/widgets/CustomCategoryButton.dart';
import 'package:safe_vault/views/widgets/CustomPasswordCard.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';

import '../../models/theme/AppColors.dart';
import '../../viewmodels/DatabaseProvider.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final TextEditingController controller = TextEditingController();
  final ValueNotifier<int> selectedCategoryNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // TODO: Alexis: Faire la logique de recherche ici pour n'afficher que ce qui contient ce qui a été tappe (je pense qu'on peut tout mettre en minuscule et juste check si c'est bien dedans)

      print("Texte actuel : ${controller.text}");
    });
  }

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
      body: SingleChildScrollView(
        physics: PageScrollPhysics(),
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

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: totalHeight * 0.02,
                children: [
                  // Title
                  Text(
                    "Mes mots de passe",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.text1,
                    ),
                  ),

                  // TextField
                  CustomTextField(
                    hintText: "Rechercher...",
                    controller: controller,
                    search: true,
                  ),
                ],
              ),

            ),

            // Bottom Side
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: totalHeight * 0.022,
              children: [
                // Categories
                ValueListenableBuilder<int>(
                  valueListenable: selectedCategoryNotifier,
                  builder: (context, selectedIndex, child) {

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: totalWidth * 0.04,
                        children: [
                          // Spacing
                          SizedBox(width: totalWidth * 0.03),

                          // Category Buttons
                          // TODO: Alexis: Faire la logique dans chacune des fonctions pour que ça n'affiche que les bons mdps
                          CustomCategoryButton(
                            index: 0,
                            selectedIndexNotifier: selectedCategoryNotifier,
                            text: "Tous",
                            onPressed: () {
                              selectedCategoryNotifier.value = 0;
                              print("Tous");
                            },
                          ),
                          CustomCategoryButton(
                            index: 1,
                            selectedIndexNotifier: selectedCategoryNotifier,
                            text: "Favoris",
                            onPressed: () {
                              selectedCategoryNotifier.value = 1;
                              print("Favoris");
                            },
                          ),
                          CustomCategoryButton(
                            index: 2,
                            selectedIndexNotifier: selectedCategoryNotifier,
                            text: "Site Web",
                            onPressed: () {
                              selectedCategoryNotifier.value = 2;
                              print("Site Web");
                            },
                          ),
                          CustomCategoryButton(
                            index: 3,
                            selectedIndexNotifier: selectedCategoryNotifier,
                            text: "Réseaux Sociaux",
                            onPressed: () {
                              selectedCategoryNotifier.value = 3;
                              print("Réseaux Sociaux");
                            },
                          ),
                          CustomCategoryButton(
                            index: 4,
                            selectedIndexNotifier: selectedCategoryNotifier,
                            text: "Applications",
                            onPressed: () {
                              selectedCategoryNotifier.value = 4;
                              print("Applications");
                            },
                          ),
                          CustomCategoryButton(
                            index: 5,
                            selectedIndexNotifier: selectedCategoryNotifier,
                            text: "Paiements",
                            onPressed: () {
                              selectedCategoryNotifier.value = 5;
                              print("Paiements");
                            },
                          ),

                          // Spacing
                          SizedBox(width: totalWidth * 0.03),
                        ],

                      ),
                    );
                  }
                ),

                // Password Cards
                Consumer<DatabaseProvider>(
                  builder: (context, dbProvider, _) {
                    final passwords = dbProvider.passwords;

                    if (passwords.isEmpty) {
                      return Text("No passwords saved");
                    }
                    return Column(
                      spacing: totalHeight * 0.025,
                      children: passwords.map((pwd) => CustomPasswordCard(
                        password: pwd,
                      )).toList(),
                    );
                  },
                ),


              ],
            ),

            // Spacing
            SizedBox(height: totalHeight * 0.05),
          ],
        ),
      ),
    );
  }
}
