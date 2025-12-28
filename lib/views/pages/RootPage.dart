import 'package:flutter/material.dart';
import 'package:safe_vault/views/pages/NewPasswordPage.dart';
import 'package:safe_vault/models/theme/AppColors.dart';
import 'package:safe_vault/views/widgets/CustomNavBar.dart';
import 'GenerationPage.dart';
import 'HomePage.dart';
import 'NotesPage.dart';
import 'PasswordsPage.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();

}

class _RootPageState extends State<RootPage> {
  final ValueNotifier<int> selectedIndex = ValueNotifier<int>(0);
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        bottomNavigationBar: CustomNavBar(pageController: pageController, selectedIndexNotifier: selectedIndex,),
        body: PageView(
          controller: pageController,
          scrollDirection: Axis.horizontal,
          children: [
            HomePage(),
            PasswordsPage(),
            NewPasswordPage(pageController: pageController),
            GenerationPage(),
            NotesPage(),
          ],

          onPageChanged: (int index) {
            setState(() {
              selectedIndex.value = index;
            });
          },
        ),
      ),
    );
  }
}