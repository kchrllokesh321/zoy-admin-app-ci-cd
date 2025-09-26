import 'dart:convert';

import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_account_kyc_setup_view/personal_ice_verification_view.dart';

// Global variable to track the last step for animation direction
PersonalEKycVerificationSteps? _lastPersonalEkycStep;
PersonalEKycVerificationSteps? _previousPersonalEkycStep;

class PersonalAccountEkycView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _keyFocus = FocusNode();

  PersonalAccountEkycView({super.key});

  bool _isTextInputFocused() {
    final focused = FocusManager.instance.primaryFocus;
    final ctx = focused?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText;
  }

  void _scrollBy(double delta) {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    final target = (position.pixels + delta).clamp(0.0, position.maxScrollExtent);
    _scrollController.animateTo(target, duration: const Duration(milliseconds: 90), curve: Curves.easeOut);
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!kIsWeb) return KeyEventResult.ignored;
    if (_isTextInputFocused()) return KeyEventResult.ignored;

    const double lineDelta = 80.0;
    final bool isPressOrRepeat = event is KeyDownEvent || event is KeyRepeatEvent;

    if (isPressOrRepeat &&
        (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp)) {
      final delta = event.logicalKey == LogicalKeyboardKey.arrowDown ? lineDelta : -lineDelta;
      _scrollBy(delta);
      return KeyEventResult.handled;
    }

    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.pageDown || event.logicalKey == LogicalKeyboardKey.pageUp)) {
      if (_scrollController.hasClients) {
        final vp = _scrollController.position.viewportDimension;
        _scrollBy(event.logicalKey == LogicalKeyboardKey.pageDown ? vp * 0.9 : -vp * 0.9);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  Future<void> _loadKyc(BuildContext context) async {
    context.read<PersonalAccountSetupBloc>().add(LoadPersonalKycFromLocal());
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_keyFocus.hasFocus) {
        _keyFocus.requestFocus();
      }
    });
    return FutureBuilder(
      future:
          (() async {
            await _loadKyc(context);
            return await Prefobj.preferences.get(Prefkeys.userKycDetail);
          })(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: AppLoaderWidget());
        }

        final user = snapshot.data;
        final userDetail = jsonDecode(user!);
        final isFreelancer = userDetail['personal_details']['payment_purpose'] == 'freelancer';

        final steps =
            isFreelancer
                ? PersonalEKycVerificationSteps.values
                : PersonalEKycVerificationSteps.values
                    .where((step) => step != PersonalEKycVerificationSteps.iecVerification)
                    .toList();

        return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
          builder: (context, state) {
            // Use a local variable for the effective current step
            PersonalEKycVerificationSteps effectiveCurrentStep = state.currentKycVerificationStep;
            if (!isFreelancer && state.currentKycVerificationStep == PersonalEKycVerificationSteps.iecVerification) {
              final iecIndex = PersonalEKycVerificationSteps.values.indexOf(
                PersonalEKycVerificationSteps.iecVerification,
              );
              // Find the next valid step after IEC in the filtered steps list
              final nextStep = steps.firstWhere(
                (step) => PersonalEKycVerificationSteps.values.indexOf(step) > iecIndex,
                orElse: () => steps.first,
              );
              effectiveCurrentStep = nextStep;
            }

            return ResponsiveScaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(ResponsiveHelper.isWebAndIsNotMobile(context) ? 99 : 59),
                child: ExchekAppBar(
                  appBarContext: context,
                  title: getStepTitle(context: context, step: effectiveCurrentStep, state: state),
                  onBackPressed: () {
                    final bloc = context.read<PersonalAccountSetupBloc>();
                    final index = steps.indexOf(effectiveCurrentStep);
                    if (index > 0) {
                      bloc.add(PersonalKycStepChange(steps[index - 1]));
                    } else {
                      if (kIsWeb) {
                        GoRouter.of(context).go(RouteUri.proceedWithKycViewRoute);
                      } else {
                        GoRouter.of(context).pop();
                      }
                    }
                  },
                  showProfile: true,
                  userName: "",
                  isBusinessUser: false,
                  onLogout: () {},
                ),
              ),
              body: BackgroundImage(
                imagePath: Assets.images.svgs.other.appBg.path,
                child: BlocConsumer<PersonalAccountSetupBloc, PersonalAccountSetupState>(
                  listenWhen:
                      (previous, current) => previous.currentKycVerificationStep != current.currentKycVerificationStep,
                  listener: (context, state) {
                    // Store the previous step before updating to current
                    _previousPersonalEkycStep = _lastPersonalEkycStep;
                    _lastPersonalEkycStep = state.currentKycVerificationStep;

                    if (_scrollController.hasClients) {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  },

                  builder: (context, state) {
                    if (state.isLocalDataLoading) {
                      return const Center(child: AppLoaderWidget());
                    }
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (!_keyFocus.hasFocus) {
                          _keyFocus.requestFocus();
                        }
                      },
                      child: Focus(
                        focusNode: _keyFocus,
                        autofocus: kIsWeb,
                        onKeyEvent: _onKeyEvent,
                        child: Column(
                          children: [
                            if (state.isEkycCollapsed && ResponsiveHelper.isWebAndIsNotMobile(context))
                              StepperSlider<PersonalEKycVerificationSteps>(
                                currentStep: effectiveCurrentStep,
                                steps: steps,
                                title: getStepTitle(context: context, step: effectiveCurrentStep, state: state),
                                isShowTitle: true,
                                isFullSlider: true,
                              ),
                            if (!ResponsiveHelper.isWebAndIsNotMobile(context)) ...[
                              _buildStepSlider(context, state, steps, effectiveCurrentStep),
                              buildSizedBoxH(20.0),
                            ],
                            Expanded(
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (scrollNotification) {
                                  final isCollapsed = scrollNotification.metrics.pixels > (83.0 - kToolbarHeight);
                                  context.read<PersonalAccountSetupBloc>().add(
                                    PersonalEkycAppBarCollapseChanged(isCollapsed),
                                  );
                                  return false;
                                },
                                child: CustomScrollView(
                                  controller: _scrollController,
                                  slivers: [
                                    if (ResponsiveHelper.isWebAndIsNotMobile(context))
                                      SliverAppBar(
                                        pinned: true,
                                        surfaceTintColor: Colors.transparent,
                                        expandedHeight: 108.0,
                                        collapsedHeight: 56.0,
                                        flexibleSpace: FlexibleSpaceBar(
                                          background: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final isCollapsed = constraints.maxHeight <= kToolbarHeight + 10;
                                              return AnimatedSwitcher(
                                                duration: Duration(milliseconds: 200),
                                                child:
                                                    isCollapsed
                                                        ? SizedBox()
                                                        : _buildStepSlider(context, state, steps, effectiveCurrentStep),
                                              );
                                            },
                                          ),
                                        ),
                                        backgroundColor: Colors.transparent,
                                        elevation: 0,
                                      ),
                                    ..._buildStepContentAsSlivers(
                                      context,
                                      state,
                                      isFreelancer,
                                      effectiveCurrentStep,
                                      steps,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStepSlider(
    BuildContext context,
    PersonalAccountSetupState state,
    List<PersonalEKycVerificationSteps> steps,
    PersonalEKycVerificationSteps effectiveCurrentStep,
  ) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: ResponsiveHelper.getMaxFormWidth(context) + (ResponsiveHelper.isDesktop(context) ? 80.0 : 0),
      ),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isDesktop(context) ? 0 : 20.0),
      child: Column(
        children: [
          buildSizedBoxH(kIsWeb ? 30.0 : 26.0),
          StepperSlider<PersonalEKycVerificationSteps>(
            currentStep: effectiveCurrentStep,
            steps: steps,
            title: getStepTitle(context: context, step: effectiveCurrentStep, state: state),
            isShowTitle: !ResponsiveHelper.isWebAndIsNotMobile(context),
          ),
        ],
      ),
    );
  }

  SlideDirection _getPersonalSlideDirection(
    PersonalEKycVerificationSteps currentStep,
    List<PersonalEKycVerificationSteps> steps,
  ) {
    if (_previousPersonalEkycStep == null) {
      return SlideDirection.rightToLeft; // Default for first load
    }

    final currentIndex = steps.indexOf(currentStep);
    final previousIndex = steps.indexOf(_previousPersonalEkycStep!);

    if (currentIndex == -1 || previousIndex == -1) {
      // Fallback to enum order
      final currentEnumIndex = PersonalEKycVerificationSteps.values.indexOf(currentStep);
      final previousEnumIndex = PersonalEKycVerificationSteps.values.indexOf(_previousPersonalEkycStep!);
      return currentEnumIndex > previousEnumIndex ? SlideDirection.rightToLeft : SlideDirection.leftToRight;
    }

    // When going forward (higher index), slide from right to left
    // when going backward (lower index), slide from left to right
    final isForward = currentIndex > previousIndex;

    return isForward ? SlideDirection.rightToLeft : SlideDirection.leftToRight;
  }

  List<Widget> _buildStepContentAsSlivers(
    BuildContext context,
    PersonalAccountSetupState state,
    bool isFreelancer,
    PersonalEKycVerificationSteps effectiveCurrentStep,
    List<PersonalEKycVerificationSteps> steps,
  ) {
    // Get the steps list based on freelancer status
    // final steps =
    //     isFreelancer
    //         ? PersonalEKycVerificationSteps.values
    //         : PersonalEKycVerificationSteps.values
    //             .where((step) => step != PersonalEKycVerificationSteps.iecVerification)
    //             .toList();

    switch (effectiveCurrentStep) {
      case PersonalEKycVerificationSteps.identityVerification:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('identityVerification_$effectiveCurrentStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getPersonalSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(children: [PersonalIdentityVerificationView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case PersonalEKycVerificationSteps.panDetails:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('panDetails_$effectiveCurrentStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getPersonalSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(children: [PersonalPanDetailView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case PersonalEKycVerificationSteps.residentialAddress:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('residentialAddress_$effectiveCurrentStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getPersonalSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(children: [PersonalResidentialAddress(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case PersonalEKycVerificationSteps.annualTurnoverDeclaration:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('annualTurnoverDeclaration_$effectiveCurrentStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getPersonalSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  PersonalAnnualTurnoverDeclaration(scrollController: _scrollController),
                  _buildBackButton(context, state),
                ],
              ),
            ),
          ),
        ];
      case PersonalEKycVerificationSteps.iecVerification:
        if (!isFreelancer) return [];
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('iecVerification_$effectiveCurrentStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getPersonalSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(children: [PersonalIceVerificationView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case PersonalEKycVerificationSteps.bankAccountLinking:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('bankAccountLinking_$effectiveCurrentStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getPersonalSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(children: [PersonalBankAccountLinking(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      // case PersonalEKycVerificationSteps.selfie:
      //   return [
      //     SliverToBoxAdapter(child: Stack(children: [SelfieView(), _buildBackButton(context, state)])),
      //   ];
    }
  }

  Widget _buildBackButton(BuildContext context, PersonalAccountSetupState state) {
    if (ResponsiveHelper.isWebAndIsNotMobile(context)) {
      return Align(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: ResponsiveHelper.getMaxFormWidth(context) + (ResponsiveHelper.isDesktop(context) ? 80.0 : 0),
          ),
          padding: EdgeInsets.only(
            top: 25.0,
            left: ResponsiveHelper.isDesktop(context) ? 0 : 10.0,
            right: ResponsiveHelper.isDesktop(context) ? 0 : 10.0,
          ),

          alignment: Alignment.topLeft,
          child: CustomImageView(
            imagePath: Assets.images.svgs.icons.icArrowLeft.path,
            height: 24.0,
            onTap: () {
              final bloc = context.read<PersonalAccountSetupBloc>();
              final index = PersonalEKycVerificationSteps.values.indexOf(state.currentKycVerificationStep);
              if (index > 0) {
                bloc.add(PersonalKycStepChange(PersonalEKycVerificationSteps.values[index - 1]));
              } else {
                if (ResponsiveHelper.isWebAndIsNotMobile(context)) {
                  GoRouter.of(context).go(RouteUri.proceedWithKycViewRoute);
                } else {
                  GoRouter.of(context).pop();
                }
              }
            },
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  String getStepTitle({
    required BuildContext context,
    required PersonalEKycVerificationSteps step,
    required PersonalAccountSetupState state,
  }) {
    switch (step) {
      case PersonalEKycVerificationSteps.identityVerification:
        return "Identity Verification";
      case PersonalEKycVerificationSteps.panDetails:
        return "PAN Details";
      case PersonalEKycVerificationSteps.residentialAddress:
        return "Residential Address";
      case PersonalEKycVerificationSteps.annualTurnoverDeclaration:
        return "Annual Turnover Declaration";
      case PersonalEKycVerificationSteps.iecVerification:
        return "IEC number and certificate upload";
      case PersonalEKycVerificationSteps.bankAccountLinking:
        return "Bank Account Linking";
      // case PersonalEKycVerificationSteps.selfie:
      //   return "Selfie";
    }
  }
}
