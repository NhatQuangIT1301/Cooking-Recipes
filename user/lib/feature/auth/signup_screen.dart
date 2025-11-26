import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../auth/login_screen.dart';
import 'otp_screen.dart'; // Đảm bảo file này đã tồn tại
import '../services/auth_service.dart'; 

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  
  bool _isLoading = false; 
  bool _passwordVisibility = false;

  final Color primaryColor = const Color(0xFF568C4C);
  final Color primaryBackgroundColor = const Color(0xFFF1F4F8);
  final Color secondaryBackgroundColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFF57636C);
  final Color alternateColor = const Color(0xFFE0E3E7);
  final Color primaryTextColor = const Color(0xFF14181B);

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Validators ---
  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your full name';
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // --- HÀM XỬ LÝ ĐĂNG KÝ CHUẨN ---
  Future<void> _handleSignUp() async {
    // 1. Ẩn bàn phím để giao diện gọn gàng
    FocusScope.of(context).unfocus();

    // 2. Kiểm tra Form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 3. Bật Loading
    setState(() => _isLoading = true);

    // 4. Gọi API Gửi OTP
    // Lưu ý: Trim() để xóa khoảng trắng thừa
    final String email = _emailController.text.trim();
    final String fullName = _fullNameController.text.trim(); // Trim tên luôn
    final String password = _passwordController.text; // Pass giữ nguyên

    final authService = AuthService();
    bool isSent = await authService.sendOtp(email);

    // 5. Tắt Loading
    setState(() => _isLoading = false);

    // 6. Xử lý kết quả
    if (isSent) {
      // Nếu thành công -> Chuyển sang màn hình OTP và mang theo dữ liệu
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OtpScreen(
              fullName: fullName, // Truyền tên đã trim
              email: email,       // Truyền email đã trim
              password: password, // Truyền pass
            ),
          ),
        );
      }
    } else {
      // Nếu thất bại -> Hiện thông báo lỗi
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Gửi OTP thất bại! Email có thể đã được đăng ký."),
            backgroundColor: Colors.red.shade400,
            behavior: SnackBarBehavior.floating, // Hiển thị kiểu nổi đẹp hơn
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: primaryBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center( // Thêm Center để căn giữa màn hình dọc
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // --- Header ---
                    Text(
                      'Create Account',
                      style: GoogleFonts.interTight(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      'Join us today and get started',
                      style: GoogleFonts.inter(
                        color: secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // --- Form ---
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Full Name Input
                          TextFormField(
                            controller: _fullNameController,
                            textCapitalization: TextCapitalization.words,
                            decoration: _buildInputDecoration('Full Name'),
                            style: GoogleFonts.inter(color: primaryTextColor),
                            validator: _nameValidator,
                          ),
                          const SizedBox(height: 16.0),

                          // Email Input
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _buildInputDecoration('Email Address'),
                            style: GoogleFonts.inter(color: primaryTextColor),
                            validator: _emailValidator,
                          ),
                          const SizedBox(height: 16.0),

                          // Password Input
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_passwordVisibility,
                            decoration: _buildInputDecoration('Password').copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: secondaryTextColor,
                                  size: 20,
                                ),
                                onPressed: () => setState(() => _passwordVisibility = !_passwordVisibility),
                              ),
                            ),
                            style: GoogleFonts.inter(color: primaryTextColor),
                            validator: _passwordValidator,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // --- Create Account Button ---
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSignUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 50.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : Text(
                              'Create Account',
                              style: GoogleFonts.interTight(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                    ),

                    const SizedBox(height: 32.0),

                    // --- Sign In Link ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?  ',
                          style: GoogleFonts.inter(color: secondaryTextColor),
                        ),
                        InkWell(
                          onTap: () {
                            // Dùng pushReplacement để không quay lại trang đăng ký được
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Hàm style cho Input (Helper function)
  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: secondaryTextColor),
      filled: true,
      fillColor: secondaryBackgroundColor,
      contentPadding: const EdgeInsets.all(16.0),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: alternateColor, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 1.0),
        borderRadius: BorderRadius.circular(12.0),
      ),
    );
  }
}