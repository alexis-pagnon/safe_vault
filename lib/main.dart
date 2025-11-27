import 'package:flutter/material.dart';

import 'package:safe_vault/views/home_page.dart';
import 'package:provider/provider.dart';

import 'package:safe_vault/viewmodels/DatabaseService.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        // Providers to add
        Provider(create: (_) => DatabaseService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeVault',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const HomePage(),
    );
  }
}

