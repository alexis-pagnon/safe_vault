import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/PageNavigatorProvider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
import 'package:safe_vault/views/widgets/CustomCategoryButton.dart';
import 'package:safe_vault/views/widgets/CustomPasswordCard.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';
import 'package:safe_vault/models/theme/AppColors.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';

class PasswordsPage extends StatefulWidget {

  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _scrollKey = GlobalKey();
  final List<GlobalKey> _cardKeys = List.generate(10, (_) => GlobalKey());


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  /// Get the offset of the card at [index] relative to the scroll view.<br>
  /// @param index The index of the card.<br>
  /// @return The offset of the card.
  double _getCardOffset(int index) {
    // Get the RenderBox of the selected card and the scroll view.
    final RenderBox cardBox = _cardKeys[index].currentContext!.findRenderObject() as RenderBox;
    final RenderBox scrollBox = _scrollKey.currentContext!.findRenderObject() as RenderBox;

    // Calculate the position of the card relative to the scroll view.
    final cardPosition = cardBox.localToGlobal(Offset.zero, ancestor: scrollBox);

    return _scrollController.offset + cardPosition.dx;
  }


  /// Scroll the scroll view to center the card at [index].<br>
  /// @param index The index of the card to center.
  void _scrollToSelected(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      // Get the RenderBox of the scroll view.
      final RenderBox scrollBox = _scrollKey.currentContext!.findRenderObject() as RenderBox;
      // Get the width of the scroll view.
      final double viewportWidth = scrollBox.size.width;
      // Get the offset of the selected card.
      final double targetOffset = _getCardOffset(index);
      // Calculate the desired offset to center the card :
      // desiredOffset = targetOffset - (half of scroll box displayed) + (half of card width to center)
      final double desiredOffset = targetOffset - (viewportWidth / 2) + (_cardKeys[index].currentContext!.size!.width / 2);

      // The desired offset need to stay between the min and the max of the scroll.
      final double minOffset = _scrollController.position.minScrollExtent;
      final double maxOffset = _scrollController.position.maxScrollExtent;
      final double clampedOffset = desiredOffset.clamp(minOffset, maxOffset);

      _scrollController.animateTo(
        clampedOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
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
                    delete: true,
                    onChanged: (value) {
                      dbProvider.setQuery(value);
                    },
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
                Consumer<PageNavigatorProvider>(
                  builder: (context, pageNavigator, _) {

                    _scrollToSelected(pageNavigator.filterPassword);

                      return SingleChildScrollView(
                        key: _scrollKey,
                        controller: _scrollController,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          spacing: totalWidth * 0.04,
                          children: [
                            // Spacing
                            SizedBox(width: totalWidth * 0.03),

                            // Category Buttons
                            CustomCategoryButton(
                              key: _cardKeys[0],
                              index: 0,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Tous",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(0);
                                dbProvider.setCategory(0);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[1],
                              index: 1,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Favoris",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(1);
                                dbProvider.setCategory(1);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[2],
                              index: 2,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Sites Web",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(2);
                                dbProvider.setCategory(2);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[3],
                              index: 3,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Réseaux Sociaux",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(3);
                                dbProvider.setCategory(3);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[4],
                              index: 4,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Applications",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(4);
                                dbProvider.setCategory(4);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[5],
                              index: 5,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Paiements",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(5);
                                dbProvider.setCategory(5);
                              },
                            ),

                            CustomCategoryButton(
                              key: _cardKeys[6],
                              index: 6,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Sûrs",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(6);
                                dbProvider.setIdsToFilter(context.read<RobustnessProvider>().strongPasswords);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[7],
                              index: 7,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Faibles",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(7);
                                dbProvider.setIdsToFilter(context.read<RobustnessProvider>().weakPasswords);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[8],
                              index: 8,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Réutilisés",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(8);
                                dbProvider.setIdsToFilter(context.read<RobustnessProvider>().allReusedPasswords);
                              },
                            ),
                            CustomCategoryButton(
                              key: _cardKeys[9],
                              index: 9,
                              selectedIndex: pageNavigator.filterPassword,
                              text: "Compromis",
                              onPressed: () {
                                pageNavigator.updateFilterPassword(9);
                                dbProvider.setIdsToFilter(context.read<RobustnessProvider>().compromisedPasswords);
                              },
                            ),
                            // TODO : Filtre de date de création pour les mdp trop vieux ?

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

                    final passwords = dbProvider.filteredPasswords();

                    if (passwords.isEmpty) {
                      return Text(
                        "Aucun mot de passe trouvé.",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: colors.text2,
                        ),
                      );
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
