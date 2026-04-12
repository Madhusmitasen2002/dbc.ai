// security_history_widget.dart
// A fully standalone, reusable widget page for displaying security event history.
// Import and use anywhere: push as a route, embed in a sheet, or drop inline.

import 'package:flutter/material.dart';
import '../../../widgets/dbc_back_button.dart';
import 'security_event_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  PUBLIC ENTRY POINT — use this as a full page or inside a bottom sheet
// ─────────────────────────────────────────────────────────────────────────────

class SecurityHistoryPage extends StatelessWidget {
  final List<SecurityEvent> events;
  final VoidCallback? onClearAll;
  final ValueChanged<SecurityEvent>? onEventTap;

  /// Set [asPage] = true when pushing as a named route (adds Scaffold + AppBar).
  /// Set [asPage] = false when embedding inside a bottom sheet or another widget.
  final bool asPage;

  const SecurityHistoryPage({
    super.key,
    required this.events,
    this.onClearAll,
    this.onEventTap,
    this.asPage = true,
  });

  @override
  Widget build(BuildContext context) {
    final body = _SecurityHistoryBody(
      events: events,
      onClearAll: onClearAll,
      onEventTap: onEventTap,
    );

    if (!asPage) return body;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: const DBCBackButton(),
        title: const Text(
          'Security History',
          style: TextStyle(
              color: Color(0xFF1A1A1A),
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        actions: [
          if (onClearAll != null)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: onClearAll,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFF1F1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFFCDD2))),
                  child: const Row(mainAxisSize: MainAxisSize.min, children: [
                    Icon(Icons.delete_outline_rounded,
                        color: Color(0xFFEF4444), size: 13),
                    SizedBox(width: 4),
                    Text('Clear All',
                        style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ),
        ],
      ),
      body: body,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BODY — stateful core with filter tabs + grouped list
// ─────────────────────────────────────────────────────────────────────────────

class _SecurityHistoryBody extends StatefulWidget {
  final List<SecurityEvent> events;
  final VoidCallback? onClearAll;
  final ValueChanged<SecurityEvent>? onEventTap;

  const _SecurityHistoryBody({
    required this.events,
    this.onClearAll,
    this.onEventTap,
  });

  @override
  State<_SecurityHistoryBody> createState() => _SecurityHistoryBodyState();
}

class _SecurityHistoryBodyState extends State<_SecurityHistoryBody>
    with SingleTickerProviderStateMixin {
  static const _purple = Color(0xFF6B46C1);

  SecurityEventType? _activeFilter;
  late TabController _tabController;

  static const _filters = <SecurityEventType?>[
    null,
    SecurityEventType.person,
    SecurityEventType.vehicle,
    SecurityEventType.motion,
    SecurityEventType.alert,
    SecurityEventType.snapshot,
  ];
  static const _filterLabels = [
    'All',
    'Person',
    'Vehicle',
    'Motion',
    'Alert',
    'Snapshot',
  ];

  List<SecurityEvent> get _filtered => _activeFilter == null
      ? widget.events
      : widget.events.where((e) => e.type == _activeFilter).toList();

  Map<String, List<SecurityEvent>> get _grouped {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final result = <String, List<SecurityEvent>>{};
    for (final e in _filtered) {
      final d = DateTime(e.timestamp.year, e.timestamp.month, e.timestamp.day);
      final key = d == today
          ? 'Today'
          : d == yesterday
              ? 'Yesterday'
              : '${e.timestamp.day}/${e.timestamp.month}/${e.timestamp.year}';
      result.putIfAbsent(key, () => []).add(e);
    }
    return result;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _filters.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _activeFilter = _filters[_tabController.index]);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildStatsBar(),
      _buildFilterTabs(),
      const Divider(height: 1, color: Color(0xFFF0F0F0)),
      Expanded(child: _buildEventList()),
    ]);
  }

  // ── Stats ──────────────────────────────────────────────────────────────────
  Widget _buildStatsBar() {
    final counts = <SecurityEventType, int>{};
    for (final e in widget.events) {
      counts[e.type] = (counts[e.type] ?? 0) + 1;
    }

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              '${widget.events.length} Total Events',
              style: const TextStyle(
                  color: Color(0xFF1A1A1A),
                  fontSize: 20,
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 2),
            Text(
              '${widget.events.where((e) => !e.isResolved).length} unresolved',
              style: const TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
          ]),
        ),
        Row(
            children: [
          SecurityEventType.person,
          SecurityEventType.vehicle,
          SecurityEventType.motion,
          SecurityEventType.alert,
        ].map((t) => _StatChip(type: t, count: counts[t] ?? 0)).toList()),
      ]),
    );
  }

  // ── Filter tabs ────────────────────────────────────────────────────────────
  Widget _buildFilterTabs() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
      child: SizedBox(
        height: 34,
        child: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
              color: _purple, borderRadius: BorderRadius.circular(9)),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: const Color(0xFF9E9E9E),
          labelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          unselectedLabelStyle:
              const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          dividerColor: Colors.transparent,
          padding: EdgeInsets.zero,
          tabs: _filterLabels
              .map((l) => Tab(
                    height: 32,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(l),
                    ),
                  ))
              .toList(),
        ),
      ),
    );
  }

  // ── Event list ─────────────────────────────────────────────────────────────
  Widget _buildEventList() {
    final grouped = _grouped;
    if (grouped.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.history_toggle_off_rounded,
              color: Colors.grey.shade200, size: 52),
          const SizedBox(height: 12),
          const Text('No events found',
              style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 14)),
        ]),
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: grouped.entries.expand((entry) {
        return [
          _DateGroupHeader(label: entry.key, count: entry.value.length),
          ...entry.value.map((e) => _EventTile(
                event: e,
                onTap: widget.onEventTap != null
                    ? () => widget.onEventTap!(e)
                    : null,
              )),
        ];
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SUB-WIDGETS
// ─────────────────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final SecurityEventType type;
  final int count;
  const _StatChip({required this.type, required this.count});

  @override
  Widget build(BuildContext context) {
    final dummy = SecurityEvent(
      id: '',
      type: type,
      cameraName: '',
      zone: '',
      timestamp: DateTime.now(),
      description: '',
    );
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
              color: dummy.color.withOpacity(0.10), shape: BoxShape.circle),
          child: Icon(dummy.icon, color: dummy.color, size: 16),
        ),
        const SizedBox(height: 3),
        Text('$count',
            style: TextStyle(
                color: dummy.color, fontSize: 13, fontWeight: FontWeight.w800)),
        Text(dummy.typeLabel,
            style: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 9,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

class _DateGroupHeader extends StatelessWidget {
  final String label;
  final int count;
  const _DateGroupHeader({required this.label, required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
      child: Row(children: [
        Text(label,
            style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
          decoration: BoxDecoration(
              color: const Color(0xFFF0EFF8),
              borderRadius: BorderRadius.circular(5)),
          child: Text('$count',
              style: const TextStyle(
                  color: Color(0xFF6B46C1),
                  fontSize: 10,
                  fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: const Color(0xFFF0F0F0))),
      ]),
    );
  }
}

class _EventTile extends StatelessWidget {
  final SecurityEvent event;
  final VoidCallback? onTap;
  const _EventTile({required this.event, this.onTap});

  String _timeLabel() {
    final h = event.timestamp.hour.toString().padLeft(2, '0');
    final m = event.timestamp.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 3, 12, 3),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        decoration: BoxDecoration(
            color: event.isResolved ? const Color(0xFFFAFAFA) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: event.isResolved
                    ? const Color(0xFFF0F0F0)
                    : event.color.withOpacity(0.15)),
            boxShadow: event.isResolved
                ? []
                : [
                    BoxShadow(
                        color: event.color.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]),
        child: Row(children: [
          // Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
                color: event.color.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12)),
            child: Icon(event.icon, color: event.color, size: 19),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _TypePill(event: event),
                const SizedBox(width: 6),
                Expanded(
                    child: Text(event.cameraName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 11,
                            fontWeight: FontWeight.w500))),
              ]),
              const SizedBox(height: 4),
              Text(event.description,
                  style: const TextStyle(
                      color: Color(0xFF333333),
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
              const SizedBox(height: 2),
              Text(event.zone,
                  style:
                      const TextStyle(color: Color(0xFFAAAAAA), fontSize: 10)),
            ]),
          ),
          const SizedBox(width: 10),
          // Right column
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(_timeLabel(),
                style: const TextStyle(
                    color: Color(0xFFAAAAAA),
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600)),
            if (event.confidence != null) ...[
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                    color: event.color.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(5)),
                child: Text('${(event.confidence! * 100).toInt()}%',
                    style: TextStyle(
                        color: event.color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700)),
              ),
            ],
            if (event.isResolved) ...[
              const SizedBox(height: 5),
              const Row(children: [
                Icon(Icons.check_circle_outline_rounded,
                    color: Color(0xFF10B981), size: 13),
                SizedBox(width: 3),
                Text('Resolved',
                    style: TextStyle(
                        color: Color(0xFF10B981),
                        fontSize: 9,
                        fontWeight: FontWeight.w600)),
              ]),
            ],
          ]),
        ]),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  final SecurityEvent event;
  const _TypePill({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
          color: event.color.withOpacity(0.10),
          borderRadius: BorderRadius.circular(5)),
      child: Text(event.typeLabel,
          style: TextStyle(
              color: event.color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3)),
    );
  }
}
