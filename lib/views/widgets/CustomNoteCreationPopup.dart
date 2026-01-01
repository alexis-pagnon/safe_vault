import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/theme/AppColors.dart';

class CustomNoteCreationPopup extends StatefulWidget {
  final String initialTitle;
  final String initialContent;
  final int idNote;
  final bool isEditing;

  const CustomNoteCreationPopup({
    super.key,
    this.initialTitle = "",
    this.initialContent = "",
    this.idNote = -1,
    this.isEditing = false,
  });

  @override
  State<CustomNoteCreationPopup> createState() => _CustomNoteCreationPopupState();
}

class _CustomNoteCreationPopupState extends State<CustomNoteCreationPopup> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.initialTitle);
    contentController = TextEditingController(text: widget.initialContent);

    _recomputeFormValidity();
    titleController.addListener(_recomputeFormValidity);
    contentController.addListener(_recomputeFormValidity);
  }

  void _recomputeFormValidity() {
    bool isValid = (titleController.text.trim().isNotEmpty &&
        contentController.text.trim().isNotEmpty);

    if(widget.isEditing && isValid){
      isValid = titleController.text.trim() != widget.initialTitle.trim() ||
            contentController.text.trim() != widget.initialContent.trim() ;
    }

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    titleController.removeListener(_recomputeFormValidity);
    contentController.removeListener(_recomputeFormValidity);
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    final dialogTitle = widget.isEditing ? 'Modifier la note sécurisée' : 'Nouvelle note sécurisée';
    final submitText = widget.isEditing ? 'Modifier' : 'Créer';

    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: totalWidth * 0.06),
      child: Container(
        padding: EdgeInsets.all(totalHeight * 0.02),
        decoration: BoxDecoration(
          color: colors.containerBackground1,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.dropShadow,
              blurRadius: 10,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: totalHeight * 0.02,
          children: [
            // Title
            Text(
              dialogTitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colors.text3,
              ),
            ),

            // First Text Field
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Titre de la note',
                filled: true,
                fillColor: colors.containerBackground2,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.text4.withAlpha(127), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: colors.gradientButtonsStart, width: 1.5),
                ),
              ),
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: colors.text3,
              ),
            ),

            // Second Text Field
            SizedBox(
              height: totalHeight * 0.25,
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Contenu de la note...',
                  filled: true,
                  fillColor: colors.containerBackground2,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colors.text4.withAlpha(127), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: colors.gradientButtonsStart, width: 1.5),
                  ),
                ),
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: colors.text3,
                ),
              ),
            ),

            // Buttons
            Row(
              spacing: totalWidth * 0.03,
              children: [
                // Cancel Button
                Expanded(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      height: totalHeight * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colors.containerBackground2,
                      ),
                      child: Center(
                        child: Text(
                          'Annuler',
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: colors.text3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Create / Modify Button
                Expanded(
                  child: GestureDetector(
                    onTap: _isFormValid
                        ? () async {
                          final title = titleController.text;
                          final content = contentController.text;

                          if(widget.isEditing) {
                            // TODO: Alexis: Modifier la note (et pour la date l'actualiser au jour de la modification)
                          } else {
                            // TODO: Alexis: Créer la note
                          }

                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                        : null,
                    child: Container(
                      height: totalHeight * 0.055,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: _isFormValid ? [colors.gradientButtonsStart, colors.gradientButtonsEnd] : [colors.gradientButtonsUnavailableStart, colors.gradientButtonsUnavailableEnd],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          submitText,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}