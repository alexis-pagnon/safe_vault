import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:safe_vault/views/widgets/CustomTextField.dart';
import '../../models/database/Password.dart';
import '../../models/theme/AppColors.dart';

class CustomPasswordCard extends StatefulWidget {
  final Password password;

  const CustomPasswordCard({
    super.key,
    required this.password,
  });

  @override
  State<CustomPasswordCard> createState() => _CustomPasswordCardState();
}

class _CustomPasswordCardState extends State<CustomPasswordCard> {
  final TextEditingController controller = TextEditingController();
  bool test = true;

  @override
  void initState() {
    super.initState();
    controller.text = widget.password.password;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;

    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    return Container(
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
                  color: widget.password.id_category == 1
                      ? Color(0xFF9333EA)
                      : widget.password.id_category == 2
                      ? Color(0xFFEA580C)
                      : widget.password.id_category == 3
                      ? Color(0xFF16A34A)
                      : Color(0xFFDB2777),
                ),

                height: totalHeight * 0.06,
                width: totalHeight * 0.06,

                child: Padding(
                  padding: widget.password.id_category == 1 ? EdgeInsets.all(totalHeight * 0.011) : EdgeInsets.all(totalHeight * 0.010),
                  child: SvgPicture.asset(
                    widget.password.id_category == 1
                    ? 'assets/svg/internet.svg'
                    : widget.password.id_category == 2
                      ? 'assets/svg/social_network2.svg'
                      : widget.password.id_category == 3
                        ? 'assets/svg/smartphone.svg'
                        : 'assets/svg/shopping_cart.svg',
                    colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),

                  ),
                ),
              ),

              // Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Service + Favorite + Menu
                    Row(
                      children: [
                        // Name
                        Text(
                          widget.password.service,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: colors.text3,
                          ),
                        ),

                        // Spacing
                        Spacer(),

                        // Favorite
                        InkWell(
                          child: SvgPicture.asset(
                            widget.password.is_favorite ? "assets/svg/favorite_filled.svg" : "assets/svg/favorite.svg",
                            colorFilter: widget.password.is_favorite
                                ? ColorFilter.mode(Color(0xFFFB2C36), BlendMode.srcIn)
                                : ColorFilter.mode(colors.text4, BlendMode.srcIn),

                            height: totalHeight * 0.033,
                          ),

                          onTap: () {
                            // Update favorite status
                            dbProvider.toggleFavoriteStatus(widget.password.id_pwd!,!widget.password.is_favorite);
                          },
                        ),

                        SizedBox(width: totalWidth * 0.01),

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
                                  print('Modifier');
                                  // TODO : Modifier le mot de passe
                                } else if (value == 'delete') {
                                  dbProvider.deletePassword(widget.password.id_pwd!);
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
                                    style: GoogleFonts.montserrat(
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
                                    style: GoogleFonts.montserrat(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: colors.text3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )

                      ],
                    ),

                    // Username
                    Text(
                      widget.password.username,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colors.text4,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),

          // TextField
          CustomTextField(
            hintText: "",
            controller: controller,
            editable: false,
            eye: true,
            copy: true,
          ),
        ],
      ),
    );
  }
}

