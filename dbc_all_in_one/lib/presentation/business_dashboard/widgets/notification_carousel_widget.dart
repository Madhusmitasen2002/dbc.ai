import 'dart:async';
import 'package:flutter/material.dart';

// ── Model (unchanged) ─────────────────────────────────────────────────────────
class NotificationItem {
  final String title;
  final String message;
  final String icon;
  final Color color;
  final int displayDuration; // kept for compatibility, not used internally

  const NotificationItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    required this.displayDuration,
  });
}

// ── Widget ────────────────────────────────────────────────────────────────────
class NotificationCarousel extends StatefulWidget {
  final List<NotificationItem> notifications;
  final VoidCallback onDismiss;

  const NotificationCarousel({
    super.key,
    required this.notifications,
    required this.onDismiss,
  });

  @override
  State<NotificationCarousel> createState() => _NotificationCarouselState();
}

class _NotificationCarouselState extends State<NotificationCarousel>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Slides the card in from the LEFT → RIGHT
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  // Fills the progress bar over 5 seconds
  late AnimationController _progressController;

  Timer? _holdTimer; // waits 10s before progress bar starts

  static const int _holdSeconds = 10;
  static const int _progressSeconds = 5;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0), // enters from left
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: _progressSeconds),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _advanceToNext();
        }
      });

    _startCycle();
  }

  /// Slide in → hold 10s → progress bar 5s → advance → repeat
  void _startCycle() {
    if (!mounted) return;

    _slideController.reset();
    _progressController.reset();
    _slideController.forward();

    _holdTimer?.cancel();
    _holdTimer = Timer(const Duration(seconds: _holdSeconds), () {
      if (mounted) _progressController.forward();
    });
  }

  void _advanceToNext() {
    if (!mounted) return;
    setState(() {
      _currentIndex = (_currentIndex + 1) % widget.notifications.length;
    });
    _startCycle();
  }

  @override
  void dispose() {
    _holdTimer?.cancel();
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  IconData _resolveIcon(String name) {
    const map = {
      'payment': Icons.payment,
      'security': Icons.security,
      'inventory': Icons.inventory_2,
      'warning': Icons.warning_amber_rounded,
      'info': Icons.info_outline,
      'check': Icons.check_circle_outline,
    };
    return map[name] ?? Icons.notifications_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.notifications[_currentIndex];

    return ClipRect(
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Main row: icon + text + dismiss ──
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 10, 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Colored icon badge
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _resolveIcon(item.icon),
                        color: item.color,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title + subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A1A1A),
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.message,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B6B6B),
                              height: 1.35,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // × dismiss button
                    GestureDetector(
                      onTap: widget.onDismiss,
                      child: const Padding(
                        padding: EdgeInsets.all(6),
                        child: Icon(
                          Icons.close,
                          size: 18,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom row: progress bar + dot indicators ──
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Animated progress bar
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: AnimatedBuilder(
                          animation: _progressController,
                          builder: (_, __) => LinearProgressIndicator(
                            value: _progressController.value,
                            minHeight: 3,
                            backgroundColor: item.color.withOpacity(0.15),
                            valueColor:
                                AlwaysStoppedAnimation<Color>(item.color),
                          ),
                        ),
                      ),
                    ),

                    // Dot indicators (only if multiple notifications)
                    if (widget.notifications.length > 1) ...[
                      const SizedBox(width: 10),
                      Row(
                        children: List.generate(
                          widget.notifications.length,
                          (i) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.only(left: 4),
                            width: i == _currentIndex ? 16 : 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: i == _currentIndex
                                  ? item.color
                                  : item.color.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}