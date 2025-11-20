import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ingredient_indentify_screen.dart';

// SỬA ĐỔI: Thêm import cho trang kết quả

// --- Định nghĩa màu sắc (trích xuất từ FlutterFlow) ---
const Color kColorBackground = Colors.black;
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorWhite = Colors.white;
const Color kColorWhite50 = Color(0x80FFFFFF); // Trắng 50%
const Color kColorWhite80 = Color(0xCCFFFFFF); // Trắng 80%
const Color kColorWhite25 = Color(0x40FFFFFF); // Trắng 25% (nút)
const Color kColorBlack50 = Color(0x80000000); // Đen 50% (overlay)

class IngredientScannerScreen extends StatelessWidget {
  const IngredientScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        body: Stack(
          children: [
            // LỚP 1: NỀN CAMERA
            // TODO: Thay thế Container này bằng widget CameraPreview
            Container(color: Colors.black),

            // LỚP 2: GIAO DIỆN QUÉT (Khung, chữ)
            _buildScannerView(context),

            // LỚP 3: THANH ĐIỀU HƯỚNG TRÊN (Gradient mờ)
            _buildTopBar(context),

            // LỚP 4: THANH ĐIỀU HƯỚNG DƯỚI (Gradient mờ)
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
            // Khung ngắm 300x300
            _buildScannerViewport(),
            const SizedBox(height: 32.0),
            // Hướng dẫn
            Text(
              'Scan Food Ingredients',
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                color: kColorWhite,
                fontWeight: FontWeight.w600,
                fontSize: 22.0, // titleLarge
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Position the QR code within the frame',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: kColorWhite80, // Text mờ hơn
                fontSize: 14.0, // bodyMedium
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Khung ngắm 300x300
  Widget _buildScannerViewport() {
    return Container(
      width: 300.0,
      height: 300.0,
      decoration: BoxDecoration(
        color: kColorWhite50, // Nền trắng mờ 50%
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: kColorPrimary, // Viền xanh lá
          width: 3.0,
        ),
      ),
      // Stack chứa 4 góc và icon
      child: Stack(
        children: [
          // Lớp nền mờ bên trong (theo code FlutterFlow)
          Container(
            decoration: BoxDecoration(
              color: kColorBlack50, // Đen 25%
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          // Bốn góc
          _buildCorner(Alignment.topLeft),
          _buildCorner(Alignment.topRight),
          _buildCorner(Alignment.bottomLeft),
          _buildCorner(Alignment.bottomRight),
          // Icon QR ở giữa
          const Align(
            alignment: Alignment.center,
            child: Icon(
              Icons.qr_code_scanner,
              color: kColorWhite50, // Icon trắng mờ
              size: 80.0,
            ),
          ),
        ],
      ),
    );
  }

  // Hàm trợ giúp vẽ 1 GÓC (Container 50x50 màu)
  Widget _buildCorner(Alignment alignment) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 50.0,
        height: 50.0,
        decoration: const BoxDecoration(
          color: kColorPrimary,
          // borderRadius 0.0 là mặc định (vuông)
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
        height: 100.0,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.transparent],
            stops: [0.8, 1.0], // Mờ dần ở 20% cuối
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              16.0, 44.0, 16.0, 0.0), // Padding cho status bar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Nút Back
              _buildCircleIconButton(
                icon: Icons.arrow_back_rounded,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              // Tiêu đề
              Text(
                'QR Scanner',
                style: GoogleFonts.interTight(
                  color: kColorWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0, // titleMedium
                ),
              ),
              // Nút Đèn flash
              _buildCircleIconButton(
                icon: Icons.flash_on,
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black],
            stops: [0.0, 0.8], // Mờ dần ở 80% dưới
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              24.0, 0.0, 24.0, 32.0), // Padding cho safe area
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildBottomActionButton(
                    icon: Icons.photo_library,
                    onPressed: () {
                      print('Gallery pressed...');
                    },
                  ),
                  _buildBottomActionButton(
                    icon: Icons.qr_code_scanner,
                    isMain: true, // Nút chính to hơn
                    onPressed: () {
                      // SỬA LỖI FLOW: Đổi từ IngredientScannerScreen -> IngredientSuggestionsScreen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IngredientSuggestionsScreen(),
                        ),
                      );
                    },
                  ),
                  _buildBottomActionButton(
                    icon: Icons.flip_camera_ios,
                    onPressed: () {
                      print('Flip camera pressed...');
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(
                'Tap to scan or select from gallery',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: kColorWhite80, // Text mờ
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Hàm trợ giúp cho nút tròn mờ (Back, Flash)
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 44.0,
      height: 44.0,
      decoration: const BoxDecoration(
        color: kColorWhite25, // Trắng mờ 25%
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
    required VoidCallback onPressed,
    bool isMain = false,
  }) {
    final double size = isMain ? 80.0 : 60.0;
    final Color bgColor = isMain ? kColorPrimary : kColorWhite25;
    const Color iconColor = kColorWhite;
    final double iconSize = isMain ? 40.0 : 28.0;
    final Border? border = isMain
        ? Border.all(color: kColorWhite, width: 4.0)
        : null;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
        border: border,
      ),
      child: IconButton(
        icon: Icon(icon, color: iconColor, size: iconSize),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashRadius: size / 2,
      ),
    );
  }
}