import 'package:flutter/material.dart';
import '../staff_management.dart';

const _purple = Color(0xff6D28D9);
const _purpleLight = Color(0xffEDE9FE);
const _white = Colors.white;
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _border = Color(0xffE5E7EB);
const _green = Color(0xff16A34A);
const _orange = Color(0xffD97706);

class HiringTabWidget extends StatefulWidget {
  final List<JobPosition> jobs;
  final List<Candidate> candidates;
  final TabController subTabController;
  final VoidCallback onAddPosition;
  final Function(JobPosition) onJobTap;
  final Function(Candidate, String) onCandidateTap;
  final Widget Function(String, VoidCallback) purpleBtn;
  final Widget Function(IconData, String, VoidCallback) outlineBtn;
  final Function(String) onSnack;

  const HiringTabWidget({
    Key? key,
    required this.jobs,
    required this.candidates,
    required this.subTabController,
    required this.onAddPosition,
    required this.onJobTap,
    required this.onCandidateTap,
    required this.purpleBtn,
    required this.outlineBtn,
    required this.onSnack,
  }) : super(key: key);

  @override
  State<HiringTabWidget> createState() => _HiringTabWidgetState();
}

class _HiringTabWidgetState extends State<HiringTabWidget> {
  int _appFilter = 0;

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.subTabController,
      children: [
        _jobPositionsView(),
        _applicationsView(),
      ],
    );
  }

  Widget _jobPositionsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Active Roles",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textDark)),
                  Text("Manage and monitor your current recruitment pipelines.",
                      style: TextStyle(fontSize: 12, color: _textMid)),
                ]),
            const Spacer(),
            widget.outlineBtn(Icons.filter_list, "Filter",
                () => widget.onSnack("Filter coming soon")),
            const SizedBox(width: 8),
            widget.outlineBtn(Icons.sort, "Sort",
                () => widget.onSnack("Sort coming soon")),
          ]),
          const SizedBox(height: 18),
          ...widget.jobs.map((job) => _jobCard(job)),
          const SizedBox(height: 20),
          Center(
            child: widget.purpleBtn("+ Add New Position", widget.onAddPosition),
          ),
        ],
      ),
    );
  }

  Widget _jobCard(JobPosition job) {
    return GestureDetector(
      onTap: () => widget.onJobTap(job),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: job.iconBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(job.icon, size: 20, color: _purple),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: _textDark)),
                      Text(job.department,
                          style: const TextStyle(
                              fontSize: 12, color: _textMid)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: job.status == "ACTIVE"
                        ? _green.withOpacity(0.1)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(job.status,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: job.status == "ACTIVE" ? _green : Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text("${job.applications} applications",
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: _textMid)),
                const Spacer(),
                Text("Posted ${job.postedDate}",
                    style: const TextStyle(fontSize: 11, color: _textMid)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _applicationsView() {
    final filters = ["All", "Pending (12)", "Reviewing (5)", "Shortlisted (8)"];
    final filtered = _appFilter == 0
        ? widget.candidates
        : widget.candidates.where((c) {
            if (_appFilter == 1) return c.status == "Pending";
            if (_appFilter == 2) return c.status == "Reviewing";
            return c.status == "Shortlisted";
          }).toList();

    return StatefulBuilder(builder: (ctx, setS) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Review Candidates",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: _textDark)),
                  Text("Manage and schedule interviews for open positions.",
                      style: TextStyle(fontSize: 12, color: _textMid)),
                ]),
            const Spacer(),
            widget.outlineBtn(Icons.filter_alt_outlined, "Advanced Filter",
                () => widget.onSnack("Advanced filter coming soon")),
            const SizedBox(width: 8),
            widget.purpleBtn("↑ Export List",
                () => widget.onSnack("Exporting candidate list...")),
          ]),
          const SizedBox(height: 14),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(filters.length, (i) {
                final sel = _appFilter == i;
                return GestureDetector(
                  onTap: () => setS(() => _appFilter = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? _purple : _white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? _purple : _border),
                    ),
                    child: Text(filters[i],
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: sel ? _white : _textMid)),
                  ),
                );
              })),
          const SizedBox(height: 16),
          ...filtered.map((c) => _candidateCard(c)),
        ]),
      );
    });
  }

  Widget _candidateCard(Candidate c) {
    return GestureDetector(
      onTap: () => widget.onCandidateTap(c, "view"),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: c.avatarColor.withOpacity(0.1),
              child: Text(c.name[0],
                  style: TextStyle(
                      color: c.avatarColor, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text("${c.experience} years • ${c.company}",
                      style: const TextStyle(fontSize: 12, color: _textMid)),
                  Text(c.email,
                      style: const TextStyle(fontSize: 11, color: _textMid)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.status == "Shortlisted"
                        ? _green.withOpacity(0.1)
                        : c.status == "Reviewing"
                            ? _orange.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(c.status,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: c.status == "Shortlisted"
                              ? _green
                              : c.status == "Reviewing"
                                  ? _orange
                                  : Colors.grey)),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      onPressed: () => widget.onCandidateTap(c, "accept"),
                      color: _green,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel_outlined, size: 18),
                      onPressed: () => widget.onCandidateTap(c, "reject"),
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}