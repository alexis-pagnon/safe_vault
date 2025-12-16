import 'package:flutter/material.dart';
import 'package:safe_vault/viewmodels/RobustnessProvider.dart';
import 'package:safe_vault/viewmodels/SharedPreferencesProvider.dart';
import 'package:safe_vault/viewmodels/DatabaseProvider.dart';
import 'package:safe_vault/views/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Providers to add
        ChangeNotifierProvider(create: (_) => DatabaseProvider()..init()),

        ChangeNotifierProvider(create: (_) => SharedPreferencesProvider()..init()),

        ChangeNotifierProxyProvider<DatabaseProvider, RobustnessProvider>(
          create: (context) => RobustnessProvider(
            context.read<DatabaseProvider>(),
          ),
          update: (context, dbProvider, robustnessProvider) =>
          robustnessProvider!..updateDatabase(dbProvider),
        ),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<DatabaseProvider, SharedPreferencesProvider>(
      builder: (context, dbProvider, sharedPrefProvider, _) {
        if (!dbProvider.isReady || !sharedPrefProvider.initialized) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'SafeVault',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}
