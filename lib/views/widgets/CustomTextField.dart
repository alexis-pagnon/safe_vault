import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/theme/AppColors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool copy;
  final bool eye;
  final bool search;
  final bool delete;
  final TextEditingController controller;
  final bool editable;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    this.copy = false,
    this.eye = false,
    this.search = false,
    this.delete = false,
    required this.controller,
    this.editable = true,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();

}

class _CustomTextFieldState extends State<CustomTextField> {
  bool eyeState = false;

  @override
  void initState() {
    super.initState();
    // Listener instead of default onChanged in order to have it work with controller changes (clear)
    widget.controller.addListener(_onChanged);
  }

  void _onChanged() {
    if(widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalWidth = MediaQuery.of(context).size.width;

    return TextField(
      obscureText: widget.eye ? !eyeState : false,
      enableSuggestions: !widget.eye,
      autocorrect: !widget.eye,
      readOnly: !widget.editable,
      controller: widget.controller,


      style: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: colors.text3,
      ),

      decoration: InputDecoration(

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: colors.text4.withAlpha(127),
            width: 1,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: widget.editable ? colors.gradientButtonsStart : colors.text4.withAlpha(127),
            width: widget.editable ? 1.5 : 1,
          ),
        ),

        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: 'Montserrat',
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
                    setState(() {
                      eyeState = !eyeState;
                    });
                  },
                  child: Icon(
                    eyeState ? Icons.visibility_off_rounded : Icons.remove_red_eye_sharp,
                    color: colors.text4,
                  ),
                ),

            if(widget.eye && widget.copy || widget.eye && widget.delete || widget.copy && widget.delete)
              SizedBox(width: totalWidth * 0.02),

            if(widget.copy)
              InkWell(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: widget.controller.text));
                },
                child: Icon(
                  Icons.copy_rounded,
                  color: colors.text4,
                ),
              ),

            if(widget.delete)
              InkWell(
                onTap: () {
                  widget.controller.clear();
                },
                child: Icon(
                  Icons.close_rounded,
                  color: colors.text4,
                  weight: 500,
                )
              ),

            if(widget.eye || widget.copy || widget.delete)
              SizedBox(width: totalWidth * 0.03),
          ],
        ),
      ),
    );
  }
}