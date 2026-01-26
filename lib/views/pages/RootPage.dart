import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_vault/models/SharedPreferencesRepository.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:safe_vault/viewmodels/PageNavigatorProvider.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
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
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final robustness = context.read<RobustnessProvider>();

      if (robustness.initialized) {
        checkOldAndCompromisedPasswords();
      } else {
        // Attendre l'initialisation
        robustness.addListener(_onRobustnessReady);
      }
    });
  }

  void _onRobustnessReady() {
    final robustness = context.read<RobustnessProvider>();
    if (!robustness.initialized) return;
    robustness.removeListener(_onRobustnessReady);
    if (mounted) {
      checkOldAndCompromisedPasswords();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Automatically lock the (close database and logout) app after 10 minutes
  void automaticLock() {
    Future.delayed(const Duration(minutes: 10), () {
      if (mounted) {
        context.read<PageNavigatorProvider>().reset();
        context.read<DatabaseProvider>().resetFilters();
        context.read<AuthenticationProvider>().logout();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final navigator = context.read<PageNavigatorProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      bottomNavigationBar: const CustomNavBar(),
      body: Column(
        children: [
          // Status bar color
          Container(
            height: MediaQuery.of(context).padding.top,
            width: double.infinity,
            color: colors.gradientTopStart,
          ),

          // Rest of the app
          Expanded(
            child: PageView(
              scrollDirection: Axis.horizontal,
              controller: navigator.pageController,
              onPageChanged: navigator.onPageChanged,
              children: [
                HomePage(),
                PasswordsPage(),
                NewPasswordPage(),
                GenerationPage(),
                NotesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Check for new old and compromised passwords and show a snackbar if any
  void checkOldAndCompromisedPasswords() {
    final robustness = context.read<RobustnessProvider>();
    final prefs = context.read<SharedPreferencesRepository>();
    final newOld = robustness.getNewOldPasswords(prefs.previousOldPassword);
    final newCompromised =
        robustness.getNewCompromisedPasswords(prefs.previousCompromisedPassword);

    if (newOld.isNotEmpty) {
      (newOld.length == 1)
          ? showSnackBar("Vous avez 1 nouveau mot de passe trop vieux.")
          : showSnackBar(
              "Vous avez ${newOld.length} nouveaux mots de passe trop vieux.");
    }

    if (newCompromised.isNotEmpty) {
      (newCompromised.length == 1)
          ? showSnackBar("Vous avez 1 nouveau mot de passe compromis.")
          : showSnackBar(
              "Vous avez ${newCompromised.length} nouveaux mots de passe compromis.");
    }

    prefs.setPreviousOldPassword(robustness.oldPasswords);
    prefs.setPreviousCompromisedPassword(robustness.compromisedPasswords);
  }

  void showSnackBar(String message) {
    final colors = Theme.of(context).extension<AppColors>()!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: colors.purpleDarker,
        padding: const EdgeInsets.all(16.0),
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

