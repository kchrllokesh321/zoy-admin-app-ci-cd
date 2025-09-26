import 'package:equatable/equatable.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';

class InvoiceState extends Equatable {
  final List<InvoiceModel> all;
  final List<InvoiceModel> filtered;
  final List<ClientModel> clients;
  final Set<String> selectedIds;
  final String searchQuery;
  final int page;
  final int pageSize;
  final bool loading;
  final bool uploading;
  final bool sharing;
  final String? error;
  final bool showFilters;

  final FileData? selectedFile;

  final String invoiceNumber;
  final ClientModel? selectedClient;
  final String clientEmail;
  final String currency;
  final String invoiceAmount;
  final String receivableAmount;
  final String invoiceDate;
  final String? dueDate;
  final String purposeCode;
  final String internalNotes;

  final Map<String, String> activeFilters;
  final String sortBy;
  final bool sortAscending;
  final bool hasError;
  final bool clientLoading;
  final bool uploadSuccess;
  final bool isEditing;
  final String id;
  final bool reminding;
  final bool loadingShareContent;
  final String shareEmailSubject;
  final String shareEmailBody;
  final String shareEmailTo;
  final bool shareSuccess;
  final List<CurrencyOption> currencyOptions;
  final List<PurposeCodeOption> purposeCodeOptions;

  const InvoiceState({
    required this.all,
    required this.filtered,
    required this.clients,
    required this.selectedIds,
    required this.searchQuery,
    required this.page,
    required this.pageSize,
    this.loading = false,
    this.uploading = false,
    this.sharing = false,
    this.error,
    this.selectedFile,
    required this.invoiceNumber,
    this.selectedClient,
    required this.clientEmail,
    required this.currency,
    required this.invoiceAmount,
    required this.receivableAmount,
    required this.invoiceDate,
    this.dueDate,
    required this.purposeCode,
    required this.internalNotes,
    required this.activeFilters,
    required this.sortBy,
    required this.sortAscending,
    this.showFilters = false,
    this.hasError = false,
    this.clientLoading = false,
    this.uploadSuccess = false,
    this.isEditing = false,
    this.id = '',
    this.reminding = false,
    this.loadingShareContent = false,
    this.shareEmailSubject = '',
    this.shareEmailBody = '',
    this.shareEmailTo = '',
    this.shareSuccess = false,
    this.currencyOptions = const [],
    this.purposeCodeOptions = const [],
  });

  factory InvoiceState.initial() => const InvoiceState(
    all: [],
    filtered: [],
    clients: [],
    selectedIds: <String>{},
    searchQuery: '',
    page: 1,
    pageSize: 10,
    loading: false,
    uploading: false,
    sharing: false,
    error: null,
    selectedFile: null,
    invoiceNumber: '',
    selectedClient: null,
    clientEmail: '',
    currency: 'USD',
    invoiceAmount: "",
    receivableAmount: "",
    invoiceDate: '',
    dueDate: null,
    purposeCode: '',
    internalNotes: '',
    activeFilters: {},
    sortBy: 'invoiceDate',
    sortAscending: false,
    showFilters: false,
    hasError: false,
    clientLoading: false,
    uploadSuccess: false,
    isEditing: false,
    id: '',
    reminding: false,
    loadingShareContent: false,
    shareEmailSubject: '',
    shareEmailBody: '',
    shareEmailTo: '',
    currencyOptions: [],
    purposeCodeOptions: [],
  );

