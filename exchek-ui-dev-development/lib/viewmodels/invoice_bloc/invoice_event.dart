import 'package:equatable/equatable.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart'; // Adjust path as needed

abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object?> get props => [];
}

// Starting / refreshing data
class InvoiceStarted extends InvoiceEvent {
  const InvoiceStarted();
}

class SelectClient extends InvoiceEvent {
  final ClientModel client;

  const SelectClient(this.client);

  @override
  List<Object?> get props => [client];
}

class FetchClient extends InvoiceEvent {
  final String userId;
  final String? filter;

  const FetchClient({required this.userId, this.filter});

  @override
  List<Object?> get props => [userId, filter];
}

class InvoiceRefreshRequested extends InvoiceEvent {
  const InvoiceRefreshRequested();
}

// File upload events
class InvoiceFileSelected extends InvoiceEvent {
  final FileData fileData;

  const InvoiceFileSelected(this.fileData);

  @override
  List<Object?> get props => [fileData];
}

class InvoiceFileRemoved extends InvoiceEvent {
  const InvoiceFileRemoved();
}

// Form events
class InvoiceFormFieldChanged extends InvoiceEvent {
  final String field;
  final String value;

  const InvoiceFormFieldChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class InvoiceFormChanged extends InvoiceEvent {
  final String field;
  final String value;

  const InvoiceFormChanged({required this.field, required this.value});

  @override
  List<Object?> get props => [field, value];
}

class InvoiceClientSelected extends InvoiceEvent {
  final ClientModel client;

  const InvoiceClientSelected(this.client);

  @override
  List<Object?> get props => [client];
}

class InvoiceSubmitted extends InvoiceEvent {
  final InvoiceModel invoice;

