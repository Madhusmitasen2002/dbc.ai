import 'package:flutter/material.dart';
import '../staff_management.dart';

const _purple = Color(0xff6D28D9);
const _white = Colors.white;
const _textDark = Color(0xff111827);
const _textMid = Color(0xff6B7280);
const _border = Color(0xffE5E7EB);

class PayrollTabWidget extends StatelessWidget {
  final List<PayrollItem> payroll;
  final TabController subTabController;
  final VoidCallback onAddPayroll;
  final Widget Function(String, VoidCallback) purpleBtn;
  final Function(String) onSnack;

  const PayrollTabWidget({
    Key? key,
    required this.payroll,
    required this.subTabController,
    required this.onAddPayroll,
    required this.purpleBtn,
    required this.onSnack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 🔹 HEADER
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
          child: Row(
            children: [
              const Text(
                "Staff Payroll",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: _textDark,
                ),
              ),
              const Spacer(),
              purpleBtn("Add Payroll", onAddPayroll),
            ],
          ),
        ),

        // 🔹 SUMMARY CARDS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              _summaryCard("Total", "₹1,20,000", Colors.blue),
              _summaryCard("Paid", "₹80,000", Colors.green),
              _summaryCard("Pending", "₹40,000", Colors.orange),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // 🔹 IMPROVED TAB BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TabBar(
              controller: subTabController,
              indicator: BoxDecoration(
                color: _purple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              labelColor: _purple,
              unselectedLabelColor: _textMid,
              tabs: const [
                Tab(text: "Payroll"),
                Tab(text: "History"),
              ],
            ),
          ),
        ),

        const SizedBox(height: 10),

        // 🔹 CONTENT
        Expanded(
          child: TabBarView(
            controller: subTabController,
            children: [
              _modernPayrollList(),
              _payrollHistoryView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(String title, String amount, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(fontSize: 12, color: Colors.black54)),
            const SizedBox(height: 6),
            Text(amount,
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _modernPayrollList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: payroll.length,
      itemBuilder: (context, index) {
        final item = payroll[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: item.avatarColor.withOpacity(0.1),
                child: Icon(Icons.person, color: item.avatarColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(item.role,
                        style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item.amount,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Text(item.status,
                      style: TextStyle(
                          fontSize: 12,
                          color: item.status == "Paid" ? Colors.green : Colors.orange)),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _payrollHistoryView() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: payroll.length,
      itemBuilder: (context, index) {
        final item = payroll[index];
        final paymentDate = DateTime(2023, 10, 15 + index);
        final transactionId = "TXN${(1000 + index).toString().padLeft(4, '0')}";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: item.avatarColor.withOpacity(0.1),
                    child: Icon(Icons.receipt_long, color: item.avatarColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        Text("${item.role} • ${paymentDate.day} ${_getMonthName(paymentDate.month)} ${paymentDate.year}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(item.amount,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(item.status,
                          style: TextStyle(
                              fontSize: 12,
                              color: item.status == "Paid" ? Colors.green : Colors.orange)),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Transaction ID: $transactionId",
                        style: const TextStyle(fontSize: 11, color: _textMid)),
                    Text("Method: Bank Transfer",
                        style: const TextStyle(fontSize: 11, color: _textMid)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
}