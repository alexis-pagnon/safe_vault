import 'package:flutter/material.dart';

class VaultsPage extends StatefulWidget {
  const VaultsPage({super.key});

  @override
  State<VaultsPage> createState() => _VaultsPageState();
}

class _VaultsPageState extends State<VaultsPage> {
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
