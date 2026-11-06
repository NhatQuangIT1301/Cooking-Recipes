import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Định nghĩa màu sắc (trích xuất từ theme) ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorInfo = Colors.white; // Màu chữ trắng
const Color kColorOverlay = Color(0x4D000000); // Lớp phủ đen 30%

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kColorBackground,
        appBar: _buildAppBar(context),
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24.0),
                _buildHeaderImage(),
                const SizedBox(height: 32.0),
                _buildOurStorySection(),
                const SizedBox(height: 32.0),
                _buildOurValuesSection(),
                const SizedBox(height: 32.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- CÁC HÀM XÂY DỰNG UI ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: kColorBackground,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded, color: kColorPrimaryText),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Text(
        'Về Chúng Tôi',
        style: GoogleFonts.interTight(
          color: kColorPrimaryText,
          fontWeight: FontWeight.w600,
          fontSize: 24.0, // Đã giảm size một chút cho chữ tiếng Việt
        ),
      ),
    );
  }

  // Header Image
  Widget _buildHeaderImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: kColorSecondaryText, // Màu nền lót
          image: const DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/logo.png'),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: kColorOverlay, // Lớp phủ đen 30%
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cooking Recipes',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.interTight(
                    color: kColorInfo,
                    fontSize: 36.0, 
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Trợ lý ẩm thực thông minh của bạn',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: kColorInfo,
                      fontSize: 16.0, 
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Phần "Câu chuyện của chúng tôi"
  Widget _buildOurStorySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Câu chuyện của chúng tôi',
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontSize: 24.0, 
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Được khởi xướng vào năm 2025 dưới dạng một đồ án tốt nghiệp tại Trường Đại học Văn Lang bởi Nguyễn Trung Kiên và Lương Nhật Quang. Chúng tôi bắt đầu với một mục tiêu thiết thực: giải quyết bài toán "hôm nay ăn gì" và giảm thiểu tình trạng lãng phí thực phẩm trong hộ gia đình.',
            style: GoogleFonts.inter(
              color: kColorPrimaryText,
              fontSize: 16.0, 
              height: 1.5, 
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            'Ngày nay, thông qua việc tích hợp Trí tuệ nhân tạo (Google Gemini), Cooking Recipes không chỉ là một ứng dụng tra cứu công thức, mà còn là người trợ lý đắc lực giúp bạn tận dụng tối đa nguyên liệu sẵn có, mang đến những bữa ăn ngon miệng và khoa học hơn.',
            style: GoogleFonts.inter(
              color: kColorPrimaryText,
              fontSize: 16.0,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Phần "Giá trị cốt lõi"
  Widget _buildOurValuesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Giá trị cốt lõi',
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontSize: 24.0, 
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24.0),
          _buildValueItem(
            icon: Icons.auto_awesome_outlined, // Đổi icon cho hợp với AI
            title: 'Đổi mới công nghệ',
            subtitle:
                'Ứng dụng Trí tuệ nhân tạo (AI) để mang lại trải nghiệm gợi ý thực đơn thông minh và cá nhân hóa.',
          ),
          const SizedBox(height: 16.0),
          _buildValueItem(
            icon: Icons.restaurant_menu_outlined, // Đổi icon
            title: 'Tiện ích người dùng',
            subtitle:
                'Tiết kiệm thời gian suy nghĩ, tối ưu chi phí và cải thiện chất lượng bữa ăn hằng ngày của bạn.',
          ),
          const SizedBox(height: 16.0),
          _buildValueItem(
            icon: Icons.eco_outlined, // Đổi icon hướng tới môi trường
            title: 'Phát triển bền vững',
            subtitle:
                'Góp phần giảm thiểu rác thải thực phẩm, hướng tới một lối sống xanh và hiệu quả hơn.',
          ),
        ],
      ),
    );
  }

  // Hàm trợ giúp cho một mục "Value"
  Widget _buildValueItem(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: kColorPrimary,
            shape: BoxShape.circle,
          ),
          child: Align(
            alignment: Alignment.center,
            child: Icon(icon, color: kColorInfo, size: 24),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.interTight(
                  color: kColorPrimaryText,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0, 
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  color: kColorSecondaryText,
                  fontSize: 14.0, 
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}