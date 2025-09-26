import 'package:exchek/core/utils/exports.dart';
import 'package:exchek/viewmodels/account_setup_bloc/personal_account_setup_bloc/personal_account_setup_bloc.dart';
import 'package:exchek/widgets/common_widget/password_checklist_item.dart';

class PersonalSetPasswordView extends StatelessWidget {
  const PersonalSetPasswordView({super.key});

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
    return BlocConsumer<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      listener: (context, state) {
        if (state.isSignupSuccess == true) {
          if (kIsWeb) {
            context.replace(RouteUri.businessAccountSuccessViewRoute);
          } else {
            GoRouter.of(context).pushReplacement(RouteUri.businessAccountSuccessViewRoute);
          }

          BlocProvider.of<PersonalAccountSetupBloc>(context).add(PersonalResetSignupSuccess());
        }
      },
      builder: (context, state) {
        return Focus(
          autofocus: kIsWeb,
          onKeyEvent: _onKeyEvent,
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxTileWidth(context)),
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: ResponsiveHelper.isMobile(context) ? (kIsWeb ? 30.0 : 20) : 0.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSizedBoxH(20.0),
                      _buildSelectionTitleAndDescription(
                        context: context,
                        title: Lang.of(context).lbl_create_strong_password,
                        description: Lang.of(context).lbl_ensure_secure_account_access,
                      ),
                      buildSizedBoxH(30.0),
                      Form(
                        key: state.sePasswordFormKey,
                        child: Column(
                          children: [
                            _buildCreatePasswordField(context, state),
                            AnimatedBuilder(
                              animation: state.passwordController,
                              builder: (context, _) {
                                final currentPassword = state.passwordController.text;
                                return currentPassword.isNotEmpty
                                    ? Column(
                                      children: [
                                        buildSizedBoxH(24.0),
                                        AnimatedContainer(
                                          duration: const Duration(milliseconds: 300),
                                          padding: const EdgeInsets.all(16),
                                          // Removed background color and border
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final checklistItems = [
                                                PasswordChecklistItem(
                                                  'One lowercase character',
                                                  currentPassword.contains(RegExp(r'[a-z]')),
                                                ),
                                                PasswordChecklistItem(
                                                  'One number',
                                                  currentPassword.contains(RegExp(r'\d')),
                                                ),
                                                PasswordChecklistItem(
                                                  'One uppercase character',
                                                  currentPassword.contains(RegExp(r'[A-Z]')),
                                                ),
                                                PasswordChecklistItem(
                                                  'One special character',
                                                  currentPassword.contains(RegExp(r'[^A-Za-z0-9]')),
                                                ),
                                                PasswordChecklistItem(
                                                  '8 characters minimum',
                                                  currentPassword.length >= 8,
                                                ),
                                              ];
                                              if (!kIsWeb) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children:
                                                      checklistItems
                                                          .map(
                                                            (item) => Padding(
                                                              padding: const EdgeInsets.only(bottom: 12),
                                                              child: item,
                                                            ),
                                                          )
                                                          .toList(),
                                                );
                                              } else {
                                                return Wrap(
                                                  spacing: 16,
                                                  runSpacing: 16,
                                                  children:
                                                      checklistItems
                                                          .map(
                                                            (item) => SizedBox(
                                                              width: (constraints.maxWidth - 16) / 2,
                                                              child: item,
                                                            ),
                                                          )
                                                          .toList(),
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    )
                                    : SizedBox.shrink();
                              },
                            ),
                            buildSizedBoxH(24.0),

                            _buildConfirmPasswordField(context, state),
                          ],
                        ),
                      ),
                      buildSizedBoxH(30.0),
                      _buildSingupButton(),
                      buildSizedBoxH(kIsWeb ? 80.0 : 40.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSelectionTitleAndDescription({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 24, tablet: 30, desktop: 32),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.32,
          ),
        ),
        buildSizedBoxH(14.0),
        Text(
          description,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w500,
            color: Theme.of(context).customColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildCreatePasswordField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_create_password,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.obscurePassword,
          controller: state.passwordController,
          textInputAction: TextInputAction.next,
          validator: ExchekValidations.validatePassword,
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForPasswordValidation,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          suffixIcon: Container(
            padding: EdgeInsets.only(right: 14.0),
            color: Colors.transparent,
            alignment: Alignment.center,
            child: CustomImageView(
              imagePath:
                  state.obscurePassword
                      ? Assets.images.svgs.icons.icEyeSlash.path
                      : Assets.images.svgs.icons.icEye.path,
              height: 17.0,
              width: 20.0,
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                BlocProvider.of<PersonalAccountSetupBloc>(context).add(TogglePasswordVisibility());
              },
            ),
          ),
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems:
                  editableTextState.contextMenuButtonItems
                      .where((item) => item.type != ContextMenuButtonType.paste)
                      .toList(),
            );
          },
          inputFormatters: [NoPasteFormatter()],
        ),
      ],
    );
  }

  Widget _buildConfirmPasswordField(BuildContext context, PersonalAccountSetupState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Lang.of(context).lbl_confirm_password,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 14, tablet: 15, desktop: 16),
            fontWeight: FontWeight.w400,
            height: 1.22,
          ),
        ),
        buildSizedBoxH(8.0),
        CustomTextInputField(
          context: context,
          type: InputType.password,
          obscuredText: state.obscureConfirmPassword,
          controller: state.confirmPasswordController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return ExchekValidations.validateConfirmPassword(state.passwordController.text, value);
          },
          shouldShowInfoForMessage: ExchekValidations.shouldShowInfoForConfirmPasswordValidation,
          contentPadding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
          suffixIcon: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              BlocProvider.of<PersonalAccountSetupBloc>(context).add(ToggleConfirmPasswordVisibility());
            },
            child: Container(
              padding: EdgeInsets.only(right: 14.0),
              color: Colors.transparent,
              alignment: Alignment.center,
              child: CustomImageView(
                imagePath:
                    state.obscureConfirmPassword
                        ? Assets.images.svgs.icons.icEyeSlash.path
                        : Assets.images.svgs.icons.icEye.path,
                height: 17.0,
                width: 20.0,
              ),
            ),
          ),
          contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
            return AdaptiveTextSelectionToolbar.buttonItems(
              anchors: editableTextState.contextMenuAnchors,
              buttonItems:
                  editableTextState.contextMenuButtonItems
                      .where((item) => item.type != ContextMenuButtonType.paste)
                      .toList(),
            );
          },
          inputFormatters: [NoPasteFormatter()],
          autovalidateMode: AutovalidateMode.onUserInteraction,
        ),
      ],
    );
  }

  Widget _buildSingupButton() {
    return BlocBuilder<PersonalAccountSetupBloc, PersonalAccountSetupState>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.centerRight,
          child: AnimatedBuilder(
            animation: Listenable.merge([state.passwordController, state.confirmPasswordController]),
            builder: (context, _) {
              final isFormValid =
                  state.passwordController.text.isNotEmpty &&
                  ExchekValidations.validateConfirmPassword(
                        state.passwordController.text,
                        state.confirmPasswordController.text,
                      ) ==
                      null;

              return CustomElevatedButton(
                isLoading: state.isLoading,
                isShowTooltip: true,
                tooltipMessage: Lang.of(context).lbl_tooltip_text,
                text: Lang.of(context).lbl_sign_up,
                buttonTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 16.0,
                  color: Theme.of(context).customColors.fillColor,
                  fontWeight: FontWeight.w500,
                ),
                borderRadius: 8.0,
                width: ResponsiveHelper.isMobile(context) ? double.maxFinite : 150,

                isDisabled: !isFormValid,
                onPressed:
                    isFormValid
                        ? () {
                          if (state.sePasswordFormKey.currentState!.validate()) {
                            BlocProvider.of<PersonalAccountSetupBloc>(context).add(PersonalPasswordSubmitted());
                          }
                        }
                        : null,
              );
            },
          ),
        );
      },
    );
  }
}
