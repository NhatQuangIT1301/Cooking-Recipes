import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Định nghĩa màu sắc (trích xuất từ theme) ---
const Color kColorBackground = Color(0xFFF1F4F8);
const Color kColorCard = Color(0xFFFFFFFF);
const Color kColorPrimary = Color(0xFF568C4C); // Màu xanh lá chính
const Color kColorPrimaryText = Color(0xFF15161E);
const Color kColorSecondaryText = Color(0xFF57636C);
const Color kColorInfo = Colors.white; // Màu chữ trắng
const Color kColorOverlay = Color(0x4D000000); // Lớp phủ đen 30%

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

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
                children: [
                  const SizedBox(height: 16.0),
                  _buildHeaderImage(context),
                  const SizedBox(height: 24.0),
                  _buildTermsContent(context),
                  const SizedBox(height: 32.0),
                ],
              ),
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
        'Terms of Use',
        style: GoogleFonts.interTight(
          color: kColorPrimaryText,
          fontWeight: FontWeight.w600,
          fontSize: 22.0, // headlineMedium
        ),
      ),
    );
  }

  // Header Image (Banner)
  Widget _buildHeaderImage(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: kColorSecondaryText, // Màu nền lót
        image: const DecorationImage(
          fit: BoxFit.cover,
          // Sửa lỗi: Dùng placeholder hợp lệ
          image: NetworkImage(
            'https://placehold.co/800x400/57636C/FFFFFF?text=Terms+of+Use',
          ),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
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
                'Terms of Use',
                textAlign: TextAlign.center,
                style: GoogleFonts.interTight(
                  color: kColorInfo,
                  fontSize: 44.0, // displayMedium
                  fontWeight: FontWeight.w600,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Last updated: November 13, 2025', // Cập nhật ngày
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: kColorInfo,
                    fontSize: 16.0, // bodyLarge
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Thẻ chứa nội dung điều khoản
  Widget _buildTermsContent(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: kColorCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              title: '1. Acceptance of Terms',
              body:
                  'By accessing and using this application, you accept and agree to be bound by the terms and provision of this agreement. If you do not agree to abide by the above, please do not use this service.',
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '2. Use License',
              body:
                  'Permission is granted to temporarily download one copy of the materials on our app for personal, non-commercial transitory viewing only. This is the grant of a license, not a transfer of title, and under this license you may not:',
              bulletPoints: [
                'Modify or copy the materials',
                'Use the materials for commercial purpose',
                'Attempt to reverse engineer any software',
                'Remove any copyright or proprietary notations',
              ],
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '3. Privacy Policy',
              body:
                  'Your privacy is important to us. Our Privacy Policy outlines how we collect, use, and protect your personal information. Please review it to understand our practices.',
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '4. User Accounts',
              body:
                  'When you create an account with us, you must provide us information that is accurate, complete, and current at all times. Failure to do so constitutes a breach of the Terms.',
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '5. Prohibited Uses',
              body: 'You may not use our service:',
              bulletPoints: [
                'For any unlawful purpose or to solicit others.',
                'To violate any international, federal, or state regulations.',
                'To infringe upon or violate our intellectual property rights.',
                'To harass, abuse, insult, harm, defame, or discriminate.',
              ],
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '6. Content',
              body:
                  'Our service allows you to post, link, store, share and otherwise make available certain information. You are responsible for the Content that you post on or through the Service.',
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '7. Termination',
              body:
                  'We may terminate or suspend your account immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.',
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '8. Changes to Terms',
              body:
                  'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide at least 30 days\' notice prior to any new terms taking effect.',
            ),
            const SizedBox(height: 20.0),
            _buildSection(
              title: '9. Contact Information',
              body: 'If you have any questions about these Terms, please contact us:',
              bulletPoints: [
                'Email: legal@ourapp.com',
                'Phone: +1 (555) 123-4567',
                'Address: 123 Legal Street, Suite 100, Lawsville, USA',
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Hàm trợ giúp để tạo một Mục (Section)
  Widget _buildSection({
    required String title,
    required String body,
    List<String>? bulletPoints,
  }) {
    // Style cho tiêu đề (ví dụ: "1. Acceptance of Terms")
    final titleStyle = GoogleFonts.interTight(
      color: kColorPrimaryText,
      fontWeight: FontWeight.w600,
      fontSize: 22.0, // titleLarge
    );

    // Style cho nội dung văn bản (body)
    final bodyStyle = GoogleFonts.inter(
      color: kColorSecondaryText, // Màu xám
      fontSize: 14.0, // bodyMedium
      height: 1.5, // Dãn dòng
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tiêu đề
        Text(title, style: titleStyle),
        const SizedBox(height: 8.0),
        // Nội dung
        Text(body, style: bodyStyle),
        // Danh sách gạch đầu dòng (nếu có)
        if (bulletPoints != null) ...[
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: bulletPoints
                  .map((point) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          '• $point', // Thêm dấu •
                          style: bodyStyle.copyWith(
                            // Mục liên hệ có màu xanh
                            color: title == '9. Contact Information'
                                ? kColorPrimary 
                                : kColorSecondaryText,
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
        ]
      ],
    );
  }
}