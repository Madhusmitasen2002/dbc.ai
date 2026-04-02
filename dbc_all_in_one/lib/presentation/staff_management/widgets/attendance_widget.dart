import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../staff_management.dart';

const _purple = Color(0xff6D28D9);
const _white = Colors.white;
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _border = Color(0xffE5E7EB);
const _green = Color(0xff16A34A);
const _red = Color(0xffDC2626);
const _orange = Color(0xffD97706);
const _teal = Color(0xff0D9488);

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
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Attendance Overview",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: _textDark)),
          const SizedBox(height: 4),
          const Text("Track daily attendance and shift patterns",
              style: TextStyle(fontSize: 13, color: _textMid)),
          const SizedBox(height: 20),
          // Calendar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                widget.snack(
                    "Selected: ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}");
              },
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: _purple.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: const BoxDecoration(
                  color: _purple,
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: _green,
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: const TextStyle(color: _red),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
                leftChevronIcon: const Icon(Icons.chevron_left, color: _purple),
                rightChevronIcon: const Icon(Icons.chevron_right, color: _purple),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: _textMid, fontSize: 12),
                weekendStyle: const TextStyle(color: _red, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Monthly overview card
          _monthlyOverviewCard(),
          const SizedBox(height: 20),
          // Today's attendance
          Row(
            children: [
              const Text("Today's Attendance",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: _textDark)),
              const Spacer(),
              Text("${widget.attendance.length} staff",
                  style: const TextStyle(fontSize: 13, color: _textMid)),
            ],
          ),
          const SizedBox(height: 12),
          ...widget.attendance.map((record) => _attendanceCard(record)),
        ],
      ),
    );
  }

  Widget _monthlyOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xff5B21B6), Color(0xff7C3AED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Overview",
              style: TextStyle(
                  color: _white, fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 12),
          _overviewRow("Avg. Attendance", "92.4%"),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
                value: 0.924,
                minHeight: 5,
                backgroundColor: _white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(_white)),
          ),
          const SizedBox(height: 12),
          _overviewRow("Total Hours", "1,247h"),
          const SizedBox(height: 12),
          _overviewRow("Overtime Hours", "23.5h"),
        ],
      ),
    );
  }

  Widget _overviewRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: _white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500)),
        Text(value,
            style: const TextStyle(
                color: _white, fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _attendanceCard(AttendanceRecord record) {
    Color statusColor;
    switch (record.locationStatus) {
      case "ON-SITE":
        statusColor = _green;
        break;
      case "REMOTE":
        statusColor = _teal;
        break;
      case "LATE":
        statusColor = _orange;
        break;
      case "ABSENT":
        statusColor = _red;
        break;
      default:
        statusColor = _textMid;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: record.avatarColor.withOpacity(0.1),
            child: Text(record.initials,
                style: TextStyle(
                    color: record.avatarColor, fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(record.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(record.role,
                    style: const TextStyle(fontSize: 12, color: _textMid)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(record.checkIn,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 13)),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(record.locationStatus,
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: statusColor)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}