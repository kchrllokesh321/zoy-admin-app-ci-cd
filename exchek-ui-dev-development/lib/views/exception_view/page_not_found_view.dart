import 'package:exchek/core/utils/exports.dart';

class PageNotFoundView extends StatelessWidget {
  const PageNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: ResponsiveHelper.isWebAndIsNotMobile(context) ? ExchekAppBar(appBarContext: context) : null,
      backgroundColor: Theme.of(context).customColors.fillColor,
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          exit(0);
        },
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 20.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: ResponsiveHelper.getMaxAuthFormWidth(context)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildPageNotFoundHeader(context),
                      buildSizedBoxH(50.0),
                      _buildContentImage(context),
                      buildSizedBoxH(50.0),
                      _buildBackButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageNotFoundHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          Lang.of(context).lbl_oops,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 32, tablet: 50, desktop: 60),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        buildSizedBoxH(14.0),
        Text(
          Lang.of(context).lbl_page_not_found_universe,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: ResponsiveHelper.getFontSize(context, mobile: 20, tablet: 22, desktop: 26),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContentImage(BuildContext context) {
    return Center(
      child: CustomImageView(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        imagePath: Assets.images.svgs.other.error404.path,
        height: 230.0,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return Center(
      child: CustomElevatedButton(
        width: 150,
        text: Lang.of(context).lbl_back_to_home,
        borderRadius: 20.0,
        buttonTextStyle: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(color: Theme.of(context).customColors.fillColor, fontSize: 16),
        onPressed: () {},
      ),
    );
  }

  EdgeInsets boxPadding(BuildContext context) {
    if (ResponsiveHelper.isDesktop(context)) {
      return const EdgeInsets.symmetric(horizontal: 36);
    } else if (ResponsiveHelper.isTablet(context)) {
      return const EdgeInsets.symmetric(horizontal: 30);
    } else {
      return const EdgeInsets.symmetric(horizontal: 20);
    }
  }
}
