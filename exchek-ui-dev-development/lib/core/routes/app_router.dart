import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_account_ekyc_view.dart';
import 'package:exchek/views/auth_view/platform_terms_of_use_view.dart';
import 'package:exchek/views/account_setup_view/ekyc_submission_confirmation.dart';
import 'package:exchek/views/main_dashboard_view/dashboard_view.dart';
import 'package:exchek/views/exception_view/forgot_password_verify_expired_view.dart';
import 'package:exchek/views/exception_view/page_not_found_view.dart';
import 'package:exchek/views/exception_view/verify_expired_view.dart';
import 'package:exchek/views/account_setup_view/account_selection.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_setup_view.dart';

class RouteUri {
  static const String initialRoute = '/';
  static const String loginRoute = '/login';
  static const String forgotPasswordRoute = '/forgotpassword';
  static const String resetPasswordRoute = '/resetpassword';
  static const String signupRoute = '/signup';
  static const String resendemailRoute = '/resendemail';
  static const String verifyemailRoute = '/verifyemail';
  static const String ekycconfirmationroute = '/ekycconfirmation';
  static const String businessAccountSetupViewRoute = '/businessaccountsetupView';
  static const String businessAccountSuccessViewRoute = '/businessaccountsuccess';
  static const String proceedWithKycViewRoute = '/proceedWithkyc';
  static const String personalAccountKycSetupView = '/personalaccountkycsetupview';
  static const String businessAccountKycSetupView = '/businessaccountkycsetupview';
  static const String platformTermsOfUseView = '/platformtermsofuse';
  static const String selfieView = '/selfie';
  static const String cameraView = '/camera';
  static const String selectAccountTypeRoute = '/selectaccounttype';
  static const String personalAccountSetupRoute = '/personalaccountsetupview';
  static const String verifyExpiredRoute = '/verifyexpired';
  static const String pageNotFoundView = '/pagenotfound';
  static const String logoutRoute = '/logout';
  static const String resetExpiredRoute = '/resetexpired';
  static const String dashboardRoute = '/dashboard';
}

// Public routes that don't require authentication

const List<String> unrestrictedRoutes = [
  RouteUri.loginRoute,
  RouteUri.signupRoute,
  RouteUri.verifyemailRoute,
  RouteUri.resendemailRoute,
  RouteUri.verifyExpiredRoute,
  RouteUri.resetExpiredRoute,
  RouteUri.platformTermsOfUseView,
  RouteUri.forgotPasswordRoute,
  RouteUri.resetPasswordRoute,
  RouteUri.selectAccountTypeRoute,
  RouteUri.personalAccountSetupRoute,
  RouteUri.businessAccountSetupViewRoute,
  '/exchek/verifyemail',
  '/exchek/resetpassword',
  '/exchek/verifyexpired',
  '/exchek/resetexpired',
  '/exchek/login',
];

// Routes that require authentication
const List<String> authenticatedRoutes = [
  RouteUri.businessAccountSuccessViewRoute,
  RouteUri.proceedWithKycViewRoute,
  RouteUri.ekycconfirmationroute,
  RouteUri.businessAccountKycSetupView,
  RouteUri.platformTermsOfUseView,
  RouteUri.selfieView,
  RouteUri.cameraView,
  RouteUri.personalAccountKycSetupView,
  RouteUri.dashboardRoute,
  RouteUri.logoutRoute,
];

// Custom transition builder for all routes
CustomTransitionPage<T> fadeTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut), child: child);
    },
  );
}

