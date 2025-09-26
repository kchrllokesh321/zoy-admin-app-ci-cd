import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';

class InvoiceRepository {
  final ApiClient apiClient;

  InvoiceRepository({required this.apiClient});

  Future<List<ClientModel>> fetchClientNames({String? filter}) async {
    try {
      final queryParams = <String, String>{};
      if (filter != null && filter.isNotEmpty) {
        queryParams['filter'] = filter;
      }

      String url = ApiEndPoint.listClientsNamesUrl;
      if (queryParams.isNotEmpty) {
        final queryString = Uri(queryParameters: queryParams).query;
        url = '$url?$queryString';
      }

      final response = await apiClient.request(RequestType.GET, url);
      final List data = (response['data'] ?? []) as List;
      return data.map((e) => ClientModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<List<InvoiceModel>> fetchInvoices({
    String? clientName,
    List<String>? currency,
    String? fromDate,
    String? toDate,
    List<String>? status,
  }) async {
    try {
      final Map<String, dynamic> body = {};
      if (clientName != null && clientName.isNotEmpty) body['client_name'] = clientName;
      if (currency != null && currency.isNotEmpty) body['currency'] = currency;
      if (fromDate != null && fromDate.isNotEmpty) body['from_date'] = fromDate;
      if (toDate != null && toDate.isNotEmpty) body['to_date'] = toDate;

      if (status != null && status.isNotEmpty) body['status'] = status;

      final response = await apiClient.request(RequestType.POST, ApiEndPoint.listInvoicesUrl, data: body);

      final List data = (response['data']?['invoices'] ?? []) as List;
      return data.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> uploadInvoice({
    required String clientId,
    required String invoiceNumber,
    required String currency,
    required String invoiceAmount,
    required String receivableAmount,
    required String invoiceDate,
    required String dueDate,
    required String purposeCode,
    required String status,
    String? internalNotes,
    required FileData invoiceFile,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'client_id': clientId,
        'invoice_number': invoiceNumber,
        'currency': currency,
        'invoice_amount': invoiceAmount,
        'receivable_amount': receivableAmount,
        'invoice_date': invoiceDate.split('T').first,
        'due_date': dueDate.split('T').first,
        'purpose_code': purposeCode,
        if (internalNotes != null && internalNotes.isNotEmpty) 'internal_notes': internalNotes,
        'status': status,
        'invoice_file': invoiceFile,
      };

      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.uploadInvoiceUrl,
        multipartData: data,
      );

      return await compute(CommonSuccessModel.fromJson, response);
    } catch (error) {
      // Optionally parse DioException for better error messages here
      rethrow;
    }
  }

  Future<CommonSuccessModel> deleteCancelledInvoice({required String invoiceId}) async {
    try {
      final String url = '${ApiEndPoint.deleteCancelledInvoiceUrl}?id=$invoiceId';

      final response = await apiClient.request(RequestType.POST, url);

      return CommonSuccessModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> editDraftInvoice({
    required String id,
    required String clientId,
    required String invoiceNumber,
    required String currency,
    required String invoiceAmount,
    required String receivableAmount,
    required String invoiceDate,
    required String dueDate,
    required String purposeCode,
    required String status,
    required FileData invoiceFile,
  }) async {
    final Map<String, dynamic> data = {
      'id': id,
      'client_id': clientId,
      'invoice_number': invoiceNumber,
      'currency': currency,
      'invoice_amount': invoiceAmount,
      'receivable_amount': receivableAmount,
      'invoice_date': invoiceDate,
      'due_date': dueDate,
      'purpose_code': purposeCode,
      'status': status,
      'invoice_file': invoiceFile,
    };

    final response = await apiClient.request(
      RequestType.MULTIPART_PUT,
      ApiEndPoint.editDraftInvoiceUrl,
      multipartData: data,
    );

    return CommonSuccessModel.fromJson(response);
  }

  Future<CommonSuccessModel> editReceivableAmountActiveInvoice({
    required String invoiceId,
    required double receivableAmount,
  }) async {
    try {
      // Build URL with query parameters
      final url =
          Uri.parse(
            ApiEndPoint.editReceivableActiveInvoiceUrl,
          ).replace(queryParameters: {'id': invoiceId, 'receivable_amount': receivableAmount.toString()}).toString();

      // PUT request with empty body, as params are in query string
      final response = await apiClient.request(RequestType.PUT, url);

      return CommonSuccessModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> remindInvoiceToEmail({required String invoiceId}) async {
    try {
      final url = '${ApiEndPoint.remindInvoiceToEmailUrl}?invoice_id=$invoiceId';

      final response = await apiClient.request(RequestType.POST, url);

      return CommonSuccessModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> fetchShareInvoiceEmailContent(String invoiceId) async {
    final url = '${ApiEndPoint.loadEmailContentForInvoiceUrl}?id=$invoiceId';

    final response = await apiClient.request(RequestType.GET, url);

    if (response['success'] == true && response['data'] != null) {
      return response['data'] as Map<String, dynamic>;
    } else {
      throw Exception('Failed to fetch invoice email content');
    }
  }

  Future<CommonSuccessModel> sendInvoiceEmail({
    required String invoiceId,
    required String subject,
    required String emailBody,
    required String emailTo,
    String? emailCc,
    String? emailBcc,
  }) async {
    try {
      final String url = ApiEndPoint.sendInvoiceToEmailUrl;

      final Map<String, dynamic> data = {
        'invoice_id': invoiceId,
        'subject': subject,
        'email_body': emailBody,
        'email_to': emailTo,
        if (emailCc != null && emailCc.isNotEmpty) 'email_cc': emailCc,
        if (emailBcc != null && emailBcc.isNotEmpty) 'email_bcc': emailBcc,
      };
      final response = await apiClient.request(RequestType.MULTIPART_POST, url, multipartData: data);

      return CommonSuccessModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

  // Future<CommonSuccessModel> sendInvoiceEmail({
  //   required String invoiceId,
  //   required String subject,
  //   required String emailBody,
  //   required String emailTo,
  //   String? emailCc,
  //   String? emailBcc,
  // }) async {
  //   try {
  //     final String url = ApiEndPoint.sendInvoiceToEmailUrl;

  //     final Map<String, dynamic> data = {
  //       'invoice_id': invoiceId,
  //       'subject': subject,
  //       'email_body': emailBody,
  //       'email_to': emailTo,
  //       if (emailCc != null && emailCc.isNotEmpty) 'email_cc': emailCc,
  //       if (emailBcc != null && emailBcc.isNotEmpty) 'email_bcc': emailBcc,
  //     };
  //     print("invoice email data $data");

  //     FormData formData = FormData.fromMap(data);

  //     print("invoice email data $formData");
  //     final response = await apiClient.request(RequestType.MULTIPART_POST, url, data: formData);

  //     return CommonSuccessModel.fromJson(response);
  //   } catch (error) {
  //     rethrow;
  //   }
  // }

  Future<List<CurrencyOption>> fetchCurrencyOptions() async {
    final response = await apiClient.request(RequestType.GET, ApiEndPoint.getListOfCurrencies);
    final List data = response['data'] as List;
    return data.map((e) => CurrencyOption.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<PurposeCodeOption>> fetchPurposeCodes() async {
    final response = await apiClient.request(RequestType.GET, ApiEndPoint.getPurposeCodes);
    final List data = response['data'] as List;
    return data.map((e) => PurposeCodeOption.fromJson(e as Map<String, dynamic>)).toList();
  }
}
