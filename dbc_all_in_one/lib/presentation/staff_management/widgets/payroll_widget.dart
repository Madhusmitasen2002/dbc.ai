import 'package:flutter/material.dart';
import '../staff_management.dart';

// ── Palette ──────────────────────────────────────────────────────────────────
const _purple = Color(0xff6D28D9);
const _purpleLight = Color(0xff7C3AED);
const _white = Colors.white;
const _bg = Color(0xffF9FAFB);
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _textLight = Color(0xff9CA3AF);
const _border = Color(0xffE5E7EB);
const _green = Color(0xff059669);
const _orange = Color(0xffD97706);
const _greenBg = Color(0xffDCFCE7);
const _orangeBg = Color(0xffFEF3C7);

class PayrollTabWidget extends StatefulWidget {
  final List<PayrollItem> payroll;
  final TabController subTabController;
  final VoidCallback onAddPayroll;
  final Widget Function(String, VoidCallback) purpleBtn;
  final Function(String) onSnack;

  const PayrollTabWidget({
    super.key,
    required this.payroll,
    required this.subTabController,
    required this.onAddPayroll,
    required this.purpleBtn,
    required this.onSnack,
  });

  @override
  State<PayrollTabWidget> createState() => _PayrollTabWidgetState();
}

class _PayrollTabWidgetState extends State<PayrollTabWidget> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(onAddPayroll: widget.onAddPayroll),
              const _BudgetCard(),
              const _MetricRow(),
            ],
          ),
        ),
      ],
      body: Column(
        children: [
          _SubTabBar(controller: widget.subTabController),
          Expanded(
            child: TabBarView(
              controller: widget.subTabController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _PayrollList(payroll: widget.payroll, onSnack: widget.onSnack),
                _HistoryList(payroll: widget.payroll),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  final VoidCallback onAddPayroll;
  const _Header({required this.onAddPayroll});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 16, 4),
      child: Row(
        children: [
          // Title block
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Staff Payroll',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                    letterSpacing: -0.2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Manage organizational financial flows',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: _textMid,
                  ),
                ),
              ],
            ),
          ),

          // Icon buttons
          _IconBtn(
            icon: Icons.search_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 4),
          _IconBtn(
            icon: Icons.refresh_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 10),

          // Add Payroll button
          GestureDetector(
            onTap: onAddPayroll,
            child: Container(
              height: 34,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: _purple,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add, color: _white, size: 16),
                  SizedBox(width: 5),
                  Text(
                    'Add Payroll',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Icon(icon, color: _textMid, size: 19),
      ),
    );
  }
}

// ── Compact Summary Banner (Budget + Metrics in one tight row) ────────────────
class _BudgetCard extends StatelessWidget {
  const _BudgetCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_purple, _purpleLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Left: label + big amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'QUARTERLY BUDGET',
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffC4B5FD),
                    letterSpacing: 0.7,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  '\$120,000',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: _white,
                    letterSpacing: -0.5,
                    height: 1.1,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Divider
            Container(width: 1, height: 36, color: Colors.white24),
            const SizedBox(width: 16),
            // Stats
            _CompactStat(label: 'Used', value: '67.5%'),
            const SizedBox(width: 14),
            Container(width: 1, height: 28, color: Colors.white24),
            const SizedBox(width: 14),
            _CompactStat(label: 'Left', value: '\$40k'),
          ],
        ),
      ),
    );
  }
}

class _CompactStat extends StatelessWidget {
  final String label;
  final String value;
  const _CompactStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 9,
                color: Color(0xffC4B5FD),
                fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: _white)),
      ],
    );
  }
}

// ── Compact Metric Row ────────────────────────────────────────────────────────
class _MetricRow extends StatelessWidget {
  const _MetricRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Row(
        children: [
          Expanded(
              child: _CompactMetricCard(
            label: 'Paid Volume',
            value: '\$80,000',
            icon: Icons.check_circle_outline_rounded,
            iconColor: _green,
          )),
          const SizedBox(width: 8),
          Expanded(
              child: _CompactMetricCard(
            label: 'Pending Release',
            value: '\$40,000',
            icon: Icons.schedule_rounded,
            iconColor: _orange,
          )),
        ],
      ),
    );
  }
}

class _CompactMetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  const _CompactMetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: _textMid)),
              const SizedBox(height: 1),
              Text(value,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      letterSpacing: -0.3)),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Sub-Tab Bar ───────────────────────────────────────────────────────────────
