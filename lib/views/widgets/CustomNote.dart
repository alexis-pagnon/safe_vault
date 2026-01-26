import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import '../../models/database/Note.dart';
import '../../models/theme/AppColors.dart';
import 'CustomNoteCreationPopup.dart';
import 'CustomNoteVisualisationPopup.dart';

class CustomNote extends StatelessWidget {
  final Note note;

  const CustomNote({
    super.key,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    final date = DateTime.fromMillisecondsSinceEpoch(note.date);
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (_) => CustomNoteVisualisationPopup(
            title: note.title,
            date: '$day/$month/$year',
            content: note.content,
          ),
        );
      },
      child: Container(
        width: totalWidth * 0.85,
        padding: EdgeInsets.all(totalHeight * 0.02),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            // First Part
            Row(
              spacing: 10,
              children: [
                // Logo
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(colors: [colors.gradientButtonsStart, colors.gradientButtonsEnd]),
                  ),

                  height: totalHeight * 0.06,
                  width: totalHeight * 0.06,

                  child: Padding(
                    padding: EdgeInsets.all(totalHeight * 0.012),
                    child: SvgPicture.asset(
                      "assets/svg/lock.svg",
                      colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),

                    ),
                  ),
                ),

                // Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title + Date + Menu
                      Row(
                        children: [
                          // Title
                          Text(
                            note.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: colors.text3,
                            ),
                          ),

                          // Spacing
                          Spacer(),

                          // Menu
                          SizedBox(
                            height: totalHeight * 0.033,
                            width: totalHeight * 0.033,
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                splashFactory: NoSplash.splashFactory, // Remove splash effect
                              ),

                              child: PopupMenuButton<String>(
                                padding: EdgeInsets.all(0),
                                icon: SvgPicture.asset(
                                  "assets/svg/more.svg",
                                  colorFilter: ColorFilter.mode(colors.text4, BlendMode.srcIn),
                                  height: totalHeight * 0.033,
                                ),

                                onSelected: (String value) {
                                  if (value == 'edit') {
                                    // Show the pop up to edit the note
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (_) => CustomNoteCreationPopup(
                                        initialTitle: note.title,
                                        initialContent: note.content,
                                        idNote: note.id_note!,
                                        initialIsTemporary: note.isTemporary,
                                        isEditing: true,
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    dbProvider.deleteNote(note.id_note!);
                                  }
                                },

                                color: colors.containerBackground2,
                                offset: Offset(-2, 0),
                                menuPadding: EdgeInsets.all(0),
                                borderRadius: BorderRadius.circular(10),
                                shadowColor: colors.dropShadow,
                                popUpAnimationStyle: AnimationStyle(curve: Curves.easeInOut, duration: Duration(milliseconds: 500)),
                                splashRadius: 0.1,

                                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text(
                                      'Modifier',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: colors.text3,
                                      ),
                                    ),

                                  ),
                                  PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text(
                                      'Supprimer',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: colors.text3,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(width: totalWidth * 0.01),
                        ],
                      ),

                      // Date
                      Text(
                        '$day/$month/$year',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colors.text4,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),

            // Content
            Text(
              note.content,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: colors.text3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}