import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/account_type_selection/account_type_selection_bloc.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_information_view.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_set_password_view.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_transaction_payment_reference_view.dart';
import 'package:exchek/views/account_setup_view/personal_account_setup_view/personal_entity_selection_view.dart';

class PersonalAccountSetupContent extends StatelessWidget {
  PersonalAccountSetupContent({super.key});

  final FocusNode _keyFocus = FocusNode();

  bool _isTextInputFocused() {
    final focused = FocusManager.instance.primaryFocus;
    final ctx = focused?.context;
    if (ctx == null) return false;
    return ctx.widget is EditableText;
  }

  void _scrollBy(BuildContext context, double delta) {
    final controller = context.read<PersonalAccountSetupBloc>().state.scrollController;
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
      final controller = node.context!.read<PersonalAccountSetupBloc>().state.scrollController;
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
    // final PageController _pageController = PageController(
    //   initialPage: context.read<PersonalAccountSetupBloc>().state.currentStep.index,
    // );

    // Ensure the Focus widget grabs focus so key events are received without refresh
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_keyFocus.hasFocus) {
        _keyFocus.requestFocus();
      }
    });

    return ResponsiveScaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(ResponsiveHelper.isWebAndIsNotMobile(context) ? 99 : 59),
        child: BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
          builder:
              (context, state) => ExchekAppBar(
                appBarContext: context,
                onClose: () {
                  // context.read<PersonalAccountSetupBloc>().add(
                  //   PersonalInfoStepChanged(PersonalAccountSetupSteps.personalEntity),
                  // );
                },
                // onHelp: () => _showHelpDialog(context, state.currentStep),
                title: getStepTitle(context, state.currentStep),
                onBackPressed: () {
                  final bloc = context.read<PersonalAccountSetupBloc>();
                  final index = PersonalAccountSetupSteps.values.indexOf(state.currentStep);
                  if (index > 0) {
                    bloc.add(PersonalInfoStepChanged(PersonalAccountSetupSteps.values[index - 1]));
                  } else {
                    if (kIsWeb) {
                      context.go(RouteUri.selectAccountTypeRoute);
                    } else {
                      context.pop();
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
                    : BlocListener<PersonalAccountSetupBloc, PersonalAccountSetupState>(
                      listenWhen: (previous, current) => previous.currentStep != current.currentStep,
                      listener: (context, state) {
                        state.scrollController.animateTo(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
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
                                    StepperSlider<PersonalAccountSetupSteps>(
                                      currentStep: state.currentStep,
                                      steps: PersonalAccountSetupSteps.values,
                                      title: getStepTitle(context, state.currentStep),
                                      isShowTitle: true,
                                      isFullSlider: true,
                                    ),
                                  if (!ResponsiveHelper.isWebAndIsNotMobile(context)) ...[
                                    _buildStepSliderAndBackButton(context, state),
                                    buildSizedBoxH(20.0),
                                  ],
                                  Expanded(
                                    child: NotificationListener<ScrollNotification>(
                                      onNotification: (scrollNotification) {
                                        final isCollapsed = scrollNotification.metrics.pixels > (83.0 - kToolbarHeight);
                                        context.read<PersonalAccountSetupBloc>().add(
                                          PersonalAppBarCollapseChanged(isCollapsed),
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
                                              expandedHeight:
                                                  ResponsiveHelper.isWebAndIsNotMobile(context) ? 108.0 : 60,
                                              collapsedHeight: 60.0,
                                              flexibleSpace: FlexibleSpaceBar(
                                                background: LayoutBuilder(
                                                  builder: (context, constraints) {
                                                    final isCollapsed = constraints.maxHeight <= kToolbarHeight + 10;
                                                    return !ResponsiveHelper.isWebAndIsNotMobile(context)
                                                        ? _buildStepSliderAndBackButton(context, state)
                                                        : AnimatedSwitcher(
                                                          duration: Duration(milliseconds: 200),
                                                          child:
                                                              isCollapsed
                                                                  ? SizedBox()
                                                                  : _buildStepSliderAndBackButton(context, state),
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

  Widget _buildStepSliderAndBackButton(BuildContext context, PersonalAccountSetupState state) {
    return Container(
      constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxSliderWidthWidth(context)),
      padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.isMobile(context) ? 20 : 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSizedBoxH(kIsWeb ? 30.0 : 26.0),
          StepperSlider<PersonalAccountSetupSteps>(
            currentStep: state.currentStep,
            steps: PersonalAccountSetupSteps.values,
            title: getStepTitle(context, state.currentStep),
            isShowTitle: !ResponsiveHelper.isWebAndIsNotMobile(context),
          ),
        ],
      ),
    );
  }

  String getStepTitle(BuildContext context, PersonalAccountSetupSteps step) {
    switch (step) {
      case PersonalAccountSetupSteps.personalEntity:
        return Lang.of(context).lbl_getting_to_know_you;
      case PersonalAccountSetupSteps.personalInformation:
        return Lang.of(context).lbl_personal_information;
      case PersonalAccountSetupSteps.personalTransactions:
        return Lang.of(context).lbl_transaction_preferences;
      case PersonalAccountSetupSteps.setPassword:
        return Lang.of(context).lbl_set_password;
    }
  }

  List<Widget> _buildStepContentAsSlivers(BuildContext context, PersonalAccountSetupState state) {
    switch (state.currentStep) {
      case PersonalAccountSetupSteps.personalEntity:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(children: [PersonalAccountPurposeView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case PersonalAccountSetupSteps.personalInformation:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(children: [PersonalLegalNameContactView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
      case PersonalAccountSetupSteps.personalTransactions:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                children: [PersonalTransactionAndPaymentPreferencesView(), _buildBackButton(context, state)],
              ),
            ),
          ),
        ];
      case PersonalAccountSetupSteps.setPassword:
        return [
          SliverToBoxAdapter(
            child: SizedBox(
              width: double.infinity,
              child: Stack(children: [PersonalSetPasswordView(), _buildBackButton(context, state)]),
            ),
          ),
        ];
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
            width: 24.0,
            onTap: () {
              final bloc = context.read<PersonalAccountSetupBloc>();
              final index = PersonalAccountSetupSteps.values.indexOf(state.currentStep);
              if (index > 0) {
                bloc.add(PersonalInfoStepChanged(PersonalAccountSetupSteps.values[index - 1]));
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
}
