import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/PageNavigatorProvider.dart';
import '../../models/theme/AppColors.dart';

class CustomNavBar extends StatefulWidget {

  const CustomNavBar({
    super.key,
  });

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}


class _CustomNavBarState extends State<CustomNavBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedIndex = context.watch<PageNavigatorProvider>().currentPage;
  }


  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;

    final navigator = Provider.of<PageNavigatorProvider>(context, listen: false);


    return Container(
      height: totalHeight * 0.09,
      color: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Background Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: totalHeight * 0.09,
              width: double.infinity,
              decoration: BoxDecoration(
                color: colors.containerBackground1,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: colors.dropShadow,
                    blurRadius: 8,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      navigator.jumpToPage(0);
                    },
                    child: _navItem(Icons.home_rounded, selectedIndex == 0, context)
                  ),
                  InkWell(
                      onTap: () {
                        navigator.jumpToPage(1);
                      },
                      child: _navItem(Icons.lock, selectedIndex == 1, context)
                  ),
                  SizedBox(width: 60),
                  InkWell(
                      onTap: () {
                        navigator.jumpToPage(3);
                      },
                      child: _navItem(Icons.auto_awesome_rounded, selectedIndex == 3, context)
                  ),
                  InkWell(
                      onTap: () {
                        navigator.jumpToPage(4);
                      },
                      child: _navItem(Icons.article_rounded, selectedIndex == 4, context)
                  ),
                ],
              ),
            ),
          ),

          // Circle
          Positioned(
            top: -20,
            left: 0,
            right: 0,
            child: Center(
              child: InkWell(
                onTap: () {
                  navigator.jumpToPage(2);
                },

                child: Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colors.gradientButtonsStart, colors.gradientButtonsEnd],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                      )
                    ],
                  ),
                  child: Icon(Icons.add, color: Colors.white, size: 35),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _navItem(IconData icon, bool active, BuildContext context) {
  final colors = Theme.of(context).extension<AppColors>()!;

  return Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: active ? [colors.gradientButtonsStart, colors.gradientButtonsEnd] : [colors.navbarIconsBackground, colors.navbarIconsBackground],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Icon(
      icon,
      color: active ? Colors.white : colors.navbarIconsColor,
      size: 26,
    ),
  );
}
