import 'package:flutter/material.dart';

// ── Palette ───────────────────────────────────────────────────────────────────
const _purple = Color(0xff6D28D9);
const _purpleLight = Color(0xffEDE9FE);
const _purpleMid = Color(0xffA78BFA);
const _white = Colors.white;
const _pageBg = Color(0xffF5F5F7);
const _cardBg = Color(0xffFFFFFF);
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _textLight = Color(0xff9CA3AF);
const _border = Color(0xffE5E7EB);
const _green = Color(0xff16A34A);
const _orange = Color(0xffD97706);
const _orangeBg = Color(0xffFEF3C7);
const _red = Color(0xffDC2626);
const _redBg = Color(0xffFEE2E2);

// ── Order Model ───────────────────────────────────────────────────────────────
enum OrderPriority { high, standard, low }

enum OrderStatus { processing, shipped, delivered, cancelled, pending }

class ActiveOrder {
  final String id;
  final String client;
  final String clientInitials;
  final Color clientColor;
  final String placementDate;
  final OrderPriority priority;
  final OrderStatus status;
  final String amount;

  const ActiveOrder({
    required this.id,
    required this.client,
    required this.clientInitials,
    required this.clientColor,
    required this.placementDate,
    required this.priority,
    required this.status,
    required this.amount,
  });
}

// ── Sample Data ───────────────────────────────────────────────────────────────
const _sampleOrders = [
  ActiveOrder(
    id: '#SV-9021',
    client: 'Luxe Boutique Co.',
    clientInitials: 'LB',
    clientColor: Color(0xff6D28D9),
    placementDate: 'Oct 24, 2023 · 09:12 AM',
    priority: OrderPriority.high,
    status: OrderStatus.processing,
    amount: '\$12,400.00',
  ),
  ActiveOrder(
    id: '#SV-9018',
    client: 'Artisan Alliance',
    clientInitials: 'AA',
    clientColor: Color(0xff0D9488),
    placementDate: 'Oct 24, 2023 · 08:45 AM',
    priority: OrderPriority.standard,
    status: OrderStatus.shipped,
    amount: '\$8,120.50',
  ),
  ActiveOrder(
    id: '#SV-9015',
    client: 'Metro Supply Ltd.',
    clientInitials: 'MS',
    clientColor: Color(0xff2563EB),
    placementDate: 'Oct 23, 2023 · 04:30 PM',
    priority: OrderPriority.low,
    status: OrderStatus.delivered,
    amount: '\$3,750.00',
  ),
  ActiveOrder(
    id: '#SV-9012',
    client: 'Pinnacle Foods',
    clientInitials: 'PF',
    clientColor: Color(0xffD97706),
    placementDate: 'Oct 23, 2023 · 11:20 AM',
    priority: OrderPriority.high,
    status: OrderStatus.processing,
    amount: '\$21,900.00',
  ),
  ActiveOrder(
    id: '#SV-9009',
    client: 'Urban Roots Co.',
    clientInitials: 'UR',
    clientColor: Color(0xff16A34A),
    placementDate: 'Oct 22, 2023 · 03:15 PM',
    priority: OrderPriority.standard,
    status: OrderStatus.pending,
    amount: '\$5,680.00',
  ),
];

// ── Bar chart data (hourly throughput) ────────────────────────────────────────
const _barData = [
  (label: '08:00 AM', value: 0.25),
  (label: '', value: 0.30),
  (label: '', value: 0.38),
  (label: '12:00 PM', value: 0.55),
  (label: '', value: 0.60),
  (label: '', value: 0.72),
  (label: '04:00 PM', value: 0.65),
  (label: '', value: 0.78),
  (label: '', value: 0.85),
  (label: 'NOW', value: 1.00),
];

// ─────────────────────────────────────────────────────────────────────────────
//  ActiveOrdersPage
// ─────────────────────────────────────────────────────────────────────────────
class ActiveOrdersPage extends StatefulWidget {
  const ActiveOrdersPage({super.key});

  @override
  State<ActiveOrdersPage> createState() => _ActiveOrdersPageState();
}

class _ActiveOrdersPageState extends State<ActiveOrdersPage> {
  String _sortField = 'id';
  bool _sortAsc = true;
  String _filterStatus = 'All';

  static const _statusFilters = [
    'All',
    'Processing',
    'Shipped',
    'Delivered',
    'Pending',
    'Cancelled'
  ];

