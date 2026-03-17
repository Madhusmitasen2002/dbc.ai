import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../services/invoicing_service.dart';

/// Call this from anywhere:
/// `showCreateInvoiceDialog(context);`
void showCreateInvoiceDialog(BuildContext context) {
  final customerNameController = TextEditingController();
  final customerEmailController = TextEditingController();
  final notesController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.receipt_long, color: Color(0xFF10B981)),
          SizedBox(width: 2.w),
          Text('Create Invoice', style: TextStyle(fontSize: 16.sp)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person)),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: customerEmailController,
              decoration: const InputDecoration(
                  labelText: 'Customer Email (Optional)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email)),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                  labelText: 'Notes',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description)),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (customerNameController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Please enter customer name')));
              return;
            }
            try {
              await InvoicingService().createInvoiceFromTemplate(
                templateId: 'default',
                customerName: customerNameController.text,
                customerEmail: customerEmailController.text.isEmpty
                    ? null
                    : customerEmailController.text,
                dueDate: DateTime.now().add(const Duration(days: 30)),
                notes: notesController.text.isEmpty
                    ? null
                    : notesController.text,
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Invoice created successfully!'),
                  backgroundColor: Color(0xFF10B981)));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error creating invoice: $e')));
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981)),
          child: const Text('Create'),
        ),
      ],
    ),
  );
}