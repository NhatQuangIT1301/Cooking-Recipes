import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Định nghĩa màu sắc (trích xuất từ theme) ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorBorder = Color(0xFFE0E3E7);
const Color kColorInfo = Colors.white;

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(
                      'Chính sách & Điều khoản',
                      style: GoogleFonts.interTight(
                        color: kColorPrimaryText,
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Text(
                      'Cập nhật lần cuối: 15 Tháng 12, 2025',
                      style: GoogleFonts.inter(
                        color: kColorSecondaryText,
                        fontSize: 14.0,
                      ),
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: kColorCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            title: '1. Thông tin chúng tôi thu thập',
                            body:
                                'Chúng tôi thu thập thông tin tài khoản, chỉ số cá nhân (độ tuổi, giới tính, chiều cao, cân nặng, tình trạng sức khỏe, dị ứng, chế độ ăn) và dữ liệu nguyên liệu thông qua hình ảnh hoặc quét mã vạch.',
                          ),
                          _buildSection(
                            title: '2. Mục đích sử dụng dữ liệu',
                            body:
                                'Dữ liệu của bạn được phân tích bởi hệ thống Trí tuệ nhân tạo (Google Gemini) để cung cấp các gợi ý thực đơn và công thức nấu ăn thông minh phù hợp với khẩu vị và nguyên liệu sẵn có trong tủ lạnh của bạn.',
                          ),
                          _buildSection(
                            title: '3. Chia sẻ nội dung (Điều khoản)',
                            body:
                                'Người dùng có quyền tạo và chia sẻ công thức nấu ăn lên cộng đồng. Ban quản trị và Người kiểm duyệt của Cooking Recipes có toàn quyền kiểm tra, từ chối hoặc xóa các công thức vi phạm quy chuẩn chung của ứng dụng.',
                          ),
                          _buildSection(
                            title: '4. Quyền kiểm soát dữ liệu',
                            body:
                                'Bạn có toàn quyền truy cập, chỉnh sửa hoặc xóa hồ sơ cá nhân, nguyên liệu trong tủ lạnh ảo, lịch sử gợi ý và các công thức do chính bạn tạo ra.',
                          ),
                          _buildSection(
                            title: '5. Bảo mật thông tin',
                            body:
                                'Chúng tôi áp dụng các biện pháp kỹ thuật và tổ chức phù hợp để bảo vệ thông tin cá nhân và dữ liệu sức khỏe của bạn khỏi việc truy cập, sửa đổi hoặc phá hủy trái phép.',
                          ),
                          _buildContactSection(context),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

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
    );
  }

  Widget _buildSection({
    required String title,
    required String body,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.interTight(
              color: kColorPrimaryText,
              fontWeight: FontWeight.w600,
              fontSize: 18.0, // Đã tinh chỉnh size cho phù hợp với tiếng Việt
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            body,
            style: GoogleFonts.inter(
              color: kColorSecondaryText,
              fontSize: 14.0,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(color: kColorBorder, height: 1.0, thickness: 1.0),
        const SizedBox(height: 24.0),
        Text(
          'Liên hệ với chúng tôi',
          style: GoogleFonts.interTight(
            color: kColorPrimaryText,
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 12.0),
        Text(
          'Nếu bạn có bất kỳ câu hỏi nào về Chính sách & Điều khoản này, vui lòng liên hệ:',
          style: GoogleFonts.inter(
            color: kColorSecondaryText,
            fontSize: 14.0,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16.0),
        _buildContactRow(
            icon: Icons.email_outlined, text: 'support@cookingrecipes.vn'),
        const SizedBox(height: 8.0),
        _buildContactRow(
            icon: Icons.phone_outlined, text: '+84 (0) 123 456 789'),
        const SizedBox(height: 8.0),
        _buildContactRow(
            icon: Icons.location_on_outlined,
            text: 'Khoa CNTT, Đại học Văn Lang, TP.HCM'), // Địa chỉ giả định theo đồ án
      ],
    );
  }

  Widget _buildContactRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: kColorPrimary, size: 20),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              color: kColorPrimary,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}