  List<ActiveOrder> get _filteredOrders {
    var list = List<ActiveOrder>.from(_sampleOrders);
    if (_filterStatus != 'All') {
      list = list
          .where(
              (o) => o.status.name.toLowerCase() == _filterStatus.toLowerCase())
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 700;
        return Scaffold(
          backgroundColor: _pageBg,
          body: SafeArea(
            child: Column(
              children: [
                // ── Top nav ───────────────────────────────────────────
                _TopNav(isWide: isWide),
                // ── Scrollable body ───────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isWide ? 24 : 16,
                      vertical: 16,
                    ),
                    child: isWide ? _wideLayout() : _narrowLayout(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Wide (≥700px): chart + stat cards side-by-side ───────────────────────
  Widget _wideLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live throughput chart
            Expanded(flex: 5, child: _ThroughputCard()),
            const SizedBox(width: 14),
            // Stat cards stacked
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  const _TotalValueCard(),
                  const SizedBox(height: 14),
                  const _FulfillmentCard(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        _OrderManagementCard(
          orders: _filteredOrders,
          filterStatus: _filterStatus,
          statusFilters: _statusFilters,
          onFilterChanged: (s) => setState(() => _filterStatus = s),
          isWide: true,
        ),
      ],
    );
  }

  // ── Narrow (<700px): stacked ──────────────────────────────────────────────
  Widget _narrowLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ThroughputCard(),
        const SizedBox(height: 12),
        Row(
          children: const [
            Expanded(child: _TotalValueCard()),
            SizedBox(width: 12),
            Expanded(child: _FulfillmentCard()),
          ],
        ),
        const SizedBox(height: 16),
        _OrderManagementCard(
          orders: _filteredOrders,
          filterStatus: _filterStatus,
          statusFilters: _statusFilters,
          onFilterChanged: (s) => setState(() => _filterStatus = s),
          isWide: false,
        ),
      ],
    );
  }
}

// ── Top Navigation ────────────────────────────────────────────────────────────
class _TopNav extends StatelessWidget {
  final bool isWide;
  const _TopNav({required this.isWide});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _pageBg,
      padding: EdgeInsets.fromLTRB(isWide ? 24 : 16, 10, isWide ? 24 : 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: const Text(
                  'WORKSPACE',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: _textLight,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(Icons.chevron_right, size: 14, color: _textLight),
              ),
              const Text(
                'ACTIVE ORDERS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _purple,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Title row + action buttons
          Row(
            children: [
              // Back button
              GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 34,
                  height: 34,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: _border),
                  ),
                  child: const Icon(Icons.arrow_back_rounded,
                      size: 18, color: _textDark),
                ),
              ),
              const Expanded(
                child: Text(
                  'Active Orders',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _textDark,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              // Filter button
              _ActionButton(
                icon: Icons.tune_rounded,
                label: 'Filter',
                onTap: () {},
              ),
              const SizedBox(width: 8),
              // Export button
              _ActionButton(
                icon: Icons.upload_outlined,
                label: 'Export',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _ActionButton(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: _border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: _textDark),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Live Throughput Card ──────────────────────────────────────────────────────
class _ThroughputCard extends StatelessWidget {
  const _ThroughputCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          const Text(
            'Live Throughput',
            style: TextStyle(
                fontSize: 12, color: _textMid, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          // Count + badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                '24',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _purpleLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.arrow_upward_rounded, size: 11, color: _purple),
                    SizedBox(width: 3),
                    Text(
                      '+8 today',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _purple,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Bar chart
          _BarChart(data: _barData),
        ],
      ),
    );
  }
}

class _BarChart extends StatelessWidget {
  final List<({String label, double value})> data;
  const _BarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final barW =
            (constraints.maxWidth - (data.length - 1) * 6) / data.length;
        const chartH = 100.0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bars
            SizedBox(
              height: chartH,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(data.length, (i) {
                  final isLast = i == data.length - 1;
                  final frac = data[i].value;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      AnimatedContainer(
                        duration: Duration(milliseconds: 400 + i * 30),
                        curve: Curves.easeOut,
                        width: barW,
                        height: chartH * frac,
                        decoration: BoxDecoration(
                          color: isLast ? _purple : _purpleLight,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(6)),
                        ),
                      ),
                      if (i < data.length - 1) const SizedBox(width: 6),
                    ],
                  );
                }),
              ),
            ),
            const SizedBox(height: 6),
            // X-axis labels
            SizedBox(
              height: 14,
              child: Row(
                children: List.generate(data.length, (i) {
                  return SizedBox(
                    width: i < data.length - 1 ? barW + 6 : barW,
                    child: data[i].label.isEmpty
                        ? const SizedBox()
                        : Text(
                            data[i].label,
                            style: const TextStyle(
                              fontSize: 9,
                              color: _textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Total Value Card ──────────────────────────────────────────────────────────
class _TotalValueCard extends StatelessWidget {
  const _TotalValueCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff5B21B6), _purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total Value',
            style: TextStyle(
                fontSize: 11,
                color: Color(0xffC4B5FD),
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          const Text(
            '\$142,850.00',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.circle, size: 7, color: Color(0xff86EFAC)),
                SizedBox(width: 5),
                Text(
                  'Enterprise Tier',
                  style: TextStyle(
                      fontSize: 11, color: _white, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fulfillment Rate Card ─────────────────────────────────────────────────────
class _FulfillmentCard extends StatelessWidget {
  const _FulfillmentCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fulfillment Rate',
            style: TextStyle(
                fontSize: 11, color: _textMid, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          const Text(
            '98.4%',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: _textDark,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.984,
              minHeight: 6,
              backgroundColor: _purpleLight,
              valueColor: const AlwaysStoppedAnimation<Color>(_purple),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Order Management Card ─────────────────────────────────────────────────────
class _OrderManagementCard extends StatelessWidget {
  final List<ActiveOrder> orders;
  final String filterStatus;
  final List<String> statusFilters;
  final ValueChanged<String> onFilterChanged;
  final bool isWide;

  const _OrderManagementCard({
    required this.orders,
    required this.filterStatus,
    required this.statusFilters,
    required this.onFilterChanged,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
            child: Row(
              children: [
                const Text(
                  'Order Management',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                const Spacer(),
                Icon(Icons.more_horiz_rounded, color: _textMid, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Filter chips
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: statusFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, i) {
                final s = statusFilters[i];
                final isActive = s == filterStatus;
                return GestureDetector(
                  onTap: () => onFilterChanged(s),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive ? _purple : _pageBg,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isActive ? _purple : _border,
                      ),
                    ),
                    child: Text(
                      s,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: isActive ? _white : _textMid,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Column headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: isWide ? _wideHeader() : _narrowHeader(),
          ),
          const Divider(height: 1, color: _border),

          // Rows
          if (orders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Text('No orders match this filter.',
                    style: TextStyle(color: _textMid, fontSize: 13)),
              ),
            )
          else
            ...orders.map((o) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: isWide ? _wideRow(o) : _narrowRow(o),
                    ),
                    const Divider(height: 1, color: _border),
                  ],
                )),

          const SizedBox(height: 8),
        ],
      ),
    );
  }

  // ── Wide table ────────────────────────────────────────────────────────────
  Widget _wideHeader() {
    const s = TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _textLight,
        letterSpacing: 0.4);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('ORDER ID', style: s)),
          Expanded(flex: 3, child: Text('CLIENT', style: s)),
          Expanded(flex: 3, child: Text('PLACEMENT DATE', style: s)),
          SizedBox(width: 90, child: Text('PRIORITY', style: s)),
          Expanded(flex: 3, child: Text('STATUS', style: s)),
          SizedBox(
              width: 90,
              child: Text('AMOUNT', style: s, textAlign: TextAlign.right)),
        ],
      ),
    );
  }

  Widget _wideRow(ActiveOrder o) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(o.id,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: _purple)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                _ClientAvatar(initials: o.clientInitials, color: o.clientColor),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(o.client,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _textDark)),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(o.placementDate,
                style: const TextStyle(fontSize: 11, color: _textMid)),
          ),
          SizedBox(width: 90, child: _PriorityBadge(priority: o.priority)),
          Expanded(flex: 3, child: _StatusChip(status: o.status)),
          SizedBox(
            width: 90,
            child: Text(o.amount,
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textDark)),
          ),
        ],
      ),
    );
  }

  // ── Narrow card rows ──────────────────────────────────────────────────────
  Widget _narrowHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text('ORDER ID',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _textLight,
                  letterSpacing: 0.4)),
          Spacer(),
          Text('AMOUNT',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: _textLight,
                  letterSpacing: 0.4)),
        ],
      ),
    );
  }

  Widget _narrowRow(ActiveOrder o) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ClientAvatar(initials: o.clientInitials, color: o.clientColor),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(o.id,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _purple)),
                    const SizedBox(width: 6),
                    _PriorityBadge(priority: o.priority),
                  ],
                ),
                const SizedBox(height: 2),
                Text(o.client,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _textDark)),
                const SizedBox(height: 2),
                Text(o.placementDate,
                    style: const TextStyle(fontSize: 10, color: _textMid)),
                const SizedBox(height: 6),
                _StatusChip(status: o.status),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(o.amount,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w700, color: _textDark)),
        ],
      ),
    );
  }
}

