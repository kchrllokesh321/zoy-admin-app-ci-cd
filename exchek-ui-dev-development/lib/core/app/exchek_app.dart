import 'package:exchek/core/responsive_helper/responsive_layout.dart';
import 'package:exchek/core/utils/bloc_providers.dart';
import 'package:exchek/core/utils/exports.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class ExchekApp extends StatelessWidget {
  const ExchekApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoRouter appRouterInstance = appRouter();
    if (!kIsWeb) {
      FlutterNativeSplash.remove();
    }
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).customColors.primaryColor,
      ),
      child: BlocProviders(
        child: MultiBlocListener(
          listeners: [
            BlocListener<CheckConnectionCubit, CheckConnectionStates>(
              listener: (context, state) {
                if (state is InternetDisconnected) {
                  CheckConnectionCubit.get(context).isNetDialogShow = true;
                  Logger.lOG('InternetDisconnected');
                }
                if (state is InternetConnected) {
                  if (CheckConnectionCubit.get(context).isNetDialogShow) {
                    Logger.lOG('InternetConnected');
                    CheckConnectionCubit.get(context).isNetDialogShow = false;
                  }
                }
              },
            ),
            BlocListener<AuthBloc, AuthState>(
              listenWhen:
                  (previous, current) =>
                      previous.isLoginSuccess != current.isLoginSuccess && current.isLoginSuccess == false,
              listener: (context, state) {
                rootNavigatorKey.currentContext?.go(RouteUri.loginRoute);
              },
            ),
          ],
          child: BlocBuilder<LocaleBloc, LocaleState>(
            builder: (context, localeState) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  highContrast: true,
                  displayFeatures: MediaQuery.of(context).displayFeatures,
                  gestureSettings: MediaQuery.of(context).gestureSettings,
                  textScaler: TextScaler.noScaling,
                  invertColors: false,
                  boldText: false,
                ),
                child: GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  child: ResponsiveLayout(
                    mobile: _buildApp(context, localeState, appRouterInstance),
                    tablet: _buildApp(context, localeState, appRouterInstance, isTablet: true),
                    desktop: _buildApp(context, localeState, appRouterInstance, isDesktop: true),
                    web: kIsWeb ? _buildApp(context, localeState, appRouterInstance, isWeb: true) : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildApp(
    BuildContext context,
    LocaleState localeState,
    GoRouter appRouterInstance, {
    bool isTablet = false,
    bool isDesktop = false,
    bool isWeb = false,
  }) {
    return ToastificationWrapper(
      child: MaterialApp.router(
        title: 'Exchek',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          Lang.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Lang.delegate.supportedLocales,
        locale: localeState.locale,
        theme: MyAppThemeHelper.lightTheme,
        themeMode: ThemeMode.system,
        routeInformationProvider: appRouterInstance.routeInformationProvider,
        routeInformationParser: appRouterInstance.routeInformationParser,
        routerDelegate: appRouterInstance.routerDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
        builder: (context, child) => SessionManager(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