  InvoiceState copyWith({
    List<InvoiceModel>? all,
    List<InvoiceModel>? filtered,
    List<ClientModel>? clients,
    Set<String>? selectedIds, // Changed to Set<String>
    String? searchQuery,
    int? page,
    int? pageSize,
    bool? loading,
    bool? uploading,
    bool? sharing,
    String? error,
    bool clearError = false,
    FileData? selectedFile,
    bool clearFile = false,
    String? invoiceNumber,
    ClientModel? selectedClient,
    bool clearClient = false,
    String? clientEmail,
    String? currency,
    String? invoiceAmount,
    String? receivableAmount,
    String? invoiceDate,
    String? dueDate,
    String? purposeCode,
    String? internalNotes,
    Map<String, String>? activeFilters,
    String? sortBy,
    bool? sortAscending,
    bool? showFilters,
    bool? hasError,
    bool? clientLoading,
    bool? uploadSuccess,
    bool? isEditing,
    String? id,
    bool? reminding,
    bool? loadingShareContent,
    String? shareEmailSubject,
    String? shareEmailBody,
    String? shareEmailTo,
    bool? shareSuccess,
    List<CurrencyOption>? currencyOptions,
    List<PurposeCodeOption>? purposeCodeOptions,
  }) {
    return InvoiceState(
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
      clients: clients ?? this.clients,
      selectedIds: selectedIds ?? this.selectedIds,
      searchQuery: searchQuery ?? this.searchQuery,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      loading: loading ?? this.loading,
      uploading: uploading ?? this.uploading,
      sharing: sharing ?? this.sharing,
      error: clearError ? null : error ?? this.error,
      selectedFile: clearFile ? null : selectedFile ?? this.selectedFile,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      selectedClient: clearClient ? null : selectedClient ?? this.selectedClient,
      clientEmail: clientEmail ?? this.clientEmail,
      currency: currency ?? this.currency,
      invoiceAmount: invoiceAmount ?? this.invoiceAmount,
      receivableAmount: receivableAmount ?? this.receivableAmount,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      dueDate: dueDate ?? this.dueDate,
      purposeCode: purposeCode ?? this.purposeCode,
      internalNotes: internalNotes ?? this.internalNotes,
      activeFilters: activeFilters ?? this.activeFilters,
      sortBy: sortBy ?? this.sortBy,
      sortAscending: sortAscending ?? this.sortAscending,
      showFilters: showFilters ?? this.showFilters,
      hasError: hasError ?? this.hasError,
      clientLoading: clientLoading ?? this.clientLoading,
      uploadSuccess: uploadSuccess ?? this.uploadSuccess,
      isEditing: isEditing ?? this.isEditing,
      id: id ?? this.id,
      reminding: reminding ?? this.reminding,
      loadingShareContent: loadingShareContent ?? this.loadingShareContent,
      shareEmailSubject: shareEmailSubject ?? this.shareEmailSubject,
      shareEmailBody: shareEmailBody ?? this.shareEmailBody,
      shareEmailTo: shareEmailTo ?? this.shareEmailTo,
      shareSuccess: shareSuccess ?? this.shareSuccess,
      currencyOptions: currencyOptions ?? this.currencyOptions,
      purposeCodeOptions: purposeCodeOptions ?? this.purposeCodeOptions,
    );
  }

  bool get isLoading => loading;

  bool get isFormValid {
    return invoiceNumber.isNotEmpty &&
        clientEmail.isNotEmpty &&
        invoiceAmount.isNotEmpty &&
        receivableAmount.isNotEmpty &&
        invoiceDate.isNotEmpty &&
        dueDate != null &&
        purposeCode.isNotEmpty &&
        selectedClient != null;
  }

  List<InvoiceModel> get currentPageItems {
    final startIndex = (page - 1) * pageSize;
    if (startIndex >= filtered.length) {
      return [];
    }
    final endIndex = (startIndex + pageSize).clamp(0, filtered.length);
    return filtered.sublist(startIndex, endIndex);
  }

  int get totalPages => (filtered.length / pageSize).ceil();

  @override
  List<Object?> get props => [
    all,
    filtered,
    clients,
    selectedIds,
    searchQuery,
    page,
    pageSize,
    loading,
    uploading,
    sharing,
    error,
    selectedFile,
    invoiceNumber,
    selectedClient,
    clientEmail,
    currency,
    invoiceAmount,
    receivableAmount,
    invoiceDate,
    dueDate,
    purposeCode,
    internalNotes,
    activeFilters,
    sortBy,
    sortAscending,
    showFilters,
    hasError,
    clientLoading,
    uploadSuccess,
    isEditing,
    reminding,
    id,
    loadingShareContent,
    shareEmailSubject,
    shareEmailBody,
    shareEmailTo,
    shareSuccess,
    currencyOptions,
    purposeCodeOptions,
  ];
}
