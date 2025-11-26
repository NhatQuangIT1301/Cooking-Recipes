import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'reset_password_screen.dart'; // Đừng quên import

class OtpScreen extends StatefulWidget {
  final String email;
  final String? password; 
  final String? fullName;
  final bool isForgotPassword; // 🔥 Đây là tham số bạn đang thiếu

  const OtpScreen({
    super.key,
    required this.email,
    this.password,
    this.fullName,
    this.isForgotPassword = false, // Mặc định là false (Đăng ký)
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isLoading = false;
  
  // --- TIMER VARIABLES ---
  Timer? _timer;
  int _start = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

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
            _canResend = true;
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Đang gửi lại mã...")),
    );

    final authService = AuthService();
    bool isSent;

    // PHÂN LOẠI ĐỂ GỌI ĐÚNG API
    if (widget.isForgotPassword) {
      isSent = await authService.forgotPassword(widget.email);
    } else {
      isSent = await authService.sendOtp(widget.email); 
    }

    if (isSent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đã gửi lại mã mới! Vui lòng kiểm tra mail."),
          backgroundColor: Colors.green,
        ),
      );
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

  // --- HÀM XỬ LÝ XÁC NHẬN ---
  void _handleVerify() async {
    String inputOtp = _otpController.text.trim();

    if (inputOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vui lòng nhập đủ 6 số OTP")),
      );
      return;
    }

    // TRƯỜNG HỢP 1: QUÊN MẬT KHẨU
    if (widget.isForgotPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email,
            otpCode: inputOtp, 
          ),
        ),
      );
      return; 
    }

    // TRƯỜNG HỢP 2: ĐĂNG KÝ
    if (widget.password == null || widget.fullName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lỗi dữ liệu đăng ký!")),
      );
      return;
    }

    setState(() => _isLoading = true);

    bool success = await AuthService().verifyAndRegister(
      widget.email,
      widget.password!,
      widget.fullName!,
      inputOtp,
    );

    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Đăng ký thành công! Vui lòng đăng nhập."),
          backgroundColor: Colors.green,
        ),
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
          title: Text(widget.isForgotPassword ? "Quên Mật Khẩu" : "Đăng Ký"),
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
                      child: Text(
                        widget.isForgotPassword ? "Tiếp tục" : "Xác nhận & Đăng ký",
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
              
              const SizedBox(height: 24),
  
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