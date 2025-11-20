import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// Import trang Home của bạn (hoặc trang Khảo sát)
import '../survey/collect_information_screen.dart';
class OtpScreen extends StatefulWidget {
  // Nhận dữ liệu từ trang SignUp
  final String fullName;
  final String email;
  final String password;

  const OtpScreen({
    super.key, 
    required this.fullName, 
    required this.email, 
    required this.password
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _otpFocusNode = FocusNode();
  bool _isLoading = false;

  // Màu sắc (Lấy từ file SignUp của bạn)
  final Color primaryColor = const Color(0xFF568C4C);
  final Color secondaryTextColor = const Color(0xFF57636C);

  // --- Hàm xử lý Mock (Giả lập) ---
  Future<void> _handleVerifyOtp() async {
    if (_otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ 6 số"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Giả vờ gọi API trong 1.5 giây
    await Future.delayed(const Duration(milliseconds: 1500));

    // Nếu widget đã bị hủy trước khi hoàn thành, dừng lại
    if (!mounted) return;

    // Hiển thị thông báo thành công (trước khi điều hướng)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đăng ký thành công! Chào mừng bạn."), backgroundColor: Colors.green),
    );

    // Chuyển đến trang Onboarding/Home và xóa lịch sử điều hướng cũ
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Simple 6-digit input (fallback when `pinput` package isn't available)

    return Scaffold(
      backgroundColor: const Color(0xFFF1F4F8), // Nền giống SignUp
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Xác thực OTP", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Text(
                "Nhập mã 6 số",
                style: GoogleFonts.interTight(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.inter(fontSize: 16, color: secondaryTextColor),
                  children: [
                    const TextSpan(text: "Chúng tôi đã gửi mã xác thực đến\n"),
                    TextSpan(
                      text: widget.email, // Hiển thị email đã nhập
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Fallback input: single TextFormField that accepts 6 digits
              TextFormField(
                controller: _otpController,
                focusNode: _otpFocusNode,
                autofocus: true,
                keyboardType: TextInputType.number,
                maxLength: 6,
                style: GoogleFonts.inter(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w600),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '______',
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E3E7))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE0E3E7))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryColor, width: 2)),
                ),
                onChanged: (val) {
                  if (val.length == 6) _handleVerifyOtp();
                },
              ),

              const SizedBox(height: 40),
              
              // Nút xác nhận
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleVerifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Xác nhận",
                          style: GoogleFonts.interTight(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Nút Gửi lại
              TextButton(
                onPressed: () {
                  // Logic giả lập gửi lại
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Đã gửi lại mã!")),
                  );
                },
                child: Text(
                  "Gửi lại mã",
                  style: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}