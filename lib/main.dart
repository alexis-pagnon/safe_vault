import 'package:flutter/material.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
import 'package:safe_vault/viewmodels/SharedPreferencesProvider.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:safe_vault/viewmodels/theme/ThemeController.dart';
import 'package:safe_vault/views/pages/RootPage.dart';

import 'package:safe_vault/views/testPage.dart'; // TODO : remove this import

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
    MultiProvider(
      providers: [
        // Providers to add


        ChangeNotifierProvider(create: (_) => DatabaseProvider()..init('azerty')), // TODO : remove the init from here since it will be called in AuthenticationProvider

        ChangeNotifierProvider(create: (_) => ThemeController()),

        ChangeNotifierProvider(create: (_) => SharedPreferencesProvider()..init()),

        // TODO : Add SharedPreferencesProvider to AuthenticationProvider ? (to save the hashed master password in shared preferences ?)
        ChangeNotifierProxyProvider<DatabaseProvider, AuthenticationProvider>(
          create: (context) => AuthenticationProvider(
            context.read<DatabaseProvider>(),
          ),
          update: (context, dbProvider, authenticationProvider) =>
          authenticationProvider!..initDB(dbProvider),
        ),


        ChangeNotifierProxyProvider<DatabaseProvider, RobustnessProvider>(
          create: (context) => RobustnessProvider(
            context.read<DatabaseProvider>(),
          ),
          update: (context, dbProvider, robustnessProvider) =>
          robustnessProvider!..updateDatabase(dbProvider),
        ),

      ],
      child: const AppRoot(),
    ),
  );
}


class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {

    final theme = context.watch<ThemeController>().theme;

    return MaterialApp(
        title: 'SafeVault',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: const MyApp()
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DatabaseProvider, SharedPreferencesProvider>(
      builder: (context, dbProvider, sharedPrefProvider, _) {
        // TODO : check authentication isReady -> do the authentication check -> then check dbProvider.isOpened

        if (!dbProvider.isOpened || !sharedPrefProvider.initialized) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
          );
        }

        // TODO : Check if first time + redirect to authentication page

         return const RootPage();


      },
    );
  }
}

