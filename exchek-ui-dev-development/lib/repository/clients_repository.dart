import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/clients_models/clients_models.dart';
import 'package:exchek/models/auth_models/common_success_model.dart';

class ClientDetailResponse {
  final ClientDetailModel clientDetail;
  final List<InvoiceModel> invoices;
  final List<ReceivableModel> receivables;
  ClientDetailResponse({required this.clientDetail, required this.invoices, required this.receivables});
}

class ClientsRepository {
  final ApiClient apiClient;
  final OAuth2Config oauth2Config;

  ClientsRepository({required this.apiClient, required this.oauth2Config});

  Future<List<ClientModel>> getAllClients({String? filter}) async {
    try {
      final String url =
          (filter == null || filter.isEmpty)
              ? ApiEndPoint.listClientsUrl
              : '${ApiEndPoint.listClientsUrl}?filter=${Uri.encodeComponent(filter)}';
      final response = await apiClient.request(RequestType.GET, url);
      final List data = (response['data'] ?? []) as List;
      return data.map((e) => ClientModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (error) {
      rethrow;
    }
  }

  Future<CommonSuccessModel> createClient({
    required String clientName,
    required String email,
    required String clientType,
    required String addressLine1,
    String? addressLine2,
    String? state,
    String? city,
    String? postalCode,
    required String country,
    required String currency,
    String? notes,
  }) async {
    try {
      final Map<String, dynamic> data = {
        'client_name': clientName,
        'email': email,
        'client_type': clientType,
        'address_line1': addressLine1,
        if (addressLine2 != null && addressLine2.isNotEmpty) 'address_line2': addressLine2,
        if (state != null && state.isNotEmpty) 'state': state,
        if (city != null && city.isNotEmpty) 'city': city,
        if (postalCode != null && postalCode.isNotEmpty) 'postal_code': postalCode,
        'country': country,
        'currency': currency,
        if (notes != null && notes.isNotEmpty) 'notes': notes,
      };

      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.createClientUrl,
        multipartData: data,
      );

      return CommonSuccessModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

  Future<ClientDetailResponse> getClientDetailsWithInvoices(String clientId) async {
    final response = await apiClient.request(RequestType.GET, '${ApiEndPoint.getClientDetailsUrl}?client_id=$clientId');
    final data = response['data'] as Map<String, dynamic>;

    final clientJson = data['client'] as Map<String, dynamic>;
    final receivableList = (data['receivable'] as List<dynamic>?) ?? [];
    final invoicesJson = data['invoices'] as List<dynamic>? ?? [];

    // Parse all receivables
    final receivables =
        receivableList.map((json) {
          return ReceivableModel(
            currency: json['currency']?.toString() ?? '',
            total: (json['total'] ?? 0).toDouble(),
            withdrawn: (json['withdrawn'] ?? 0).toDouble(),
            processing: (json['processing'] ?? 0).toDouble(),
            pending: (json['pending'] ?? 0).toDouble(),
          );
        }).toList();

    // Parse client detail with combined address
    final clientDetail = ClientDetailModel(
      name: clientJson['client_name']?.toString() ?? '',
      email: clientJson['email']?.toString() ?? '',
      clientType: clientJson['client_type']?.toString() ?? '',
      addressLine1 : clientJson['address_line1'],
      addressLine2 :clientJson['address_line2'],
      city: clientJson['city']?.toString() ?? '',
      state: clientJson['state']?.toString() ?? '',
      country: clientJson['country']?.toString() ?? '',
      currencyCode: receivables.isNotEmpty ? receivables.first.currency : clientJson['currency']?.toString() ?? '',
      totalReceivable: receivables.isNotEmpty ? receivables.first.total.toString() : '0',
      withdrawn: receivables.isNotEmpty ? receivables.first.withdrawn.toString() : '0',
      processing: receivables.isNotEmpty ? receivables.first.processing.toString() : '0',
      pending: receivables.isNotEmpty ? receivables.first.pending.toString() : '0',
      status: clientJson['status']?.toString(),
      dateAdded: clientJson['created_at']?.toString(),
    );

    // Parse invoices
    final invoices = invoicesJson.map((json) => InvoiceModel.fromJson(json as Map<String, dynamic>)).toList();

    return ClientDetailResponse(clientDetail: clientDetail, invoices: invoices, receivables: receivables);
  }

Future<CountryClientTypeOptionsResponse>  countryClientTypeOptions() async {
    final response = await apiClient.request(RequestType.GET, ApiEndPoint.countryClientTypeOptionsUrl);
      final data = response['data'] as Map<String, dynamic>? ?? {};

      final countries = (data['countries'] as List<dynamic>?)
              ?.map((e) => Country.fromJson(e as Map<String, dynamic>))
              .toList() 
          ?? [];

      final clientTypes = (data['client_types'] as List<dynamic>?)
              ?.map((e) => ClientType.fromJson(e as Map<String, dynamic>))
              .toList() 
          ?? [];
       return CountryClientTypeOptionsResponse(
          countries: countries,
          clientTypes: clientTypes,
        );
   }

Future<CommonSuccessModel> updateClient(Map<String, dynamic> data) async {
    try {
      final response = await apiClient.request(
        RequestType.MULTIPART_POST,
        ApiEndPoint.updateClientUrl,
        multipartData: data,
      );

      return CommonSuccessModel.fromJson(response);
    } catch (error) {
      rethrow;
    }
  }

}