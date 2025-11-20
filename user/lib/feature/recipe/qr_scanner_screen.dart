import '../scan/barcode_identify_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ingredient_scanner_screen.dart';

// --- Định nghĩa màu sắc (trích xuất từ FlutterFlow) ---
const Color kColorOverlay = Color(0xCC000000); // Đen mờ 80%
const Color kColorWhite = Colors.white;
const Color kColorTextSecondary = Color(0xFFCCCCCC);
const Color kColorGreenCorner = Color(0xFF00FF00); // Xanh lá sáng
const Color kColorButtonTransparent = Color(0x33FFFFFF); // Trắng mờ 20%
const Color kColorTextSubtitle = Color(0xFFAAAAAA);

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // GestureDetector để unfocus (dù trang này không có textfield)
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        // Stack là layout chính
        body: Stack(
          children: [
            // LỚP 1: NỀN CAMERA (Đen tuyền, vì code gốc không có camera)
            // TODO: Thay thế Container này bằng widget CameraPreview
            Container(color: Colors.black),

            // LỚP 2: GIAO DIỆN QUÉT (Khung, chữ)
            _buildScannerView(context),

            // LỚP 3: THANH ĐIỀU HƯỚNG TRÊN
            _buildTopBar(context),

            // LỚP 4: THANH ĐIỀU HƯỚNG DƯỚI
            _buildBottomBar(context),
          ],
        ),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  // Lớp 2: Giao diện Quét (Khung và Chữ)
  Widget _buildScannerView(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Khung ngắm 280x280
            _buildScannerViewport(),
            const SizedBox(height: 40.0),
            // Hướng dẫn
            Text(
              'Scan Food Barcode',
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                color: kColorWhite,
                fontWeight: FontWeight.w600,
                fontSize: 22.0, // titleLarge
              ),
            ),
            const SizedBox(height: 12.0),
            Text(
              'Position the barcode within the frame',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: kColorTextSecondary,
                fontSize: 14.0, // bodyMedium
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khung ngắm 280x280 (Container trắng với 4 góc xanh lá)
  Widget _buildScannerViewport() {
    return Container(
      width: 280.0,
      height: 280.0,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: kColorWhite,
          width: 3.0,
        ),
      ),
      // Stack chứa 4 góc
      child: Stack(
        children: [
          _buildCorner(Alignment.topLeft),
          _buildCorner(Alignment.topRight),
          _buildCorner(Alignment.bottomLeft),
          _buildCorner(Alignment.bottomRight),
        ],
      ),
    );
  }

  // Hàm trợ giúp vẽ 1 GÓC (dùng Border)
  Widget _buildCorner(Alignment alignment) {
    const double cornerSize = 50.0;
    const double cornerWidth = 4.0;
    const BorderSide cornerSide =
        BorderSide(color: kColorGreenCorner, width: cornerWidth);

    return Align(
      alignment: alignment,
      child: Container(
        width: cornerSize,
        height: cornerSize,
        decoration: BoxDecoration(
          border: Border(
            top: (alignment == Alignment.topLeft ||
                    alignment == Alignment.topRight)
                ? cornerSide
                : BorderSide.none,
            left: (alignment == Alignment.topLeft ||
                    alignment == Alignment.bottomLeft)
                ? cornerSide
                : BorderSide.none,
            right: (alignment == Alignment.topRight ||
                    alignment == Alignment.bottomRight)
                ? cornerSide
                : BorderSide.none,
            bottom: (alignment == Alignment.bottomLeft ||
                    alignment == Alignment.bottomRight)
                ? cornerSide
                : BorderSide.none,
          ),
        ),
      ),
    );
  }

  // Lớp 3: Thanh AppBar giả
  Widget _buildTopBar(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        height: 120.0, // Đủ cao để che cả status bar
        color: kColorOverlay, // Nền đen mờ
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              24.0, 60.0, 24.0, 0.0), // Padding cho status bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nút Đóng
              _buildCircleIconButton(
                icon: Icons.close_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // Tiêu đề
              Text(
                'Scan Barcode',
                style: GoogleFonts.interTight(
                  color: kColorWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 24.0, // headlineSmall
                ),
              ),
              // Nút Đèn flash
              _buildCircleIconButton(
                icon: Icons.flash_on_rounded,
                onPressed: () {
                  print('Flash button pressed...');
                  // TODO: Thêm logic bật/tắt đèn flash
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Lớp 4: Thanh Bottom Bar giả
  Widget _buildBottomBar(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 200.0,
        color: kColorOverlay, // Nền đen mờ
        child: Padding(
          padding:
              const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 40.0), // Padding cho safe area
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                // Hàng 3 nút: Gallery, Scan, Manual
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBottomActionButton(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onPressed: () {
                      print('Gallery pressed...');
                      // TODO: Thêm logic mở thư viện
                    },
                  ),
                  _buildBottomActionButton(
                    icon: Icons.qr_code_scanner_rounded,
                    label: 'Scan',
                    isMain: true, // Nút chính to hơn
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BarcodeResultScreen()));
                    },
                  ),
                  // SỬA ĐỔI: Thay thế nút "Manual" bằng "Scan Ingredient" (dùng Asset)
                  _buildBottomAssetActionButton(
                    assetPath: 'assets/icon/qr.png', // Dùng ảnh asset
                    label: 'Ingredient', // Đổi tên (hoặc 'Scan Ingredient')
                    onPressed: () {
                      // FLOW MỚI: Đi đến trang Scan Ingredient
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IngredientScannerScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              Text(
                'Tap to scan or choose from gallery',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: kColorTextSubtitle,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm trợ giúp cho nút tròn mờ (Đóng, Flash)
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 50.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: kColorButtonTransparent, // Trắng mờ
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: kColorWhite, size: 24.0),
        onPressed: onPressed,
      ),
    );
  }

  // Hàm trợ giúp cho các nút ở Bottom Bar
  Widget _buildBottomActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    bool isMain = false, // Nút 'Scan' sẽ to hơn
  }) {
    final double size = isMain ? 80.0 : 60.0;
    final Color bgColor = isMain ? kColorWhite : kColorButtonTransparent;
    final Color iconColor = isMain ? Colors.black : kColorWhite;
    final double iconSize = isMain ? 40.0 : 30.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Nút tròn
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon, color: iconColor, size: iconSize),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            splashRadius: size / 2,
          ),
        ),
        const SizedBox(height: 8.0),
        // Chữ
        Text(
          label,
          style: GoogleFonts.inter(
            color: kColorWhite,
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
  Widget _buildBottomAssetActionButton({
    required String assetPath,
    required String label,
    required VoidCallback onPressed,
    bool isMain = false,
  }) {
    final double size = isMain ? 80.0 : 60.0;
    final Color bgColor = isMain ? kColorWhite : kColorButtonTransparent;
    final Color iconColor = isMain ? Colors.black : kColorWhite;
    final double iconSize = isMain ? 40.0 : 30.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Nút tròn
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            // SỬA ĐỔI: Dùng Image.asset
            icon: Image.asset(
              assetPath,
              // 'color' chỉ hoạt động nếu ảnh asset của bạn là icon đơn sắc
              color: iconColor, 
              width: iconSize,
              height: iconSize,
            ),
            onPressed: onPressed,
            padding: EdgeInsets.zero,
            splashRadius: size / 2,
          ),
        ),
        const SizedBox(height: 8.0),
        // Chữ
        Text(
          label,
          style: GoogleFonts.inter(
            color: kColorWhite,
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }
}