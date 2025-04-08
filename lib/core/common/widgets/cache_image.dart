import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:path/path.dart' as path;

/// A widget that displays an image from various sources with built-in caching.
///
/// This widget works similarly to the standard Image widget but provides caching
/// for both network and asset images. For network images, it uses flutter_cache_manager.
/// For asset images, it extracts them to app storage for faster loading in future.
class CacheImage extends StatefulWidget {
  /// Creates a widget that displays a cached image.
  const CacheImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.alignment = Alignment.center,
    this.repeat = ImageRepeat.noRepeat,
    this.matchTextDirection = false,
    this.cacheHeight,
    this.cacheWidth,
    this.filterQuality = FilterQuality.low,
    this.isAsset = false,
    this.memCacheHeight,
    this.memCacheWidth,
    this.gaplessPlayback = false,
    this.semanticLabel,
    this.excludeFromSemantics = false,
    this.frameBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.placeholderBuilder,
  });

  /// The URL or asset path of the image to display.
  final String imageUrl;

  /// If true, treats [imageUrl] as an asset path rather than a network URL.
  final bool isAsset;

  /// The width the image should be displayed at.
  final double? width;

  /// The height the image should be displayed at.
  final double? height;

  /// How the image should be inscribed into the space allocated during layout.
  final BoxFit? fit;

  /// The widget displayed while the target [imageUrl] is loading.
  final Widget? placeholder;

  /// The widget displayed when the target [imageUrl] failed loading.
  final Widget? errorWidget;

  /// The color to paint the image with.
  final Color? color;

  /// The blend mode used to apply [color] to the image.
  final BlendMode? colorBlendMode;

  /// How the image should be aligned within its bounds.
  final Alignment alignment;

  /// How to repeat the image if it doesn't fill the space.
  final ImageRepeat repeat;

  /// Whether to use the TextDirection to select the image direction.
  final bool matchTextDirection;

  /// The height at which to cache the image.
  final int? cacheHeight;

  /// The width at which to cache the image.
  final int? cacheWidth;

  /// The height at which to cache the image in memory.
  final int? memCacheHeight;

  /// The width at which to cache the image in memory.
  final int? memCacheWidth;

  /// The quality of filtering to apply to the image.
  final FilterQuality filterQuality;

  /// Whether to continue displaying the old image when a new image is loading.
  final bool gaplessPlayback;

  /// A semantic description of the image.
  final String? semanticLabel;

  /// Whether to exclude the image from the semantics tree.
  final bool excludeFromSemantics;

  /// A builder function for the frame of the image.
  final ImageFrameBuilder? frameBuilder;

  /// A builder function for the loading state.
  final ImageLoadingBuilder? loadingBuilder;

  /// A builder function for error state.
  final ImageErrorWidgetBuilder? errorBuilder;

  /// A builder function for the placeholder.
  final Widget Function(BuildContext context)? placeholderBuilder;

  /// Default cache manager instance used for all CacheImage widgets.
  static final DefaultCacheManager _cacheManager = DefaultCacheManager();

  @override
  State<CacheImage> createState() => _CacheImageState();
}

