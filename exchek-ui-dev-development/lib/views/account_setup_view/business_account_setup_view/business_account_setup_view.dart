import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/views/account_setup_view/business_account_setup_view/business_transaction_and_payment_preferences_view.dart';

class BusinessAccountSetupView extends StatelessWidget {
  BusinessAccountSetupView({super.key});

  final FocusNode _keyFocus = FocusNode();

  bool _isTextInputFocused() {
    final focused = FocusManager.instance.primaryFocus;
    final ctx = focused?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText;
  }

  void _scrollBy(BuildContext context, double delta) {
    final controller = context.read<BusinessAccountSetupBloc>().state.scrollController;
    if (!controller.hasClients) return;
    final position = controller.position;
    final target = (position.pixels + delta).clamp(0.0, position.maxScrollExtent);
    controller.animateTo(target, duration: const Duration(milliseconds: 90), curve: Curves.easeOut);
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (!kIsWeb) return KeyEventResult.ignored;
    if (_isTextInputFocused()) return KeyEventResult.ignored;

    const double lineDelta = 80.0;
    final bool isPressOrRepeat = event is KeyDownEvent || event is KeyRepeatEvent;

    if (isPressOrRepeat &&
        (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.arrowUp)) {
      final delta = event.logicalKey == LogicalKeyboardKey.arrowDown ? lineDelta : -lineDelta;
      _scrollBy(node.context!, delta);
      return KeyEventResult.handled;
    }

    if (event is KeyDownEvent &&
        (event.logicalKey == LogicalKeyboardKey.pageDown || event.logicalKey == LogicalKeyboardKey.pageUp)) {
      final controller = node.context!.read<BusinessAccountSetupBloc>().state.scrollController;
      if (controller.hasClients) {
        final vp = controller.position.viewportDimension;
        _scrollBy(node.context!, event.logicalKey == LogicalKeyboardKey.pageDown ? vp * 0.9 : -vp * 0.9);
        return KeyEventResult.handled;
      }
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // Ensure the Focus widget grabs focus so key events are received without refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_keyFocus.hasFocus) {
        _keyFocus.requestFocus();
      }
    });
    return ResponsiveScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ResponsiveHelper.isWebAndIsNotMobile(context) ? 99 : 59),
        child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
          builder:
              (context, state) => ExchekAppBar(
                appBarContext: context,
                title: getStepTitle(context: context, step: state.currentStep),
                onBackPressed: () {
                  final bloc = context.read<BusinessAccountSetupBloc>();
                  final index = BusinessAccountSetupSteps.values.indexOf(state.currentStep);
                  if (index > 0) {
                    bloc.add(StepChanged(BusinessAccountSetupSteps.values[index - 1]));
                  } else {
                    if (!ResponsiveHelper.isWebAndIsNotMobile(context)) {
                      GoRouter.of(context).go(RouteUri.selectAccountTypeRoute);
                    } else {
                      GoRouter.of(context).pop();
                    }
                  }
                },
              ),
        ),
      ),
      body: BlocBuilder<AccountTypeBloc, AccountTypeState>(
        builder: (context, accountTypeState) {
          return BackgroundImage(
            imagePath: Assets.images.svgs.other.appBg.path,
            child:
                accountTypeState.isLoading
                    ? AppLoaderWidget()
                    : BlocListener<BusinessAccountSetupBloc, BusinessAccountSetupState>(
                      listenWhen: (previous, current) => previous.currentStep != current.currentStep,
                      listener: (context, state) {
                        state.scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: BlocBuilder<BusinessAccountSetupBloc, BusinessAccountSetupState>(
                        builder: (context, state) {
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
                                  if (state.isCollapsed && ResponsiveHelper.isWebAndIsNotMobile(context))
                                    StepperSlider<BusinessAccountSetupSteps>(
                                      currentStep: state.currentStep,
                                      steps: BusinessAccountSetupSteps.values,
                                      title: getStepTitle(context: context, step: state.currentStep),
                                      isShowTitle: true,
                                      isFullSlider: true,
                                    ),
                                  if (!ResponsiveHelper.isWebAndIsNotMobile(context)) ...[
                                    _buildStepSlider(context, state),
                                    buildSizedBoxH(20.0),
                                  ],
                                  Expanded(
                                    child: NotificationListener<ScrollNotification>(
                                      onNotification: (scrollNotification) {
                                        final isCollapsed = scrollNotification.metrics.pixels > (83.0 - kToolbarHeight);
                                        context.read<BusinessAccountSetupBloc>().add(
                                          BusinessAppBarCollapseChanged(isCollapsed),
                                        );
                                        return false;
                                      },
                                      child: CustomScrollView(
                                        controller: state.scrollController,
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
                                                          isCollapsed ? SizedBox() : _buildStepSlider(context, state),
                                                    );
                                                  },
                                                ),
                                              ),
                                              backgroundColor: Colors.transparent,
                                              elevation: 0,
                                            ),
                                          ..._buildStepContentAsSlivers(context, state),
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
      ),
    );
  }

  Widget _buildStepSlider(BuildContext context, BusinessAccountSetupState state) {
    return Container(
      constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxSliderWidthWidth(context)),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 20 : 0.0),
      child: Column(
        children: [
          buildSizedBoxH(kIsWeb ? 30.0 : 26.0),
          StepperSlider<BusinessAccountSetupSteps>(
            currentStep: state.currentStep,
            steps: BusinessAccountSetupSteps.values,
            title: getStepTitle(context: context, step: state.currentStep),
            isShowTitle: !ResponsiveHelper.isWebAndIsNotMobile(context),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildStepContentAsSlivers(BuildContext context, BusinessAccountSetupState state) {
    switch (state.currentStep) {
      case BusinessAccountSetupSteps.businessEntity:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(children: [BusinessEntitySelectionView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case BusinessAccountSetupSteps.businessInformation:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(children: [BusinessInformationView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case BusinessAccountSetupSteps.transactionAndPaymentPreferences:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [BusinessTransactionAndPaymentPreferencesView(), _buildBackButton(context, state)],
              ),
            ),
          ),
        ];
      case BusinessAccountSetupSteps.setPassword:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(children: [BusinessAccountSetPassword(), _buildBackButton(context, state)]),
            ),
          ),
        ];
    }
  }

  Widget _buildBackButton(BuildContext context, BusinessAccountSetupState state) {
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
            width: 24.0,
            onTap: () {
              final bloc = context.read<BusinessAccountSetupBloc>();
              final index = BusinessAccountSetupSteps.values.indexOf(state.currentStep);
              if (index > 0) {
                bloc.add(StepChanged(BusinessAccountSetupSteps.values[index - 1]));
              } else {
                context.go(RouteUri.selectAccountTypeRoute);
              }
            },
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  String getStepTitle({required BuildContext context, required BusinessAccountSetupSteps step}) {
    switch (step) {
      case BusinessAccountSetupSteps.businessEntity:
        return Lang.of(context).lbl_getting_to_know_you;
      case BusinessAccountSetupSteps.businessInformation:
        return Lang.of(context).lbl_business_information;
      case BusinessAccountSetupSteps.transactionAndPaymentPreferences:
        return "Transaction and Payment Preferences";
      case BusinessAccountSetupSteps.setPassword:
        return Lang.of(context).lbl_set_password;
    }
  }
}