GoRouter appRouter() {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteUri.initialRoute,
    debugLogDiagnostics: true,
    errorPageBuilder:
        (context, state) => fadeTransition(context: context, state: state, child: const PageNotFoundView()),
    routes: [
      GoRoute(
        name: RouteUri.loginRoute,
        path: RouteUri.loginRoute,
        pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: const LoginView()),
      ),
      GoRoute(path: '/exchek/login', redirect: (context, state) => RouteUri.loginRoute),
      GoRoute(
        name: RouteUri.forgotPasswordRoute,
        path: RouteUri.forgotPasswordRoute,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: const ForgotPasswordView()),
      ),
      GoRoute(
        name: RouteUri.resetPasswordRoute,
        path: RouteUri.resetPasswordRoute,
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            Prefobj.preferences.put(Prefkeys.resetPasswordToken, token);
          }
          return fadeTransition(context: context, state: state, child: ResetPasswordView());
        },
      ),

      GoRoute(
        path: '/exchek/resetpassword',
        redirect: (context, state) {
          final token = state.uri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            Prefobj.preferences.put(Prefkeys.resetPasswordToken, token);
          }
          return RouteUri.resetPasswordRoute;
        },
      ),

      GoRoute(
        name: RouteUri.verifyExpiredRoute,
        path: RouteUri.verifyExpiredRoute,
        pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: VerifyExpiredView()),
      ),
      GoRoute(path: '/exchek/verifyexpired', redirect: (context, state) => RouteUri.verifyExpiredRoute),

      GoRoute(
        name: RouteUri.resetExpiredRoute,
        path: RouteUri.resetExpiredRoute,
        pageBuilder:
            (context, state) =>
                fadeTransition(context: context, state: state, child: ForgotPasswordVerifyExpiredView()),
      ),
      GoRoute(path: '/exchek/resetexpired', redirect: (context, state) => RouteUri.resetExpiredRoute),
      GoRoute(
        name: RouteUri.signupRoute,
        path: RouteUri.signupRoute,
        pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: const SignUpView()),
      ),
      GoRoute(
        name: RouteUri.resendemailRoute,
        path: RouteUri.resendemailRoute,
        pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: const VerifyEmailView()),
      ),
      GoRoute(
        name: RouteUri.verifyemailRoute,
        path: RouteUri.verifyemailRoute,
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            Prefobj.preferences.put(Prefkeys.verifyemailToken, token);
          }
          return fadeTransition(context: context, state: state, child: const EmailConfirmView());
        },
      ),
      GoRoute(
        name: RouteUri.ekycconfirmationroute,
        path: RouteUri.ekycconfirmationroute,
        pageBuilder: (context, state) {
          final token = state.uri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            Prefobj.preferences.put(Prefkeys.verifyemailToken, token);
          }
          return fadeTransition(context: context, state: state, child: const EkySubmissionConfirmation());
        },
      ),
      GoRoute(
        path: '/exchek/verifyemail',
        redirect: (context, state) {
          final token = state.uri.queryParameters['token'];
          if (token != null && token.isNotEmpty) {
            Prefobj.preferences.put(Prefkeys.verifyemailToken, token);
          }
          return RouteUri.verifyemailRoute;
        },
      ),
      GoRoute(
        name: RouteUri.selectAccountTypeRoute,
        path: RouteUri.selectAccountTypeRoute,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: const AccountSelectionStep()),
      ),
      GoRoute(
        name: RouteUri.personalAccountSetupRoute,
        path: RouteUri.personalAccountSetupRoute,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: PersonalAccountSetupContent()),
      ),
      GoRoute(
        name: RouteUri.businessAccountSetupViewRoute,
        path: RouteUri.businessAccountSetupViewRoute,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: BusinessAccountSetupView()),
      ),
      GoRoute(
        name: RouteUri.businessAccountSuccessViewRoute,
        path: RouteUri.businessAccountSuccessViewRoute,
        pageBuilder:
            (context, state) =>
                fadeTransition(context: context, state: state, child: const BusinessAccountSetupSuccessView()),
      ),
      GoRoute(
        name: RouteUri.proceedWithKycViewRoute,
        path: RouteUri.proceedWithKycViewRoute,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: const ProceedWithKycView()),
      ),
      GoRoute(
        name: RouteUri.businessAccountKycSetupView,
        path: RouteUri.businessAccountKycSetupView,
        pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: EkycView()),
      ),
      GoRoute(
        name: RouteUri.platformTermsOfUseView,
        path: RouteUri.platformTermsOfUseView,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: PlatformTermsOfUseView()),
      ),
      //TODO: for now put on hold that selfie
      // GoRoute(
      //   name: RouteUri.selfieView,
      //   path: RouteUri.selfieView,
      //   pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: const SelfieView()),
      // ),
      // GoRoute(
      //   name: RouteUri.cameraView,
      //   path: RouteUri.cameraView,
      //   pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: const CameraView()),
      // ),
      GoRoute(
        name: RouteUri.personalAccountKycSetupView,
        path: RouteUri.personalAccountKycSetupView,
        pageBuilder:
            (context, state) => fadeTransition(context: context, state: state, child: PersonalAccountEkycView()),
      ),
      GoRoute(
        name: RouteUri.dashboardRoute,
        path: RouteUri.dashboardRoute,
        pageBuilder: (context, state) => fadeTransition(context: context, state: state, child: DashboardView()),
      ),
      GoRoute(
        path: RouteUri.logoutRoute,
        redirect: (context, state) async {
          await Prefobj.preferences.deleteAll();
          return RouteUri.loginRoute;
        },
      ),
    ],
    redirect: (context, state) async {
      final String? authToken = await Prefobj.preferences.get(Prefkeys.authToken);
      final bool isAuthenticated = authToken != null && authToken.isNotEmpty;
      final String currentLocation = state.matchedLocation;

      final bool isAuthRoute = unrestrictedRoutes.contains(currentLocation);

      final user = await Prefobj.preferences.get(Prefkeys.userKycDetail);
      final userDetail = jsonDecode(user ?? '{}');

      if (unrestrictedRoutes.contains(currentLocation)) {
        if (isAuthenticated && isAuthRoute) {
          // Check KYC status to determine where to redirect
          final String? kycStatus = await Prefobj.preferences.get(Prefkeys.finalKycStatus);
          if (kycStatus?.toUpperCase() == 'ACTIVE') {
            return RouteUri.dashboardRoute;
          } else if (kycStatus?.toUpperCase() == 'SUBMITTED') {
            return RouteUri.ekycconfirmationroute;
          } else {
            if (userDetail['user_type'] == "personal") {
              return RouteUri.personalAccountKycSetupView;
            } else {
              return RouteUri.businessAccountKycSetupView;
            }
          }
        }
        return null;
      }
      if (!isAuthenticated) {
        await Prefobj.preferences.put('last_attempted_route', currentLocation);
        return RouteUri.loginRoute;
      }
      if (authenticatedRoutes.contains(currentLocation)) {
        return null;
      }
      return RouteUri.loginRoute;
    },
  );
}