class _CacheImageState extends State<CacheImage> {
  File? _cachedImageFile;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  @override
  void didUpdateWidget(CacheImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl ||
        widget.isAsset != oldWidget.isAsset) {
      _loadImage();
    }
  }

  Future<void> _loadImage() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      if (widget.isAsset) {
        await _cacheAssetImage();
      } else {
        await _cacheNetworkImage();
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  Future<void> _cacheNetworkImage() async {
    try {
      final fileInfo =
          await CacheImage._cacheManager.getFileFromCache(widget.imageUrl);

      if (fileInfo == null) {
        // Not in cache, download and store
        final downloadedFile =
            await CacheImage._cacheManager.getSingleFile(widget.imageUrl);
        _cachedImageFile = downloadedFile;
      } else {
        // Use cached file
        _cachedImageFile = fileInfo.file;
      }
    } catch (e) {
      throw Exception('Failed to load network image: $e');
    }
  }

  Future<void> _cacheAssetImage() async {
    try {
      // Create a hash of the asset path for the cached filename
      final hash = md5.convert(utf8.encode(widget.imageUrl)).toString();
      final appDir = await getApplicationDocumentsDirectory();
      final extension = path.extension(widget.imageUrl);
      final cachedPath = '${appDir.path}/cached_assets/$hash$extension';
      final cachedFile = File(cachedPath);

      // Create directory if it doesn't exist
      await Directory('${appDir.path}/cached_assets').create(recursive: true);

      if (await cachedFile.exists()) {
        // Use cached file
        _cachedImageFile = cachedFile;
      } else {
        // Extract asset to app directory
        final data = await rootBundle.load(widget.imageUrl);
        final bytes = data.buffer.asUint8List();
        await cachedFile.writeAsBytes(bytes);
        _cachedImageFile = cachedFile;
      }
    } catch (e) {
      throw Exception('Failed to cache asset image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return widget.placeholderBuilder != null
          ? widget.placeholderBuilder!(context)
          : widget.placeholder ??
              Center(
                  child: Container(
                      width: widget.width,
                      height: widget.height,
                      decoration: BoxDecoration(
                        color: AppColor.line,
                        borderRadius: BorderRadius.circular(10),
                      )));
    }

    if (_hasError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(
            context, Exception('Failed to load image'), StackTrace.current);
      }
      return widget.errorWidget ?? const Icon(Icons.error);
    }

    if (widget.isAsset && _cachedImageFile == null) {
      // Fallback to direct asset loading if caching failed
      return Image.asset(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        matchTextDirection: widget.matchTextDirection,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        cacheHeight: widget.cacheHeight,
        cacheWidth: widget.cacheWidth,
        filterQuality: widget.filterQuality,
        gaplessPlayback: widget.gaplessPlayback,
        semanticLabel: widget.semanticLabel,
        excludeFromSemantics: widget.excludeFromSemantics,
        frameBuilder: widget.frameBuilder,
        errorBuilder: widget.errorBuilder,
      );
    } else if (!widget.isAsset && _cachedImageFile == null) {
      // Fallback to network image if caching failed
      return Image.network(
        widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        alignment: widget.alignment,
        repeat: widget.repeat,
        matchTextDirection: widget.matchTextDirection,
        color: widget.color,
        colorBlendMode: widget.colorBlendMode,
        filterQuality: widget.filterQuality,
        gaplessPlayback: widget.gaplessPlayback,
        semanticLabel: widget.semanticLabel,
        excludeFromSemantics: widget.excludeFromSemantics,
        frameBuilder: widget.frameBuilder,
        loadingBuilder: widget.loadingBuilder,
        errorBuilder: widget.errorBuilder,
      );
    }

    // Use cached file
    return Image.file(
      _cachedImageFile!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      alignment: widget.alignment,
      repeat: widget.repeat,
      matchTextDirection: widget.matchTextDirection,
      color: widget.color,
      colorBlendMode: widget.colorBlendMode,
      filterQuality: widget.filterQuality,
      gaplessPlayback: widget.gaplessPlayback,
      semanticLabel: widget.semanticLabel,
      excludeFromSemantics: widget.excludeFromSemantics,
      frameBuilder: widget.frameBuilder,
      errorBuilder: widget.errorBuilder,
      cacheHeight: widget.memCacheHeight,
      cacheWidth: widget.memCacheWidth,
    );
  }
}

/// Usage examples:
/// 
/// 1. For network images:
/// ```
/// CacheImage(
///   imageUrl: 'https://example.com/image.jpg',
///   width: 200,
///   height: 200,
/// )
/// ```
/// 
/// 2. For asset images:
/// ```
/// CacheImage(
///   imageUrl: 'assets/images/my_image.png',
///   isAsset: true,
///   width: 200,
///   height: 200,
/// )
/// ```
