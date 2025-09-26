import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_bloc.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_event.dart'
    as clients_event;
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_event.dart'
    as transection_event;
import 'package:cron/cron.dart';

/// SessionManager wraps the app and manages inactivity timers, warning popup,
/// cursor-only activity, auto-refresh, and logout.
class SessionManager extends StatefulWidget {
  final Widget child;
  final Duration sessionTimeout;
  final Duration warningBeforeTimeout;
  final Duration cursorOnlyRefreshThreshold;

  const SessionManager({
    super.key,
    required this.child,
    // TESTING: 10 minute session
    this.sessionTimeout = const Duration(minutes: 10),
    // TESTING: show 60-second warning (entire last minute)
    this.warningBeforeTimeout = const Duration(seconds: 60),
    // If only mouse moves for 9 minutes, auto-refresh
    this.cursorOnlyRefreshThreshold = const Duration(minutes: 9),
  });

  @override
  State<SessionManager> createState() => _SessionManagerState();
}

class _SessionManagerState extends State<SessionManager> {
  // Timers and time tracking
  DateTime _lastHardActivity = DateTime.now();
  DateTime? _cursorOnlyStart;
  // Keeping for potential future use (e.g., differentiating jitter)
  // ignore: unused_field
  DateTime? _lastMouseMove;

  // UI state
  bool _isWarningVisible = false;
  final ValueNotifier<int> _countdownSeconds = ValueNotifier<int>(0);

  Cron? _cronTicker;
  bool _isRefreshing = false;
  bool _isLoggingOut = false;

  // Repositories
  late final AuthRepository _authRepository;

