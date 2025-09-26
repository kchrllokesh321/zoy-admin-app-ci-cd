// ignore_for_file: deprecated_member_use

import 'package:exchek/core/utils/exports.dart';

class CustomImageView extends StatelessWidget {
  ///[imagePath] is required parameter for showing image

  final String? imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final BoxFit? fit;
  final Alignment? alignment;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? radius;
  final BoxBorder? border;
  final BlendMode? colorBlendMode;
  final bool usePlaceholder;
  final Duration fadeInDuration;
  final Duration fadeOutDuration;

  const CustomImageView({
    super.key,
    this.imagePath,
    this.height,
    this.width,
    this.color,
    this.fit,
    this.alignment,
    this.onTap,
    this.radius,
    this.margin,
    this.border,
    this.colorBlendMode,
    this.usePlaceholder = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.fadeOutDuration = const Duration(milliseconds: 300),
  });

  @override
  Widget build(BuildContext context) {
    return alignment != null ? Align(alignment: alignment!, child: _buildWidget()) : _buildWidget();
  }

  Widget _buildWidget() {
    return Padding(padding: margin ?? EdgeInsets.zero, child: InkWell(onTap: onTap, child: _buildCircleImage()));
  }

  _buildCircleImage() {
    if (radius != null) {
      return ClipRRect(borderRadius: radius ?? BorderRadius.zero, child: _buildImageWithBorder());
    } else {
      return _buildImageWithBorder();
    }
  }

  _buildImageWithBorder() {
    if (border != null) {
      return Container(decoration: BoxDecoration(border: border, borderRadius: radius), child: _buildImageView());
    } else {
      return _buildImageView();
    }
  }

  Widget _buildImageView() {
    if (imagePath != null) {
      switch (imagePath!.imageType) {
        case ImageType.svg:
          return SizedBox(
            height: height,
            width: width,
            child: SvgPicture.asset(
              imagePath!,
              height: height,
              width: width,
              fit: fit ?? BoxFit.contain,
              color: color,
              errorBuilder: (context, error, stackTrace) {
                return SizedBox(
                  height: height,
                  width: width,
                  child: Icon(Icons.error_outline, color: Theme.of(context).customColors.errorColor),
                );
              },
            ),
          );
        case ImageType.file:
          return Image.file(File(imagePath!), height: height, width: width, fit: fit ?? BoxFit.cover, color: color);
        case ImageType.network:
          return CachedNetworkImage(
            height: height,
            width: width,
            fit: fit,
            imageUrl: imagePath!,
            filterQuality: FilterQuality.medium,
            color: color,
            repeat: ImageRepeat.noRepeat,
            placeholderFadeInDuration: fadeInDuration,
            fadeInDuration: fadeInDuration,
            fadeOutDuration: fadeOutDuration,
            colorBlendMode: colorBlendMode ?? BlendMode.srcOver,
            fadeOutCurve: Curves.easeOut,
            placeholder:
                usePlaceholder
                    ? (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade200,
                      highlightColor: Colors.grey.shade50,
                      child: Container(width: double.infinity, decoration: BoxDecoration(color: Colors.grey.shade200)),
                    )
                    : null,
            cacheManager: CacheManager(
              Config(
                'APP_NAME',
                stalePeriod: const Duration(days: 7),
                maxNrOfCacheObjects: 2000,
                repo: JsonCacheInfoRepository(databaseName: 'APP_NAME'),
                fileService: HttpFileService(),
              ),
            ),
            errorWidget:
                (context, url, error) =>
                    Container(width: double.infinity, decoration: BoxDecoration(color: Colors.grey.shade200)),
            // Assets.images.pngs.other.pngLogo.image(height: height, width: width, fit: fit ?? BoxFit.cover),
          );
        case ImageType.lottie:
          return Lottie.asset(imagePath!, height: height, width: width, fit: fit ?? BoxFit.cover);
        case ImageType.png:
        default:
          return Image.asset(
            imagePath!,
            height: height,
            width: width,
            fit: fit ?? BoxFit.cover,
            color: color,
            filterQuality: FilterQuality.medium,
            gaplessPlayback: true,
            alignment: Alignment.center,
          );
      }
    }
    return const SizedBox.shrink();
  }
}

extension ImageTypeExtension on String {
  ImageType get imageType {
    if (startsWith('http') || startsWith('https')) {
      return ImageType.network;
    } else if (endsWith('.svg')) {
      return ImageType.svg;
    } else if (endsWith('.json')) {
      return ImageType.lottie;
    } else if (startsWith('/data') || startsWith('/storage')) {
      return ImageType.file;
    } else {
      return ImageType.png;
    }
  }
}