// ── Shared small widgets ──────────────────────────────────────────────────────
class _ClientAvatar extends StatelessWidget {
  final String initials;
  final Color color;
  const _ClientAvatar({required this.initials, required this.color});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: color.withOpacity(0.12),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final OrderPriority priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    String label;
    switch (priority) {
      case OrderPriority.high:
        bg = _orangeBg;
        fg = _orange;
        label = 'HIGH';
        break;
      case OrderPriority.standard:
        bg = const Color(0xffF3F4F6);
        fg = _textMid;
        label = 'STANDARD';
        break;
      case OrderPriority.low:
        bg = const Color(0xffDCFCE7);
        fg = _green;
        label = 'LOW';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: fg,
            letterSpacing: 0.4),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color dot;
    String label;
    switch (status) {
      case OrderStatus.processing:
        dot = _purple;
        label = 'Processing';
        break;
      case OrderStatus.shipped:
        dot = _orange;
        label = 'Shipped';
        break;
      case OrderStatus.delivered:
        dot = _green;
        label = 'Delivered';
        break;
      case OrderStatus.cancelled:
        dot = _red;
        label = 'Cancelled';
        break;
      case OrderStatus.pending:
        dot = _textLight;
        label = 'Pending';
        break;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: _textDark),
        ),
      ],
    );
  }
}