class _SubTabBar extends StatefulWidget {
  final TabController controller;
  const _SubTabBar({required this.controller});

  @override
  State<_SubTabBar> createState() => _SubTabBarState();
}

class _SubTabBarState extends State<_SubTabBar> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTabChange);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTabChange);
    super.dispose();
  }

  void _onTabChange() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _border, width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: Row(
        children: [
          _TabItem(
            label: 'Payroll',
            isActive: widget.controller.index == 0,
            onTap: () => widget.controller.animateTo(0),
          ),
          const SizedBox(width: 24),
          _TabItem(
            label: 'History',
            isActive: widget.controller.index == 1,
            onTap: () => widget.controller.animateTo(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabItem(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? _textDark : _textLight,
              ),
            ),
            if (isActive) ...[
              const SizedBox(height: 6),
              Container(
                height: 2.5,
                width: 28,
                decoration: BoxDecoration(
                  color: _purple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Payroll List ──────────────────────────────────────────────────────────────
class _PayrollList extends StatelessWidget {
  final List<PayrollItem> payroll;
  final Function(String) onSnack;
  const _PayrollList({required this.payroll, required this.onSnack});

  static const _methods = [
    'Wire Transfer',
    'ACH Direct',
    'Blockchain Settlement'
  ];
  static const _dates = ['Oct 24, 2023', 'Processing Queue', 'Oct 23, 2023'];

  @override
  Widget build(BuildContext context) {
    if (payroll.isEmpty) {
      return const Center(
        child: Text(
          'No payroll items',
          style: TextStyle(fontSize: 13, color: _textMid),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      primary: false,
      itemCount: payroll.length + 1,
      itemBuilder: (context, index) {
        // Section header
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Disbursements',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                GestureDetector(
                  onTap: () => onSnack('View Audit Log'),
                  child: const Text(
                    'View Audit Log →',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _purple,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final i = index - 1;
        final item = payroll[i];
        final method = _methods[i % _methods.length];
        final date = _dates[i % _dates.length];
        final isPending = date == 'Processing Queue';

        return _DisbursementCard(
          item: item,
          method: method,
          date: date,
          isPending: isPending,
        );
      },
    );
  }
}

class _DisbursementCard extends StatelessWidget {
  final PayrollItem item;
  final String method;
  final String date;
  final bool isPending;
  const _DisbursementCard({
    required this.item,
    required this.method,
    required this.date,
    required this.isPending,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: avatar / name / amount / badge ──
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _Avatar(name: item.name, color: item.avatarColor),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.role,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: _textMid,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.amount,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _StatusBadge(isPending: isPending),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ── Payment method row ──
          _MetaRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Payment Method',
            value: method,
            valueColor: _orange,
          ),
          const SizedBox(height: 7),

          // ── Date row ──
          _MetaRow(
            icon: Icons.calendar_today_outlined,
            label: isPending ? 'Status Update' : 'Released On',
            value: date,
            valueColor: _textDark,
          ),
        ],
      ),
    );
  }
}

// ── History List ──────────────────────────────────────────────────────────────
class _HistoryList extends StatelessWidget {
  final List<PayrollItem> payroll;
  const _HistoryList({required this.payroll});

  static String _monthName(int m) => const [
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
      ][m - 1];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
      primary: false,
      itemCount: payroll.length,
      itemBuilder: (context, index) {
        final item = payroll[index];
        final date = DateTime(2023, 10, 15 + index);
        final txnId = 'TXN${(1000 + index).toString().padLeft(4, '0')}';

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _border, width: 0.8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row ──
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _Avatar(name: item.name, color: item.avatarColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${item.role} • ${date.day} ${_monthName(date.month)} ${date.year}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: _textMid,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.amount,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const _StatusBadge(isPending: false),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // ── Transaction footer ──
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xffF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction ID: $txnId',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _textMid,
                      ),
                    ),
                    const Text(
                      'Method: Bank Transfer',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _textMid,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────
class _Avatar extends StatelessWidget {
  final String name;
  final Color color;
  const _Avatar({required this.name, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: color.withOpacity(0.15),
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool isPending;
  const _StatusBadge({required this.isPending});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: isPending ? _orangeBg : _greenBg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        isPending ? 'PENDING' : 'PAID',
        style: TextStyle(
          fontSize: 8,
          fontWeight: FontWeight.w700,
          color: isPending ? _orange : _green,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  const _MetaRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: _textMid),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: _textMid,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
