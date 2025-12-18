import 'package:flutter/material.dart';

class PasswordsPage extends StatefulWidget {
  const PasswordsPage({super.key});

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  @override
  Widget build(BuildContext context) {
    // final colors = Theme.of(context).extension<AppColors>()!;
    // final totalWidth = MediaQuery.of(context).size.width;
    // final totalHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green,

      body: SafeArea(child: SizedBox()),
    );
  }
}
