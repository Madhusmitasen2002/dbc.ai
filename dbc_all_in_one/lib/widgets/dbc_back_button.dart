import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../routes/app_routes.dart';

/// Premium back button — white rounded-square with left chevron.
///
/// Matches the screenshot design exactly:
///   • Pure white (#FFFFFF) background
///   • 40×40 rounded square (radius 12)
///   • Subtle drop shadow
///   • Dark left-pointing chevron icon
///   • Spring scale animation on press
///   • Haptic feedback
///   • Smart navigation (pop → dashboard fallback)
class DBCBackButton extends StatefulWidget {
  /// Override the default smart-navigation behaviour.
  final VoidCallback? onPressed;

  const DBCBackButton({super.key, this.onPressed});

  @override
  State<DBCBackButton> createState() => _DBCBackButtonState();
}

class _DBCBackButtonState extends State<DBCBackButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.87).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    HapticFeedback.lightImpact();
    await _ctrl.forward();
    await _ctrl.reverse();
    if (!mounted) return;
    if (widget.onPressed != null) {
      widget.onPressed!();
    } else {
      _smartBack();
    }
  }

  void _smartBack() {
    // Try to pop the nearest navigator first (works for pushNamed path).
    if (Navigator.canPop(context)) {
      Navigator.of(context).pop();
      return;
    }

    // If there's no back stack (e.g. we arrived via pushReplacementNamed from
    // the sidebar/bottom bar), replace the entire navigator stack with the
    // dashboard route. This avoids cases where the current navigator has no
    // entries and prevents landing on an empty/blank route.
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.businessDashboard,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Go back',
      button: true,
      child: GestureDetector(
        onTap: _handleTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.07),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 22,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ),
      ),
    );
  }
}
