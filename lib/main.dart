import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
import 'package:safe_vault/models/SharedPreferencesRepository.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:safe_vault/viewmodels/AuthenticationProvider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:safe_vault/viewmodels/theme/ThemeController.dart';
import 'package:safe_vault/views/pages/ConnexionPage.dart';
import 'package:safe_vault/views/pages/RegisterPage.dart';
import 'package:safe_vault/views/pages/RootPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/authentication/SecureStorageRepository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final prefs = await SharedPreferencesWithCache.create(
    cacheOptions: const SharedPreferencesWithCacheOptions(
      allowList: {'first_time', 'hashed_password', 'theme'},
    ),
  );
  const secureStorage = FlutterSecureStorage();



  final sharedPreferencesRepo = SharedPreferencesRepository(prefs);
  final secureStorageRepo = SecureStorageRepository(secureStorage);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController(themeMode: sharedPreferencesRepo.theme)),

        ChangeNotifierProvider(create: (_) => DatabaseProvider()),

        Provider.value(value: sharedPreferencesRepo),
        Provider.value(value: secureStorageRepo),

        ChangeNotifierProvider(
          create: (context) => AuthenticationProvider(
            databaseProvider: context.read<DatabaseProvider>(),
            sharedPreferencesRepository: sharedPreferencesRepo,
            secureStorage: secureStorageRepo,
          ),
        ),

        ChangeNotifierProvider(
          create: (context) => RobustnessProvider(
            context.read<DatabaseProvider>(),
          ),
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
    return Consumer<AuthenticationProvider>(
      builder: (_, auth, _) {
        // Check if the user is authenticated
        if (!auth.isAuthenticated) {
          if(context.watch<SharedPreferencesRepository>().firstTime) {
            return const RegisterPage();
          }
          else {
            return const ConnexionPage();
          }
          // return const TestPage2();  // Test the registration / authentication
        }


        return Consumer<DatabaseProvider>(
          builder: (_, db, _) {
            // User is authenticated, check if the database is opened
            if (!db.isOpened) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            // User is authenticated + database is opened -> navigate to the root page
            return const RootPage();
          },
        );
      },
    );
  }
}