  Duration get _warningAt =>
      widget.sessionTimeout - widget.warningBeforeTimeout;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepository(
      apiClient: ApiClient(),
      oauth2Config: OAuth2Config(),
    );
    _startTicker();
  }

  @override
  void dispose() {
    _cronTicker?.close();
    _countdownSeconds.dispose();
    super.dispose();
  }

  void _startTicker() {
    _cronTicker?.close();
    _cronTicker = Cron();
    // Every second ticker for countdown and inactivity checks
    _cronTicker!.schedule(Schedule.parse('*/1 * * * * *'), () async {
      await _onTick();
    });
  }

  Future<bool> _hasAuthToken() async {
    final token = await Prefobj.preferences.get(Prefkeys.authToken);
    return token != null && token.isNotEmpty;
  }

  Future<void> _onTick() async {
    if (!mounted) return;
    // Only operate when authenticated
    if (!await _hasAuthToken()) {
      if (_isWarningVisible) {
        _hideWarning();
      }
      return;
    }

    final DateTime now = DateTime.now();
    final Duration sinceHard = now.difference(_lastHardActivity);

    // Log inactive duration in seconds for debugging
  //  Logger.warning('Inactive time: \\${sinceHard.inSeconds}s');

    // Handle warning popup and countdown
    if (sinceHard >= _warningAt && sinceHard < widget.sessionTimeout) {
      final remaining = widget.sessionTimeout - sinceHard;
      _showOrUpdateWarning(remaining);
    } else {
      if (_isWarningVisible && sinceHard < _warningAt) {
        _hideWarning();
      }
    }

    // Auto logout when timeout reached
    if (sinceHard >= widget.sessionTimeout) {
      _hideWarning();
      await _autoLogout();
      return;
    }

    // Cursor-only refresh logic
    if (_cursorOnlyStart != null && !_isRefreshing) {
      final Duration sinceCursorOnly = now.difference(_cursorOnlyStart!);
      if (sinceCursorOnly >= widget.cursorOnlyRefreshThreshold) {
        await _refreshSession();
      }
    }
  }

  void _markHardActivity() {
    // Don't reset session if warning dialog is visible
    if (_isWarningVisible) return;

    _lastHardActivity = DateTime.now();
    _cursorOnlyStart = null;
    if (_isWarningVisible) {
      _hideWarning();
    }
  }

  void _markMouseMove() {
    // Don't reset session if warning dialog is visible
    if (_isWarningVisible) return;

    final DateTime now = DateTime.now();
    _lastMouseMove = now;
    // Treat mouse movement as active usage to avoid marking user inactive
    _markHardActivity();
  }

  Future<void> _refreshSession() async {
    if (_isRefreshing) return;
    _isRefreshing = true;
    try {
      final hasToken = await _hasAuthToken();
      if (!hasToken) return;
      final response = await _authRepository.refreshToken();
      final newToken = response.data?.accessToken ?? '';
      if (newToken.isNotEmpty) {
        await Prefobj.preferences.put(Prefkeys.authToken, newToken);
        await _authRepository.apiClient.buildHeaders();
      }
      // Reset timers and hide warning
      _lastHardActivity = DateTime.now();
      _cursorOnlyStart = null;
      _hideWarning();
    } catch (e) {
      // If refresh fails, allow normal timeout flow
    } finally {
      _isRefreshing = false;
    }
  }

  Future<void> _autoLogout() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
      final email = await Prefobj.preferences.get(Prefkeys.loggedEmail) ?? '';
      TokenManager.stopScheduler();
      context.read<ProfileDropdownBloc>().add(
        LogoutWithEmailRequested(email, context),
      );
      context.read<AuthBloc>().add(ClearLoginDataManuallyEvent());
      Prefobj.preferences.deleteAll();
      // Reset all dashboard blocs to initial state
      context.read<DashboardBloc>().add(ResetRequested());
      context.read<ClientsBloc>().add(clients_event.ResetRequested());
      context.read<TransectionBloc>().add(transection_event.ResetRequested());
    } finally {
      _isLoggingOut = false;
    }
  }

  void _showOrUpdateWarning(Duration remaining) {
    final seconds = remaining.inSeconds.clamp(0, 1 << 31);
    _countdownSeconds.value = seconds;
    if (_isWarningVisible) return;
    _isWarningVisible = true;

    final ctx = rootNavigatorKey.currentContext ?? context;
    _showWarningDialog(ctx);
  }

 Future<dynamic> _showWarningDialog(BuildContext ctx) {
  return showDialog(
    context: ctx,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(25.0),
          constraints: const BoxConstraints(maxWidth: 470),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Illustration - Replace with your asset path
                  SizedBox(
                    height: 200,
                    child: SvgPicture.asset(
                      "assets/images/svgs/other/session_worning.svg", // Update this path
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// Title
                  const Text(
                    "You're About to Be Logged Out",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  /// Description
                  const Text(
                    "You've been inactive for a while. To keep your account secure, "
                    "we'll log you out automatically once the timer runs out.",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  /// Countdown Timer
                  ValueListenableBuilder<int>(
                    valueListenable: _countdownSeconds,
                    builder: (_, value, __) {
                      final minutes = value ~/ 60;
                      final seconds = value % 60;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16, 
                          vertical: 8
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  /// Stay Logged In Button
                  SizedBox(
                    width: double.infinity,
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _refreshSession();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5), // Indigo color
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Stay logged in",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Log out now button
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _autoLogout();
                    },
                    child: const Text(
                      "Log out now",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4F46E5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              /// Close Button (X)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _refreshSession();
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
  void _hideWarning() {
    if (!_isWarningVisible) return;
    _isWarningVisible = false;
    // Pop dialog if still visible
    final ctx = rootNavigatorKey.currentContext;
    if (ctx != null) {
      if (Navigator.of(ctx).canPop()) {
        Navigator.of(ctx).pop();
      }
    }
  }

  // Top-level listeners to detect activity
  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _markHardActivity();
        return false;
      },
      child: MouseRegion(
        opaque: true,
        onHover: (_) => _markMouseMove(),
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerDown: (_) => _markHardActivity(),
          onPointerSignal: (_) => _markHardActivity(),
          onPointerMove: (_) => _markMouseMove(),
          child: Focus(
            onKeyEvent: (_, __) {
              _markHardActivity();
              return KeyEventResult.ignored;
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
