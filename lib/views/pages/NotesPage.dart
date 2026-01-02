import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/PageNavigatorProvider.dart';
import 'package:safe_vault/views/widgets/CustomNote.dart';

import '../../models/theme/AppColors.dart';
import '../../viewmodels/DatabaseProvider.dart';
import '../widgets/CustomCategoryButton.dart';
import '../widgets/CustomNoteCreationPopup.dart';
import '../widgets/CustomTextField.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final controller = TextEditingController();


  @override
  void initState() {
    super.initState();
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

    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: totalHeight * 0.022,
          children: <Widget>[
            // Top Side
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: totalWidth * 0.08, horizontal: totalWidth * 0.04),
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
                    "Notes sécurisées",
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.text1,
                    ),
                  ),

                  // TextField + New Note Button
                  Row(
                    spacing: totalWidth * 0.03,
                    children: [
                      // TextField
                      Expanded(
                        child: CustomTextField(
                          hintText: "Rechercher...",
                          controller: controller,
                          search: true,
                          delete: true,
                          onChanged: (value) {
                            dbProvider.setQuery(value);
                          },
                        ),
                      ),

                      // New Note Button
                      GestureDetector(
                        onTap: () {
                          // New Note
                          showDialog(
                            context: context,
                            builder: (context) => CustomNoteCreationPopup(
                              isEditing: false,
                            ),
                          );
                        },

                        child: Container(
                          height: totalHeight * 0.065,
                          width: totalHeight * 0.065,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(255),
                            color: colors.containerBackground2,
                            border: Border.all(color: colors.text4.withAlpha(127), width: 1)
                          ),

                          child: Icon(
                            Icons.add,
                            color: colors.text2,
                            size: totalHeight * 0.035,
                          ),
                        ),
                      ),
                    ],
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
                            CustomCategoryButton(
                              index: 0,
                              selectedIndex: pageNavigator.filterNote,
                              text: "Notes",
                              onPressed: () {
                                pageNavigator.updateFilterNote(0);
                                dbProvider.setNoteCategory(0);
                              },
                            ),
                            CustomCategoryButton(
                              index: 1,
                              selectedIndex: pageNavigator.filterNote,
                              text: "Notes Temporaires",
                              onPressed: () {
                                pageNavigator.updateFilterNote(1);
                                dbProvider.setNoteCategory(1);
                              },
                            ),

                            // Spacing
                            SizedBox(width: totalWidth * 0.03),
                          ],

                        ),
                      );
                    }
                ),

                // Note Cards
                Consumer<DatabaseProvider>(
                  builder: (context, dbProvider, _) {

                    final notes = dbProvider.searchNotes();

                    if (notes.isEmpty) {
                      return Text(
                        "Aucune notes trouvé.",
                        style: GoogleFonts.montserrat(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: colors.text2,
                        ),
                      );
                    }
                    return Column(
                      spacing: totalHeight * 0.025,
                      children: notes.map((note) => CustomNote(
                        note: note,
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
