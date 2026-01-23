import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/SharedPreferencesRepository.dart';
import '../../models/theme/AppColors.dart';
import '../../viewmodels/theme/ThemeController.dart';

class CustomThemeSwitcher extends StatefulWidget {
  const CustomThemeSwitcher({super.key});

  @override
  State<CustomThemeSwitcher> createState() => _CustomThemeSwitcherState();
}

class _CustomThemeSwitcherState extends State<CustomThemeSwitcher>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _opacity;

  bool isDark = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _rotation = Tween<double>(
      begin: 0.5, // 180deg
      end: 0.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacity = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0),
        weight: 50,
      ),
    ]).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Sync icon + controller position with current theme on first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final startIsDark = context.read<ThemeController>().isDark;

      setState(() {
        isDark = startIsDark;
      });

      _controller.value = startIsDark ? 0.0 : 1.0;
    });

    bool _alreadySwapped = false;

    // Swap theme + icon at 50% progress (forward and reverse).
    _controller.addListener(() {
      final movingForward = _controller.status == AnimationStatus.forward;
      final movingReverse = _controller.status == AnimationStatus.reverse;

      // Forward: swap when crossing above 0.5.
      // Reverse: swap when crossing below 0.5.
      final shouldSwapNow = (movingForward && _controller.value >= 0.5) ||
          (movingReverse && _controller.value <= 0.5);

      if (shouldSwapNow && !_alreadySwapped) {
        setState(() {
          isDark = !isDark;
        });
        _alreadySwapped = true;

        final themeController = context.read<ThemeController>();
        final sharedPreferences = context.read<SharedPreferencesRepository>();

        themeController.toggleTheme();
        sharedPreferences.setTheme(themeController.isDark ? 'dark' : 'light');
      }

      // Unlock after crossing back, so the next tap can swap again.
      final shouldUnlock = (movingForward && _controller.value < 0.5) ||
          (movingReverse && _controller.value > 0.5) ||
          _controller.status == AnimationStatus.completed ||
          _controller.status == AnimationStatus.dismissed;

      if (shouldUnlock) {
        _alreadySwapped = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    // Ignore taps while animating.
    if (_controller.isAnimating) return;

    // Play forward/reverse.
    if (_controller.isCompleted) {
      _controller.reverse();
    } else {
      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final totalHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: _onTap,
      child: Container(
        height: totalHeight * 0.05,
        width: totalHeight * 0.05,
        decoration: BoxDecoration(
          color: colors.containerBackground1,
          borderRadius: BorderRadius.circular(25),
        ),
        child: RotationTransition(
          turns: _rotation,
          child: FadeTransition(
            opacity: _opacity,
            child: Icon(
              // Inverted icons: dark -> sun, light -> moon.
              isDark ? Icons.light_mode : Icons.dark_mode,
              size: totalHeight * 0.04,
            ),
          ),
        ),
      ),
    );
  }
}
