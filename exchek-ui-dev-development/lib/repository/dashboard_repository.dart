import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/models/invoice_models/invoice_model.dart';
import 'package:exchek/models/personal_user_models/get_currency_model.dart';

class DashboardRepository {
  final ApiClient apiClient;
  final OAuth2Config oauth2Config;

  DashboardRepository({required this.apiClient, required this.oauth2Config});

  // get all currencys list
  Future<List<CurrencyOption>> getNewCurrencyOptions() async {
    final response = await apiClient.request(
      RequestType.GET,
      ApiEndPoint.getListOfCurrencies,
    );
    final List data = response['data'] as List;
    return data
        .map((e) => CurrencyOption.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // get used currencys data
  Future<CurrencyListModel> getusedCurrencys() async {
    try {
      final response = await apiClient.request(
        RequestType.GET,
        ApiEndPoint.getusedCurrencys,
      );

      Logger.error('response of used currencyes ${response['data']}');
      final details = response['data'];
      Logger.error("details of used currencys $details");
      return await compute(CurrencyListModel.fromJson, response);
    } catch (error) {
      rethrow;
    }
  }
  Future<BalanceResponse> getBalanceResponse() async {
    try {
      final response = await apiClient.request(
        RequestType.GET,
        ApiEndPoint.getBalanceResponse,
      );

      Logger.error('response of BalanceResponse ${response['data']}');
     final balanceData = response['data'] as Map<String, dynamic>;
      return await compute(BalanceResponse.fromJson, balanceData);
    } catch (error) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> createReceivingAccount({
    required String currency,
  }) async {
    try {
      
      final Map<String, dynamic> data = {'currency': currency};

      final response = await apiClient.request(
        RequestType.POST,
        ApiEndPoint.createRecevingAccount,
        data: data,
      );
      print('response created receving account $response');
      return response;
    } catch (error) {
      rethrow;
    }
  }
}
