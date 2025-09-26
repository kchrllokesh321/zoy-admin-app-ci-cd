import 'package:cron/cron.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:synchronized/synchronized.dart';

class TokenManager {
  static Cron? _cron;
  
  static const String _everyTwoMinutes = '*/2 * * * *';

  static bool _isRefreshing = false;
  static Future<void>? _ongoingRefresh;
  static bool _isStarted = false;
  static bool get isSchedulerRunning => _isStarted;

  /// Start scheduler to refresh token every 2 minutes
  static void startScheduler({String schedule = _everyTwoMinutes}) async{
    stopScheduler();
      Logger.info("startScheduler>>>> ${TokenManager.isSchedulerRunning} <><><> ${DateTime.now()}");
      final String? token = await Prefobj.preferences.get(Prefkeys.authToken);
      if (token == null || token.isEmpty) {
         return;
      }
    _cron = Cron();
    _isStarted = true;
    _cron!.schedule(Schedule.parse(schedule), () async {
      await _startRefresh(); // Always run refresh on schedule
    });

  }

  static void stopScheduler() {
    _cron?.close();
    _cron = null;
    _isStarted = false;
    Logger.info("stopScheduler>>>> ${TokenManager.isSchedulerRunning} <><><> ${DateTime.now()}");
  }

  /// API calls use this to wait until refresh is done (if any)
  static Future<void> waitIfRefreshing() async {
    if (_isRefreshing) {
      return _ongoingRefresh ?? Future.value();
    }
    return Future.value();
  }

static final _refreshLock = Lock();

static Future<void> _startRefresh() async {
  return await _refreshLock.synchronized(() async {
    if (_isRefreshing) return _ongoingRefresh ?? Future.value();
    _isRefreshing = true;
    _ongoingRefresh = _refreshTokenSafe();
    await _ongoingRefresh;
    _isRefreshing = false;
    _ongoingRefresh = null;
  });
}

  static Future<void> _refreshTokenSafe() async {
    try {
      final String? token = await Prefobj.preferences.get(Prefkeys.authToken);
      if (token == null || token.isEmpty) {
        _navigateToLogin();
        return;
      }

      final authRepository = AuthRepository(
        apiClient: ApiClient(),
        oauth2Config: OAuth2Config(),
      );
      final response = await authRepository.refreshToken();
      final newToken = response.data?.accessToken ?? '';
      if (newToken.isNotEmpty) {
        await Prefobj.preferences.put(Prefkeys.authToken, newToken);
        await authRepository.apiClient.buildHeaders();
        Logger.info("Token refreshed successfully.");
      } else {
        _navigateToLogin();
      }
    } catch (e) {
    //  _navigateToLogin();
      Logger.error('Error refreshing token: $e');
    }
  }

  static void _navigateToLogin() async {
    try {
        Logger.info("_navigateToLogin:>>>>>");
       stopScheduler();
      await Prefobj.preferences.deleteAll();
    } catch (e) {
      Logger.error("Failed to clear token: $e");
    }
    AppToast.show(
      message: "For security reasons, please log in again.",
      type: ToastificationType.info,
    );
    appRouter().go(RouteUri.loginRoute);
  }
}
