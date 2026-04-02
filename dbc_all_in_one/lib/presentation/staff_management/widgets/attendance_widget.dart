import 'package:flutter/material.dart';
import '../staff_management.dart';

// ── Palette ───────────────────────────────────────────────────────────────────
const _purple = Color(0xff6D28D9);
const _purpleBg = Color(0xffEDE9FE);
const _white = Colors.white;
const _pageBg = Color(0xffF3F4F6);
const _cardBg = Color(0xffFFFFFF);
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _textLight = Color(0xff9CA3AF);
const _border = Color(0xffE5E7EB);
const _green = Color(0xff16A34A);
const _greenBg = Color(0xffDCFCE7);
const _orange = Color(0xffD97706);
const _orangeBg = Color(0xffFEF3C7);
const _red = Color(0xffDC2626);
const _teal = Color(0xff0D9488);
const _tealBg = Color(0xffCCFBF1);

class AttendanceTabWidget extends StatefulWidget {
  final List<AttendanceRecord> attendance;
  final Function(String) snack;

  const AttendanceTabWidget({
    Key? key,
    required this.attendance,
    required this.snack,
  }) : super(key: key);

  @override
  State<AttendanceTabWidget> createState() => _AttendanceTabWidgetState();
}

class _AttendanceTabWidgetState extends State<AttendanceTabWidget> {
  late DateTime _selectedDay;
  late DateTime _weekStart;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDay = now;
    _weekStart = now.subtract(Duration(days: now.weekday - 1));
  }

  // ── Helpers ──────────────────────────────────────────────────────────────
  // 7 days Mon–Sun
  List<DateTime> get _weekDays =>
      List.generate(7, (i) => _weekStart.add(Duration(days: i)));

  static const _dayLabels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  void _prevWeek() =>
      setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));

  void _nextWeek() =>
      setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));

  String get _weekRangeLabel {
    final s = _weekDays.first;
    final e = _weekDays.last;
    const m = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    if (s.month == e.month) {
      return '${m[s.month - 1]} ${s.day} – ${e.day}, ${e.year}';
    }
    return '${m[s.month - 1]} ${s.day} – ${m[e.month - 1]} ${e.day}, ${e.year}';
  }

  String get _monthLabel {
    const months = [
      'JANUARY',
      'FEBRUARY',
      'MARCH',
      'APRIL',
      'MAY',
      'JUNE',
      'JULY',
      'AUGUST',
      'SEPTEMBER',
      'OCTOBER',
      'NOVEMBER',
      'DECEMBER'
    ];
    return '${months[_selectedDay.month - 1]} ${_selectedDay.year}';
  }

  // ── Root ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, _) => [
        SliverToBoxAdapter(child: _buildScrollableHeader()),
      ],
      body: _buildBody(),
    );
  }

  // ── Scrollable header ─────────────────────────────────────────────────────
  Widget _buildScrollableHeader() {
    return Container(
      color: _pageBg,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month label + calendar icon
          Row(
            children: [
              Text(
                _monthLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: _textMid,
                  letterSpacing: 0.6,
                ),
              ),
              const Spacer(),
              _IconBox(
                icon: Icons.calendar_month_outlined,
                onTap: () => widget.snack('Open Calendar'),
              ),
            ],
          ),
          const SizedBox(height: 3),
          const Text(
            'Attendance Log',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 14),

          // ── Week navigation row ──────────────────────────────────────
          Row(
            children: [
              // Prev week
              _NavChevron(
                icon: Icons.chevron_left_rounded,
                onTap: _prevWeek,
              ),
              const SizedBox(width: 6),
              // Week range label
              Expanded(
                child: Text(
                  _weekRangeLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _textMid,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Next week
              _NavChevron(
                icon: Icons.chevron_right_rounded,
                onTap: _nextWeek,
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Responsive day strip ──────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final totalGap = 6.0 * 6; // 6 gaps between 7 items
              final itemW = (constraints.maxWidth - totalGap) / 7;
              return Row(
                children: List.generate(7, (i) {
                  final day = _weekDays[i];
                  final isSelected = _isSameDay(day, _selectedDay);
                  final isToday = _isSameDay(day, DateTime.now());
                  final isSun = i == 6;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedDay = day);
                      widget.snack(
                          'Selected: ${day.day}/${day.month}/${day.year}');
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: itemW,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      margin: i < 6
                          ? const EdgeInsets.only(right: 6)
                          : EdgeInsets.zero,
                      decoration: BoxDecoration(
                        color: isSelected ? _purple : _cardBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? _purple
                              : (isToday ? _purple.withOpacity(0.4) : _border),
                          width: isToday && !isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _dayLabels[i],
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white60
                                  : (isSun
                                      ? _red.withOpacity(0.7)
                                      : _textLight),
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isSelected
                                  ? _white
                                  : (isSun ? _red : _textDark),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.white38
                                  : (isToday ? _purple : Colors.transparent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ── Sticky body ───────────────────────────────────────────────────────────
  Widget _buildBody() {
    return Container(
      color: _pageBg,
      child: ListView(
        primary: false,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        children: [
          const _MonthlyOverviewCard(),
          const SizedBox(height: 20),
          _TodayAttendanceSection(
            attendance: widget.attendance,
            onViewAll: () => widget.snack('View All'),
          ),
        ],
      ),
    );
  }
}

// ── Small helper widgets ──────────────────────────────────────────────────────
class _NavChevron extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _NavChevron({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _border, width: 1),
        ),
        child: Icon(icon, color: _textMid, size: 18),
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBox({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _border, width: 1),
        ),
        child: Icon(icon, size: 17, color: _textMid),
      ),
    );
  }
}

// ── Monthly Overview Card ─────────────────────────────────────────────────────
class _MonthlyOverviewCard extends StatelessWidget {
  const _MonthlyOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _purpleBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.bar_chart_rounded,
                    color: _purple, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'Monthly Overview',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Avg Attendance
          _StatRow(
            label: 'Avg. Attendance',
            value: '94.2%',
            valueColor: _purple,
            progress: 0.942,
            progressColor: _purple,
            progressBg: _purpleBg,
          ),
          const SizedBox(height: 14),

          // Total Hours
          _StatRow(
            label: 'Total Hours',
            value: '1,240',
            suffix: ' / 1,400',
            valueColor: _textDark,
            progress: 1240 / 1400,
            progressColor: _purple,
            progressBg: _purpleBg,
          ),
          const SizedBox(height: 14),

          // Overtime Hours
          _StatRow(
            label: 'Overtime Hours',
            value: '42.5h',
            valueColor: _textDark,
            progress: 0.42,
            progressColor: _red,
            progressBg: const Color(0xffFEE2E2),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final String? suffix;
  final Color valueColor;
  final double progress;
  final Color progressColor;
  final Color progressBg;

  const _StatRow({
    required this.label,
    required this.value,
    this.suffix,
    required this.valueColor,
    required this.progress,
    required this.progressColor,
    required this.progressBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _textMid)),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: valueColor,
                    ),
                  ),
                  if (suffix != null)
                    TextSpan(
                      text: suffix,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: _textLight,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: progressBg,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
      ],
    );
  }
}

// ── Today's Attendance Section ────────────────────────────────────────────────
class _TodayAttendanceSection extends StatelessWidget {
  final List<AttendanceRecord> attendance;
  final VoidCallback onViewAll;

  const _TodayAttendanceSection({
    required this.attendance,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Section header
        Row(
          children: [
            const Text(
              "Today's Attendance",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: onViewAll,
              child: const Text(
                'VIEW ALL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: _purple,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Cards
        ...attendance.map((r) => _AttendanceCard(record: r)),
      ],
    );
  }
}

class _AttendanceCard extends StatelessWidget {
  final AttendanceRecord record;
  const _AttendanceCard({required this.record});

  Color get _statusColor {
    switch (record.locationStatus) {
      case 'ON-SITE':
        return _green;
      case 'REMOTE':
        return _teal;
      case 'LATE':
        return _orange;
      case 'ABSENT':
        return _red;
      default:
        return _textMid;
    }
  }

  Color get _statusBg {
    switch (record.locationStatus) {
      case 'ON-SITE':
        return _greenBg;
      case 'REMOTE':
        return _tealBg;
      case 'LATE':
        return _orangeBg;
      case 'ABSENT':
        return const Color(0xffFEE2E2);
      default:
        return _border;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundColor: record.avatarColor.withOpacity(0.12),
            child: Text(
              record.initials,
              style: TextStyle(
                color: record.avatarColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Name + role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  record.role,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: _textMid,
                  ),
                ),
              ],
            ),
          ),
          // Check-in time + status badge
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _statusBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  record.locationStatus,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: _statusColor,
                    letterSpacing: 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Check-in time
              Text(
                record.checkIn,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _textMid,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
