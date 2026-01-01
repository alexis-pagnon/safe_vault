import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
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
  void initState() {
    super.initState();
    automaticLock();
  }


  @override
  void dispose() {
    pageController.dispose();
    selectedIndex.dispose();
    super.dispose();
  }


  /// Automatically lock the (close database and logout) app after 10 minutes
  void automaticLock() {
    Future.delayed(const Duration(minutes: 10), () {
      if (mounted) {
        context.read<AuthenticationProvider>().logout();
      }
    });
  }


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
            HomePage(pageController: pageController),
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