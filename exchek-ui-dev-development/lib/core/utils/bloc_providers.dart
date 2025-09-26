import 'package:exchek/core/themes/bloc/theme_bloc.dart';
import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/repository/business_user_kyc_repository.dart';
import 'package:exchek/repository/dashboard_repository.dart';
import 'package:exchek/repository/invoice_repository.dart';
import 'package:exchek/repository/personal_user_kyc_repository.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_bloc.dart';
import 'package:exchek/viewmodels/invoice_bloc/invoice_event.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/clients_bloc/clients_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:exchek/viewmodels/profile_bloc/profile_dropdown_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_bloc.dart';
import 'package:exchek/viewmodels/main_dashboard_blocs/transection_bloc/transection_event.dart';
import 'package:exchek/repository/clients_repository.dart';

class BlocProviders extends StatelessWidget {
  final Widget child;

  const BlocProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocaleBloc>(create: (context) => LocaleBloc()..add(SetLocale(locale: Locale('en')))),
        BlocProvider<ThemeBloc>(
          create: (context) => ThemeBloc()..add(InitializeTheme(isDarkThemeOn: false, followSystemTheme: true)),
        ),
        BlocProvider(create: (_) => CheckConnectionCubit()..initializeConnectivity()),
        BlocProvider(
          create: (_) => AuthBloc(authRepository: AuthRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config())),
        ),
        BlocProvider(
          create:
              (_) => BusinessAccountSetupBloc(
                personalUserKycRepository: PersonalUserKycRepository(apiClient: ApiClient()),
                businessUserKycRepository: BusinessUserKycRepository(apiClient: ApiClient()),
                authRepository: AuthRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config()),
              ),
        ),

        BlocProvider(
          create:
              (context) => PersonalAccountSetupBloc(
                personalUserKycRepository: PersonalUserKycRepository(apiClient: ApiClient()),
                authRepository: AuthRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config()),
              )..add(PersonalInfoStepChanged(PersonalAccountSetupSteps.personalEntity)),
        ),
        BlocProvider(
          create:
              (_) =>
                  AccountTypeBloc(authRepository: AuthRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config())),
        ),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository: DashboardRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config()),)),
        BlocProvider(create: (_) => TransectionBloc()..add(LoadTransactionsRequested())),
        BlocProvider(
          create:
              (_) => ProfileDropdownBloc(
                authRepository: AuthRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config()),
              ),
        ),
        BlocProvider<InvoiceBloc>(
          create:
              (context) =>
                  InvoiceBloc(invoiceRepository: InvoiceRepository(apiClient: ApiClient()))
                    ..add(const InvoiceStarted()),
        ),
        BlocProvider(
          create:
              (_) => ClientsBloc(
                clientsRepository: ClientsRepository(apiClient: ApiClient(), oauth2Config: OAuth2Config()),
                personalUserKycRepository: PersonalUserKycRepository(apiClient: ApiClient()),
              ),
        ),
      ],
      child: child,
    );
  }
}
