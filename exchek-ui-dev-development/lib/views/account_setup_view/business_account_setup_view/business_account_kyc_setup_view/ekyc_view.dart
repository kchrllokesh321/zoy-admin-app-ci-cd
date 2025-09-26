import 'dart:convert';
import 'package:exchek/core/utils/exports.dart';

// Global variable to track the last step for animation direction
KycVerificationSteps? _lastEkycStep;
KycVerificationSteps? _previousEkycStep;

class EkycView extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  final FocusNode _keyFocus = FocusNode();

  EkycView({super.key});

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
    context.read<BusinessAccountSetupBloc>().add(LoadBusinessKycFromLocal());
  }

  final Future<String?> _userFuture = Prefobj.preferences.get(Prefkeys.userKycDetail);

  @override
  Widget build(BuildContext context) {
    // Ensure the Focus widget grabs focus so key events are received without refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_keyFocus.hasFocus) {
        _keyFocus.requestFocus();
      }
    });
    return FutureBuilder(
      future:
          (() async {
            await _loadKyc(context);
            final userDetailString = await Prefobj.preferences.get(Prefkeys.userKycDetail);
            final userDetail = jsonDecode(userDetailString!);
            final businessDetails = userDetail['business_details'];
            final businessType = businessDetails != null ? businessDetails['business_type'] : null;
            return {'userDetail': userDetail, 'businessType': businessType};
          })(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: AppLoaderWidget());
        }

        final data = snapshot.data!;
        final businessType = data['businessType'];

        return BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
          builder: (context, state) {
            return FutureBuilder<List<KycVerificationSteps>>(
              future: Future.value(KycStepUtils.getStepsForBusinessType(businessType ?? '', state)),
              builder: (context, stepsSnapshot) {
                if (!stepsSnapshot.hasData) {
                  return const Center(child: AppLoaderWidget());
                }

                final steps = stepsSnapshot.data!;

                KycVerificationSteps effectiveCurrentStep = state.currentKycVerificationStep;
                final isCINStepShow =
                    businessType == 'company' ||
                    businessType == 'limited_liability_partnership' ||
                    businessType == 'partnership';
                if (!isCINStepShow &&
                    state.currentKycVerificationStep == KycVerificationSteps.companyIncorporationVerification) {
                  final cinIndex = KycVerificationSteps.values.indexOf(
                    KycVerificationSteps.companyIncorporationVerification,
                  );
                  // Find the next valid step after IEC in the filtered steps list
                  final nextStep = steps.firstWhere(
                    (step) => KycVerificationSteps.values.indexOf(step) > cinIndex,
                    orElse: () => steps.first,
                  );
                  effectiveCurrentStep = nextStep;
                } else if (!steps.contains(state.currentKycVerificationStep)) {
                  // If current step is not in the filtered steps list, find the next valid step
                  final currentIndex = KycVerificationSteps.values.indexOf(state.currentKycVerificationStep);
                  final nextStep = steps.firstWhere(
                    (step) => KycVerificationSteps.values.indexOf(step) > currentIndex,
                    orElse: () => steps.first,
                  );
                  effectiveCurrentStep = nextStep;
                } else if (businessType == 'company') {
                  // For company, ensure we follow the custom step order
                  if (!steps.contains(effectiveCurrentStep)) {
                    effectiveCurrentStep = steps.first;
                  }
                }

                return ResponsiveScaffold(
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(ResponsiveHelper.isWebAndIsNotMobile(context) ? 99 : 59),
                    child: ExchekAppBar(
                      appBarContext: context,
                      title: getStepTitle(
                        context: context,
                        step: effectiveCurrentStep,
                        state: state,
                        businessType: businessType,
                      ),
                      onBackPressed: () {
                        final bloc = context.read<BusinessAccountSetupBloc>();
                        final index = steps.indexOf(effectiveCurrentStep);
                        if (index > 0) {
                          bloc.add(NavigateToPreviousKycStep());
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
                      email: '',
                      isBusinessUser: true,
                      onLogout: () {
                        // TODO: Implement logout logic
                      },
                    ),
                  ),
                  body: BackgroundImage(
                    imagePath: Assets.images.svgs.other.appBg.path,
                    child: BlocListener<BusinessAccountSetupBloc, BusinessAccountSetupState>(
                      listenWhen:
                          (previous, current) =>
                              previous.currentKycVerificationStep != current.currentKycVerificationStep,
                      listener: (context, state) {
                        // Store the previous step before updating to current
                        _previousEkycStep = _lastEkycStep;
                        _lastEkycStep = state.currentKycVerificationStep;

                        if (_scrollController.hasClients) {
                          _scrollController.animateTo(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
                        builder: (context, state) {
                          KycVerificationSteps effectiveCurrentStep = state.currentKycVerificationStep;
                          final isCINStepShow =
                              businessType == 'company' ||
                              businessType == 'limited_liability_partnership' ||
                              businessType == 'partnership';
                          if (!isCINStepShow &&
                              state.currentKycVerificationStep ==
                                  KycVerificationSteps.companyIncorporationVerification) {
                            final cinIndex = KycVerificationSteps.values.indexOf(
                              KycVerificationSteps.companyIncorporationVerification,
                            );
                            // Find the next valid step after IEC in the filtered steps list
                            final nextStep = steps.firstWhere(
                              (step) => KycVerificationSteps.values.indexOf(step) > cinIndex,
                              orElse: () => steps.first,
                            );
                            effectiveCurrentStep = nextStep;
                          } else if (!steps.contains(state.currentKycVerificationStep)) {
                            // If current step is not in the filtered steps list, find the next valid step
                            final currentIndex = KycVerificationSteps.values.indexOf(state.currentKycVerificationStep);
                            final nextStep = steps.firstWhere(
                              (step) => KycVerificationSteps.values.indexOf(step) > currentIndex,
                              orElse: () => steps.first,
                            );
                            effectiveCurrentStep = nextStep;
                          } else if (businessType == 'company') {
                            // For company, ensure we follow the custom step order
                            if (!steps.contains(effectiveCurrentStep)) {
                              effectiveCurrentStep = steps.first;
                            }
                          }

                          if (state.isLocalDataLoading) {
                            return const Center(child: AppLoaderWidget());
                          }

                          return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              // Refocus to ensure keyboard events are captured after any click
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
                                  if (state.isekycCollapsed && ResponsiveHelper.isWebAndIsNotMobile(context))
                                    StepperSlider<KycVerificationSteps>(
                                      currentStep: effectiveCurrentStep,
                                      steps: steps,
                                      title: getStepTitle(
                                        context: context,
                                        step: effectiveCurrentStep,
                                        state: state,
                                        businessType: businessType,
                                      ),
                                      isShowTitle: true,
                                      isFullSlider: true,
                                    ),
                                  if (!ResponsiveHelper.isWebAndIsNotMobile(context)) ...[
                                    _buildStepSlider(context, state, effectiveCurrentStep, steps),
                                    buildSizedBoxH(20.0),
                                  ],
                                  Expanded(
                                    child: NotificationListener<ScrollNotification>(
                                      onNotification: (scrollNotification) {
                                        if (_scrollController.hasClients) {
                                          final isCollapsed =
                                              scrollNotification.metrics.pixels > (83.0 - kToolbarHeight);
                                          context.read<BusinessAccountSetupBloc>().add(
                                            BusinessEkycAppBarCollapseChanged(isCollapsed),
                                          );
                                        }
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
                                                              : _buildStepSlider(
                                                                context,
                                                                state,
                                                                effectiveCurrentStep,
                                                                steps,
                                                              ),
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
                                            effectiveCurrentStep,
                                            isCINStepShow,
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
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  SlideDirection _getSlideDirection(KycVerificationSteps currentStep, List<KycVerificationSteps> steps) {
    if (_previousEkycStep == null) {
      return SlideDirection.rightToLeft; // Default for first load
    }

    final currentIndex = steps.indexOf(currentStep);
    final previousIndex = steps.indexOf(_previousEkycStep!);

    if (currentIndex == -1 || previousIndex == -1) {
      // Fallback to enum order
      final currentEnumIndex = KycVerificationSteps.values.indexOf(currentStep);
      final previousEnumIndex = KycVerificationSteps.values.indexOf(_previousEkycStep!);
      return currentEnumIndex > previousEnumIndex ? SlideDirection.rightToLeft : SlideDirection.leftToRight;
    }

    // When going forward (higher index), slide from right to left
    // when going backward (lower index), slide from left to right
    final isForward = currentIndex > previousIndex;

    return isForward ? SlideDirection.rightToLeft : SlideDirection.leftToRight;
  }

  List<Widget> _buildStepContentAsSlivers(
    BuildContext context,
    BusinessAccountSetupState state,
    KycVerificationSteps effectiveCurrentStep,
    bool isCINStepShow,
    List<KycVerificationSteps> steps,
  ) {
    switch (effectiveCurrentStep) {
      case KycVerificationSteps.panVerification:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('panVerification_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  _buildStepOne(state, context),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.aadharPanVerification:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('aadharPanVerification_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  _buildStepTwo(state, context),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.registeredOfficeAddress:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('registeredOfficeAddress_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  RegisterBusinessAddressView(),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.annualTurnoverDeclaration:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('annualTurnoverDeclaration_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  AnnualTurnoverView(scrollController: _scrollController),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.iecVerification:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('iecVerification_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [IceVerificationView(), _buildBackButton(context, state, steps, effectiveCurrentStep)],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.companyIncorporationVerification:
        if (!isCINStepShow) return [];
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('companyIncorporationVerification_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  CompanyIncorporationVerificationView(),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.bankAccountLinking:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('bankAccountLinking_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [BankAccountLinkingView(), _buildBackButton(context, state, steps, effectiveCurrentStep)],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.contactInformation:
        if (!steps.contains(KycVerificationSteps.contactInformation)) return [];
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('contactInformation_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [ContactInformation(), _buildBackButton(context, state, steps, effectiveCurrentStep)],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.beneficialOwnershipVerification:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('beneficialOwnershipVerification_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  BeneficialOwnershipVerificationView(),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
      case KycVerificationSteps.businessDocumentsVerification:
        return [
          SliverToBoxAdapter(
            child: EntranceFader(
              key: ValueKey('businessDocumentsVerification_${effectiveCurrentStep}_$_previousEkycStep'),
              duration: const Duration(milliseconds: 200),
              slideDirection: _getSlideDirection(effectiveCurrentStep, steps),
              slideDistance: 100.0,
              child: Stack(
                children: [
                  BusinessDocumentsVerificationView(),
                  _buildBackButton(context, state, steps, effectiveCurrentStep),
                ],
              ),
            ),
          ),
        ];
    }
  }

  Widget _buildBackButton(
    BuildContext context,
    BusinessAccountSetupState state,
    List<KycVerificationSteps> steps,
    KycVerificationSteps effectiveCurrentStep,
  ) {
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
              // final bloc = context.read<BusinessAccountSetupBloc>();
              // bloc.add(NavigateToPreviousKycStep());
              final bloc = context.read<BusinessAccountSetupBloc>();
              final index = steps.indexOf(effectiveCurrentStep);
              if (index > 0) {
                bloc.add(NavigateToPreviousKycStep());
              } else {
                if (kIsWeb) {
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

  Widget _buildStepSlider(
    BuildContext context,
    BusinessAccountSetupState state,
    KycVerificationSteps effectiveCurrentStep,
    List<KycVerificationSteps> steps,
  ) {
    return FutureBuilder(
      future: _userFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final userDetail = jsonDecode(snapshot.data!);
        final businessDetails = userDetail['business_details'];
        final businessType = businessDetails != null ? businessDetails['business_type'] : null;

        return Container(
          constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxSliderWidthWidth(context)),
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 20 : 0.0),
          child: Column(
            children: [
              buildSizedBoxH(kIsWeb ? 30.0 : 26.0),
              StepperSlider<KycVerificationSteps>(
                currentStep: effectiveCurrentStep,
                steps: steps,
                title: getStepTitle(
                  context: context,
                  step: effectiveCurrentStep,
                  state: state,
                  businessType: businessType,
                ),
                isShowTitle: !ResponsiveHelper.isWebAndIsNotMobile(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepTwo(BusinessAccountSetupState state, BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }

        final userDetail = jsonDecode(snapshot.data!);
        final businessDetails = userDetail['business_details'];
        final businessType = businessDetails != null ? businessDetails['business_type'] : null;

        // if (businessType == Lang.of(context).lbl_huf) {
        //   return HufPanVerificationView();
        // } else {
        //   return PanDetailView();
        // }
        if (businessType == 'hindu_undivided_family') {
          return KartaPanVerificationView();
        } else if (businessType == 'limited_liability_partnership') {
          return PanDetailView();
        } else if (businessType == 'partnership') {
          return PanDetailView();
        } else if (businessType == 'sole_proprietor') {
          return ProprietorAadharVerificationView();
        } else {
          return PanDetailView();
        }
      },
    );
  }

  Widget _buildStepOne(BusinessAccountSetupState state, BuildContext context) {
    return FutureBuilder(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return CompanyPanDetail();
        }
        final userDetail = jsonDecode(snapshot.data!);
        final businessDetails = userDetail['business_details'];
        final businessType = businessDetails != null ? businessDetails['business_type'] : null;

        if (businessType == 'hindu_undivided_family') {
          return HufPanVerificationView();
        } else if (businessType == 'limited_liability_partnership') {
          return LLPPanVerificationView();
        } else if (businessType == 'partnership') {
          return PartnershipFirmPanVerificationView();
        } else if (businessType == 'sole_proprietor') {
          return SoleProprietorshipPanVerificationView();
        } else {
          return CompanyPanDetail();
        }
      },
    );
  }

  String getStepTitle({
    required BuildContext context,
    required KycVerificationSteps step,
    required BusinessAccountSetupState state,
    required String businessType,
  }) {
    switch (step) {
      case KycVerificationSteps.panVerification:
        // if (businessType == 'HUF (Hindu Undivided Family)') {
        //   return "HUF PAN";
        // } else if (businessType == 'LLP (Limited Liability Partnership)') {
        //   return "Limited Liability Partnership (LLP) PAN";
        // } else if (businessType == 'Partnership Firm') {
        //   return "Partnership Firm PAN";
        // } else if (businessType == 'Sole Proprietorship') {
        //   return "Sole Proprietorship PAN";
        // }
        return "Business PAN Verification";
      case KycVerificationSteps.aadharPanVerification:
        if (businessType == 'hindu_undivided_family') {
          return "Authorized Representative PAN";
        } else if (businessType == 'limited_liability_partnership') {
          return "Identification of Partner";
        } else if (businessType == 'partnership') {
          return "Identification of Partner";
        } else if (businessType == 'sole_proprietor') {
          return "Identity Verification";
        }
        return "Identification of Directors";
      // return businessType == Lang.of(context).lbl_huf ? "Karta's PAN" : "Identification of Directors";
      case KycVerificationSteps.registeredOfficeAddress:
        return "Registered Office Address";
      case KycVerificationSteps.annualTurnoverDeclaration:
        return "Annual Turnover Declaration";
      case KycVerificationSteps.iecVerification:
        return "IEC number and certificate upload";
      case KycVerificationSteps.companyIncorporationVerification:
        // return "Company Incorporation Verification";
        if (businessType == 'limited_liability_partnership') {
          return "LLP Registration Verification";
        } else if (businessType == 'partnership') {
          return "Partnership Verification";
        }
        return "Company Incorporation Verification";
      case KycVerificationSteps.bankAccountLinking:
        return "Bank Account Linking";
      case KycVerificationSteps.contactInformation:
        return "Contact Information";
      case KycVerificationSteps.beneficialOwnershipVerification:
        return "Beneficial Ownership Declaration";
      case KycVerificationSteps.businessDocumentsVerification:
        return "Business Documents Verification";
    }
  }
}
