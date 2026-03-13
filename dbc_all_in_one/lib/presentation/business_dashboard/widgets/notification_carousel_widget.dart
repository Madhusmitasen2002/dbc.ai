import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Model for notification data
class NotificationItem {
  final String title;
  final String message;
  final String icon;
  final Color color;
  final int displayDuration; // Duration in seconds

  NotificationItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.displayDuration = 3,
  });
}

/// Rotating Notification Carousel Widget
/// Mobile: Full-screen top slide animation (no loop, shows once)
/// Desktop: Snackbar-style notification (no loop, shows once)
class NotificationCarousel extends StatefulWidget {
  final List<NotificationItem> notifications;
  final Duration transitionDuration;
  final VoidCallback? onDismiss;
  final bool autoPlay;

  const NotificationCarousel({
    Key? key,
    required this.notifications,
    this.transitionDuration = const Duration(milliseconds: 600),
    this.onDismiss,
    this.autoPlay = true,
  }) : super(key: key);

  @override
  State<NotificationCarousel> createState() => _NotificationCarouselState();
}

class _NotificationCarouselState extends State<NotificationCarousel>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _progressController;

  int _currentIndex = 0;
  bool _isDesktop = false;
  bool _isInitialized = false;
  bool _hasFinished = false;

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      duration: widget.transitionDuration,
      vsync: this,
    );

    _progressController = AnimationController(
      vsync: this,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      _isDesktop = MediaQuery.of(context).size.width > 600;
      _isInitialized = true;

      if (widget.autoPlay && widget.notifications.isNotEmpty && !_hasFinished) {
        _startCycling();
      }
    }
  }

  void _startCycling() {
    _cycleToNextNotification();
  }

  Future<void> _cycleToNextNotification() async {
    if (!mounted || widget.notifications.isEmpty || _hasFinished) return;

    final currentNotification = widget.notifications[_currentIndex];
    final displayDuration =
        Duration(seconds: currentNotification.displayDuration);

    // Slide in animation
    await _slideController.forward();

    // Set up progress bar
    _progressController.duration = displayDuration;
    _progressController.forward(from: 0.0);

    // Wait for display duration
    await Future.delayed(displayDuration);

    if (!mounted) return;

    // Slide out animation
    await _slideController.reverse();

    if (!mounted) return;

    // Move to next notification
    _currentIndex++;

    // Check if we've shown all notifications
    if (_currentIndex >= widget.notifications.length) {
      setState(() {
        _hasFinished = true;
      });
      if (widget.onDismiss != null) {
        widget.onDismiss!();
      }
      return;
    }

    // Reset controllers for next notification
    _slideController.reset();
    _progressController.reset();

    // Rebuild to show next notification
    if (mounted) {
      setState(() {});
    }

    // Continue to next notification
    _cycleToNextNotification();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notifications.isEmpty || _hasFinished) {
      return const SizedBox.shrink();
    }

    return _isDesktop ? _buildDesktopSnackbar() : _buildMobileNotification();
  }

  /// Desktop: Snackbar-style notification
  Widget _buildDesktopSnackbar() {
    final theme = Theme.of(context);
    final notification = widget.notifications[_currentIndex];

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(_slideController),
      child: Container(
        margin: EdgeInsets.all(2.w),
        decoration: BoxDecoration(
          color: notification.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getIcon(notification.icon),
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notification.title,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.4.h),
                        Text(
                          notification.message,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 1.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasFinished = true;
                      });
                      if (widget.onDismiss != null) {
                        widget.onDismiss!();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
                child: LinearProgressIndicator(
                  value: _progressController.value,
                  backgroundColor: Colors.white.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.white.withValues(alpha: 0.5),
                  ),
                  minHeight: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Mobile: Full-screen top slide animation
  Widget _buildMobileNotification() {
    final theme = Theme.of(context);
    final notification = widget.notifications[_currentIndex];

    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, -1.0), end: const Offset(0.0, 0.0))
          .animate(
            CurvedAnimation(parent: _slideController, curve: Curves.easeOut),
          ),
      child: Container(
        width: 100.w,
        color: notification.color,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.5.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Icon(
                        _getIcon(notification.icon),
                        color: Colors.white,
                        size: 7.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          notification.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          notification.message,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontWeight: FontWeight.w400,
                            fontSize: 11.sp,
                            height: 1.3,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 2.w),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _hasFinished = true;
                      });
                      if (widget.onDismiss != null) {
                        widget.onDismiss!();
                      }
                    },
                    child: Icon(
                      Icons.close,
                      color: Colors.white.withValues(alpha: 0.6),
                      size: 5.5.w,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _progressController.value,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.5),
                ),
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIcon(String iconName) {
    final iconMap = {
      'payment': Icons.attach_money,
      'security': Icons.warning_amber_rounded,
      'inventory': Icons.inventory_2,
      'alert': Icons.notifications_active,
      'check': Icons.check_circle,
      'error': Icons.error_outline,
      'info': Icons.info_outline,
    };
    return iconMap[iconName] ?? Icons.notifications;
  }
}