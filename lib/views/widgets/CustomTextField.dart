import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/theme/AppColors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool copy;
  final bool eye;
  final bool search;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.copy = false,
    this.eye = false,
    this.search = false,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

}

class _CustomTextFieldState extends State<CustomTextField> {
  bool eyeState = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;
    final totalHeight = MediaQuery.of(context).size.height;

    return TextField(
      obscureText: widget.eye ? !eyeState : false,
      enableSuggestions: widget.eye ? false : true,
      autocorrect: widget.eye ? false : true,

      controller: widget.controller,

      style: GoogleFonts.montserrat(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.text3,
      ),

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Colors.red, //Color(0xFFE5E7EB)
            width: 1,
          ),
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.text4.withOpacity(0.5),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.gradientButtonsStart,
            width: 1.5,
          ),
        ),

        hintText: widget.hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colors.hintText,
        ),

        fillColor: colors.containerBackground2,
        filled: true,

        prefixIcon: widget.search
          ? Padding(
              padding: EdgeInsets.only(left: totalWidth * 0.03, right: totalWidth * 0.01),
              child: Icon(
                Icons.search_rounded,
                color: colors.text4,
              ),
            )
          : null,
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            if(widget.eye)
              InkWell(
                  onTap: () {
                    print("TESTTTTTTTTTTTTTT");
                    setState(() {
                      eyeState = !eyeState;
                    });
                  },
                  child: Icon(
                    eyeState ? Icons.visibility_off_rounded : Icons.remove_red_eye_sharp,
                    color: colors.text4,
                  ),
                ),

            if(widget.eye && widget.copy)
              SizedBox(width: totalWidth * 0.02),

            if(widget.copy)
              InkWell(
                  onTap: () {
                    print("TESTTTTTTTTTTTTTT2");
                  },
                    child: Icon(
                                Icons.copy_rounded,
                                color: colors.text4,
                              ),
                  ),

            if(widget.eye || widget.copy)
              SizedBox(width: totalWidth * 0.03),
          ],
        ),
      ),
    );
  }
}