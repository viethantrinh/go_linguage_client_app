import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_linguage/core/theme/app_color.dart';
import 'package:go_router/go_router.dart';

/// Widget loading đơn giản hiển thị hình ảnh và thanh tiến trình
class LoadingWidget extends StatelessWidget {
  /// Giá trị phần trăm loading (0.0 đến 1.0)
  final double progress;

  /// Đường dẫn đến hình ảnh hiển thị
  final String imagePath;

  /// Màu của thanh tiến trình
  final Color progressColor;

  const LoadingWidget({
    super.key,
    required this.progress,
    this.imagePath = 'assets/images/loading_image.png',
    this.progressColor = AppColor.yellow,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Hình ảnh ở giữa
          Image.asset(
            imagePath,
            width: 200,
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.hourglass_bottom,
                size: 120,
                color: progressColor,
              );
            },
          ),
          const SizedBox(height: 40),

          // Thanh tiến trình
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Màn hình loading toàn màn hình
class LoadingScreen extends StatelessWidget {
  /// Giá trị phần trăm loading (0.0 đến 1.0)
  final double progress;

  /// Đường dẫn đến hình ảnh hiển thị
  final String imagePath;

  const LoadingScreen({
    super.key,
    required this.progress,
    this.imagePath = 'assets/images/img_logo.png',
  });

  @override
  Widget build(BuildContext context) {
    // Ẩn thanh trạng thái và thanh điều hướng
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return Scaffold(
      // Đảm bảo không có appBar
      appBar: null,
      // Ẩn thanh điều hướng dưới cùng
      bottomNavigationBar: null,
      // Mở rộng body ra toàn màn hình
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: LoadingWidget(
        progress: progress,
        imagePath: imagePath,
      ),
    );
  }
}

/// Extension để dễ dàng hiển thị màn hình loading toàn màn hình
extension LoadingScreenExtension on BuildContext {
  /// Hiển thị màn hình loading toàn màn hình
  void showFullScreenLoading({
    required double progress,
    String imagePath = 'assets/images/img_logo.png',
  }) {
    // Sử dụng Navigator.push với MaterialPageRoute để hiển thị màn hình mới
    Navigator.of(this, rootNavigator: true).push(
      PageRouteBuilder(
        // Đảm bảo route mới thay thế hoàn toàn route hiện tại
        fullscreenDialog: true,
        opaque: true,
        // Không cho phép quay lại bằng cử chỉ vuốt
        barrierDismissible: false,
        // Tắt animation để tránh hiệu ứng chuyển tiếp
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, animation, secondaryAnimation) => LoadingScreen(
          progress: progress,
          imagePath: imagePath,
        ),
      ),
    );
  }

  /// Đóng màn hình loading
  void closeLoading() {
    Navigator.of(this, rootNavigator: true).pop();
    // Khôi phục thanh trạng thái và thanh điều hướng
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}

/// Hiển thị overlay loading (không thay đổi màn hình hiện tại)
OverlayEntry showOverlayLoading(
  BuildContext context, {
  required double progress,
  String imagePath = 'assets/images/img_logo.png',
}) {
  final overlayState = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => Material(
      color: Colors.white,
      child: LoadingWidget(
        progress: progress,
        imagePath: imagePath,
      ),
    ),
  );

  overlayState.insert(entry);
  return entry;
}

/// Ví dụ cách sử dụng:
///
/// ```dart
/// // Hiển thị màn hình loading toàn màn hình
/// context.showFullScreenLoading(
///   progress: 0.7,
///   imagePath: 'assets/images/img_logo.png',
/// );
///
/// // Đóng màn hình loading khi hoàn tất
/// context.closeLoading();
///
/// // Hoặc hiển thị overlay loading (không thay đổi màn hình hiện tại)
/// final overlayEntry = showOverlayLoading(
///   context,
///   progress: 0.7,
///   imagePath: 'assets/images/img_logo.png',
/// );
///
/// // Đóng overlay loading khi hoàn tất
/// overlayEntry.remove();
/// ```
