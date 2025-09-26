import 'package:flutter/material.dart';


enum InvoiceAction { share, remindClient, editReceivable, deleteInvoice, cancelInvoice, editInvoice }

class InvoiceActionsMenu extends StatelessWidget {
  final String status;
  final void Function(InvoiceAction) onSelected;

  const InvoiceActionsMenu({
    super.key,
    required this.status,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final lowerStatus = status.toLowerCase();

    return PopupMenuButton<InvoiceAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: onSelected,
      itemBuilder: (context) {
        final List<PopupMenuEntry<InvoiceAction>> items = [
          const PopupMenuItem(
            value: InvoiceAction.share,
            child: Row(
              children: [
                Icon(Icons.share, size: 20),
                SizedBox(width: 8),
                Text("Share Invoice"),
              ],
            ),
          ),
        ];

        if (lowerStatus == 'pending') {
          items.add(
            const PopupMenuItem(
              value: InvoiceAction.remindClient,
              child: Row(
                children: [
                  Icon(Icons.notifications_active, size: 20),
                  SizedBox(width: 8),
                  Text("Remind Client"),
                ],
              ),
            ),
          );
        }

        if (lowerStatus == 'draft') {
          items.addAll([
            const PopupMenuItem(
              value: InvoiceAction.editReceivable,
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20),
                  SizedBox(width: 8),
                  Text("Edit Receivable Amount"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: InvoiceAction.editInvoice,
              child: Row(
                children: [
                  Icon(Icons.edit_document, size: 20),
                  SizedBox(width: 8),
                  Text("Edit Invoice"),
                ],
              ),
            ),
            const PopupMenuItem(
              value: InvoiceAction.deleteInvoice,
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete Invoice"),
                ],
              ),
            ),
          ]);
        }

        if (lowerStatus == 'active') {
          items.add(
            const PopupMenuItem(
              value: InvoiceAction.deleteInvoice,
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text("Delete Invoice"),
                ],
              ),
            ),
          );
        }

        return items;
      },
    );
  }
}
