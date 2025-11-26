import 'dart:async'; // 1. Import thư viện Timer
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  final String password;
  final String fullName;

  const OtpScreen({
    super.key,
    required this.email,
    required this.password,
    required this.fullName,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  
  // --- KHAI BÁO BIẾN CHO TIMER ---
  Timer? _timer;
  int _start = 60; // Thời gian đếm ngược (giây)
  bool _canResend = false; // Trạng thái nút gửi lại

  @override
  void initState() {
    super.initState();
    startTimer(); // Bắt đầu đếm ngược ngay khi vào màn hình
  }

  @override
  void dispose() {
    _timer?.cancel(); // Hủy timer khi thoát màn hình để tránh rò rỉ bộ nhớ
    _otpController.dispose();
    super.dispose();
  }

  // --- HÀM ĐẾM NGƯỢC ---
  void startTimer() {
    setState(() {
      _start = 60;
      _canResend = false;
    });
    
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _canResend = true; // Cho phép bấm nút
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  // --- HÀM GỬI LẠI MÃ ---
  Future<void> _handleResendOtp() async {
    // Hiện loading nhẹ hoặc thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đang gửi lại mã...")),
    );

    final authService = AuthService();
    // Gọi lại API gửi OTP (Chỉ cần email)
    bool isSent = await authService.sendOtp(widget.email);

    if (isSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã gửi lại mã mới! Vui lòng kiểm tra mail."),
          backgroundColor: Colors.green,
        ),
      );
      // Reset lại đồng hồ đếm ngược
      startTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Gửi lại thất bại. Vui lòng thử lại sau."),
          backgroundColor: Colors.red.shade400,
        ),
      );
    }
  }

  // --- HÀM XÁC THỰC (GIỮ NGUYÊN) ---
  void _handleVerify() async {
    if (_otpController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ 6 số OTP")),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await AuthService().verifyAndRegister(
      widget.email,
      widget.password,
      widget.fullName,
      _otpController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công! Vui lòng đăng nhập.")),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Mã OTP không đúng hoặc lỗi Server!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF568C4C);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Xác thực OTP"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Text(
                "Mã xác thực đã gửi đến:",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
              ),
              const SizedBox(height: 30),
  
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 8, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  hintText: "------",
                  counterText: "",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: primaryColor, width: 2),
                  ),
                ),
              ),
  
              const SizedBox(height: 30),
  
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _handleVerify,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Xác nhận",
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
              
              const SizedBox(height: 24),
  
              // --- PHẦN GỬI LẠI MÃ ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Bạn không nhận được mã? ",
                    style: GoogleFonts.inter(color: Colors.grey[600]),
                  ),
                  _canResend
                      ? InkWell(
                          onTap: _handleResendOtp,
                          child: Text(
                            "Gửi lại",
                            style: GoogleFonts.inter(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        )
                      : Text(
                          "Gửi lại sau ${_start}s",
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}