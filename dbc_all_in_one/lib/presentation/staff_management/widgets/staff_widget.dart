import 'package:flutter/material.dart';
import '../staff_management.dart'; // Import models and constants

const _purple = Color(0xff6D28D9);
const _purpleLight = Color(0xffEDE9FE);
const _bg = Color(0xffF3F4F8);
const _white = Colors.white;
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _border = Color(0xffE5E7EB);
const _green = Color(0xff16A34A);
const _orange = Color(0xffD97706);
const _teal = Color(0xff0D9488);

class StaffTabWidget extends StatelessWidget {
  final List<StaffMember> staff;
  final VoidCallback onAddStaff;
  final Function(StaffMember) onStaffTap;
  final VoidCallback onHiringTap;
  final Widget Function(String, VoidCallback) purpleBtn;

  const StaffTabWidget({
    Key? key,
    required this.staff,
    required this.onAddStaff,
    required this.onStaffTap,
    required this.onHiringTap,
    required this.purpleBtn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text("Staff Directory",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: _textDark)),
            const Spacer(),
            purpleBtn("+ Add New Staff", onAddStaff),
          ]),
          const SizedBox(height: 4),
          const Text("Search by name or role...",
              style: TextStyle(fontSize: 13, color: _textMid)),
          const SizedBox(height: 18),
          // Stat cards
          Row(children: [
            _staffStatCard(
                icon: Icons.person_outline_rounded,
                iconColor: _purple,
                iconBg: _purpleLight,
                label: "Total Personnel",
                value: "${staff.length}",
                sub: "↑ +4 this month",
                subColor: _green),
            const SizedBox(width: 14),
            _staffStatCard(
                icon: Icons.schedule_rounded,
                iconColor: const Color(0xff7C3AED),
                iconBg: const Color(0xffEDE9FE),
                label: "Avg. Shift Duration",
                value: "7.8h",
                sub: "Standard baseline",
                subColor: _textMid),
            const SizedBox(width: 14),
            _staffStatCard(
                icon: Icons.calendar_today_rounded,
                iconColor: _orange,
                iconBg: const Color(0xffFFFBEB),
                label: "On Duty Today",
                value: "${staff.where((s) => s.status == "In Office").length}",
                sub: "12 pending shifts",
                subColor: _textMid),
          ]),
          const SizedBox(height: 20),
          // Staff grid
          LayoutBuilder(builder: (ctx, box) {
            int cols = (box.maxWidth / 170).floor().clamp(3, 6);
            const cardH = 148.0;
            int rows = ((staff.length + 1) / cols).ceil();
            return SizedBox(
              height: rows * (cardH + 12),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 170 / cardH,
                ),
                itemCount: staff.length + 1,
                itemBuilder: (ctx, i) {
                  if (i == staff.length) {
                    return _addStaffCard(onHiringTap);
                  }
                  final s = staff[i];
                  return _staffCard(s, () => onStaffTap(s));
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _staffStatCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    required String sub,
    required Color subColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(label,
                style: const TextStyle(fontSize: 11, color: _textMid)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _textDark)),
            const SizedBox(height: 2),
            Text(sub,
                style: TextStyle(fontSize: 10, color: subColor)),
          ],
        ),
      ),
    );
  }

  Widget _staffCard(StaffMember s, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: s.avatarColor.withOpacity(0.1),
                  child: Text(s.name[0],
                      style: TextStyle(
                          color: s.avatarColor, fontWeight: FontWeight.w600)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: s.status == "In Office"
                        ? _green.withOpacity(0.1)
                        : s.status == "Off Duty"
                            ? _orange.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(s.status,
                      style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: s.status == "In Office"
                              ? _green
                              : s.status == "Off Duty"
                                  ? _orange
                                  : Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(s.name,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textDark)),
            const SizedBox(height: 2),
            Text(s.role,
                style: const TextStyle(fontSize: 12, color: _textMid)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.schedule, size: 12, color: _textMid),
                const SizedBox(width: 4),
                Text(s.hours,
                    style: const TextStyle(fontSize: 11, color: _textMid)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _addStaffCard(VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _purpleLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _purple.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, size: 18, color: _purple),
            ),
            const SizedBox(height: 8),
            const Text("Hire New",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _purple)),
          ],
        ),
      ),
    );
  }
}