  const InvoiceSubmitted(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

// Search/filter events
class InvoiceSearchChanged extends InvoiceEvent {
  final String query;

  const InvoiceSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class InvoiceFilterApplied extends InvoiceEvent {
  final String filterType;
  final String filterValue;

  const InvoiceFilterApplied({required this.filterType, required this.filterValue});

  @override
  List<Object?> get props => [filterType, filterValue];
}

class InvoiceFilterCleared extends InvoiceEvent {
  const InvoiceFilterCleared();
}

class InvoiceFilterRemoved extends InvoiceEvent {
  final String filterType;

  const InvoiceFilterRemoved(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

class ToggleFiltersVisibility extends InvoiceEvent {}

// Sorting events
class InvoiceSortChanged extends InvoiceEvent {
  final String sortBy;
  final bool ascending;

  const InvoiceSortChanged({required this.sortBy, required this.ascending});

  @override
  List<Object?> get props => [sortBy, ascending];
}

// Selection events
class InvoiceSelectionToggled extends InvoiceEvent {
  final String invoiceId; // Changed to String for UUID

  const InvoiceSelectionToggled(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class InvoiceSelectAllToggled extends InvoiceEvent {
  const InvoiceSelectAllToggled();
}

class InvoiceSelectionCleared extends InvoiceEvent {
  const InvoiceSelectionCleared();
}

// Pagination events
class InvoicePageChanged extends InvoiceEvent {
  final int pageNumber;

  const InvoicePageChanged(this.pageNumber);

  @override
  List<Object?> get props => [pageNumber];
}

// Other actions
class InvoiceViewRequested extends InvoiceEvent {
  final String invoiceId; // Changed to String

  const InvoiceViewRequested(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class InvoiceShareRequested extends InvoiceEvent {
  final String invoiceId;
  final String to;
  final String? cc;
  final String? bcc;
  final String subject;
  final String message;

  const InvoiceShareRequested({
    required this.invoiceId,
    required this.to,
    this.cc,
    this.bcc,
    required this.subject,
    required this.message,
  });

  @override
  List<Object?> get props => [invoiceId, to, cc, bcc, subject, message];
}

class InvoiceReminderSent extends InvoiceEvent {
  final String invoiceId; // Changed to String

  const InvoiceReminderSent(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class EditReceivableRequested extends InvoiceEvent {
  final String invoiceId; // Changed to String
  final String newAmount;

  const EditReceivableRequested({required this.invoiceId, required this.newAmount});

  @override
  List<Object?> get props => [invoiceId, newAmount];
}

class CancelDeleteInvoiceRequested extends InvoiceEvent {
  final String invoiceId; // Changed to String

  const CancelDeleteInvoiceRequested(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class EditInvoiceRequested extends InvoiceEvent {
  final String invoiceId; // Changed to String

  const EditInvoiceRequested(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class ClearAllFiltersRequested extends InvoiceEvent {}

class InvoiceMultipleFiltersApplied extends InvoiceEvent {
  final Map<String, String> filters;

  const InvoiceMultipleFiltersApplied(this.filters);

  @override
  List<Object?> get props => [filters];
}

class SetInvoiceEditingMode extends InvoiceEvent {
  final bool isEditing;
  final String? id;

  const SetInvoiceEditingMode({required this.isEditing, this.id});
}

class EditDraftInvoiceRequested extends InvoiceEvent {
  final String id;
  final String clientId;
  final String invoiceNumber;
  final String currency;
  final String invoiceAmount;
  final String receivableAmount;
  final String invoiceDate;
  final String dueDate;
  final String purposeCode;
  final String status;
  final FileData invoiceFile;
  final String? internalNotes;

  const EditDraftInvoiceRequested({
    required this.id,
    required this.clientId,
    required this.invoiceNumber,
    required this.currency,
    required this.invoiceAmount,
    required this.receivableAmount,
    required this.invoiceDate,
    required this.dueDate,
    required this.purposeCode,
    required this.status,
    required this.invoiceFile,
    this.internalNotes,
  });

  @override
  List<Object?> get props => [
    id,
    clientId,
    invoiceNumber,
    currency,
    invoiceAmount,
    receivableAmount,
    invoiceDate,
    dueDate,
    purposeCode,
    status,
    invoiceFile,
    internalNotes,
  ];
}

class RemindInvoiceRequested extends InvoiceEvent {
  final String invoiceId;

  const RemindInvoiceRequested(this.invoiceId);
}

class LoadShareContent extends InvoiceEvent {
  final String invoiceId;

  const LoadShareContent(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

class FetchClientNames extends InvoiceEvent {
  // final String userId;
  final String? filter;

  // FetchClientNames({required this.userId, this.filter});
  const FetchClientNames({this.filter});

  @override
  List<Object?> get props => [filter];
}

class LoadInvoiceForEditing extends InvoiceEvent {
  final InvoiceModel invoice;

  const LoadInvoiceForEditing(this.invoice);

  @override
  List<Object?> get props => [invoice];
}

class FetchCurrencyOptions extends InvoiceEvent {
  const FetchCurrencyOptions();

  @override
  List<Object?> get props => [];
}

class DeleteCancelledInvoiceRequested extends InvoiceEvent {
  final String invoiceId;

  const DeleteCancelledInvoiceRequested(this.invoiceId);

  @override
  List<Object?> get props => [invoiceId];
}

// Upload invoice event
class UploadInvoice extends InvoiceEvent {
  final FileData fileData;
  final String clientId;
  final String invoiceNumber;
  final String currency;
  final String invoiceAmount;
  final String receivableAmount;
  final String invoiceDate;
  final String dueDate;
  final String purposeCode;
  final String status;
  final String? internalNotes;

  const UploadInvoice({
    required this.fileData,
    required this.clientId,
    required this.invoiceNumber,
    required this.currency,
    required this.invoiceAmount,
    required this.receivableAmount,
    required this.invoiceDate,
    required this.dueDate,
    required this.purposeCode,
    required this.status,
    this.internalNotes,
  });

  @override
  List<Object?> get props => [
    fileData,
    clientId,
    invoiceNumber,
    currency,
    invoiceAmount,
    receivableAmount,
    invoiceDate,
    dueDate,
    purposeCode,
    status,
    internalNotes,
  ];
}
