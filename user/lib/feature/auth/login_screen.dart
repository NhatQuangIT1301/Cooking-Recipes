import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart'; // Import trang Sign Up
import 'forgot_password_screen.dart';
import '../survey/collect_information_screen.dart';
import '../services/auth_service.dart';
// THÊM MỚI: Import trang Quên mật khẩu

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Định nghĩa màu (giống trang sign up)
  final Color primaryColor = const Color(0xFF568C4C);
  final Color primaryBackgroundColor = const Color(0xFFF1F4F8);
  final Color secondaryTextColor = const Color(0xFF57636C);
  final Color textFieldBorderColor = const Color(0xFFE0E3E7);
  final Color whiteColor = const Color(0xFFFFFFFF);

  // Controllers cho text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  final bool _isLoading= true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView( // Cho phép cuộn nếu màn hình nhỏ
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Tiêu đề trang
                  Text(
                    'Login',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.interTight(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome back! Please enter your details.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16.0,
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),
  
                  // Trường nhập Email
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email...',
                      labelStyle: GoogleFonts.inter(color: secondaryTextColor),
                      hintStyle: GoogleFonts.inter(color: secondaryTextColor),
                      filled: true,
                      fillColor: whiteColor,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: secondaryTextColor,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textFieldBorderColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: GoogleFonts.inter(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  // 3. Trường nhập Mật khẩu
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible, // Dùng biến state
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password...',
                    labelStyle: GoogleFonts.inter(color: secondaryTextColor),
                    hintStyle: GoogleFonts.inter(color: secondaryTextColor),
                    filled: true,
                    fillColor: whiteColor,
                    prefixIcon:
                        Icon(Icons.lock_outline, color: secondaryTextColor),
                    // Icon để ẩn/hiện mật khẩu
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: secondaryTextColor,
                      ),
                      onPressed: () {
                        // Cập nhật state để thay đổi icon và ẩn/hiện text
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: textFieldBorderColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: primaryColor,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  style: GoogleFonts.inter(color: Colors.black87),
                ),
                const SizedBox(height: 16), // Giảm khoảng cách 1 chút

                  // THÊM MỚI: Link Quên mật khẩu
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        // Điều hướng đến ForgotPasswordScreen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Điều chỉnh lại khoảng cách

                  // Nút Login
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Xử lý logic đăng nhập ở đây
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      print('Email: $email, Password: $password');
                      // Ví dụ: Navigator.pushReplacement(...)
                      // Dùng pushAndRemoveUntil để xóa trang Login khỏi stack
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => const OnboardingFlowScreen(),
                          ),
                          (route) => false, 
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      elevation: 3.0,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
  
                  const SizedBox(height: 30), // Điều chỉnh khoảng cách
  
                  // Dải phân cách "Or continue with"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Divider(
                          color: secondaryTextColor.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          'Or continue with',
                          style: GoogleFonts.inter(
                            color: secondaryTextColor,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: secondaryTextColor.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
  
                  const SizedBox(height: 30),
  
                  // Hàng chứa icon Google và Facebook
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Nút Google
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: textFieldBorderColor, width: 2.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            )
                          ]
                        ),
                        child: IconButton(
                          onPressed: () {
                            final AuthService authService = AuthService();
                          },
                          icon: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg', // Logo Google từ mạng
                            height: 24.0,
                            width: 24.0,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.g_mobiledata, color: Color.fromARGB(221, 187, 7, 7)), // Fallback
                          ),
                          iconSize: 30,
                          padding: const EdgeInsets.all(16.0),
                        ),
                      ),
  
                      const SizedBox(width: 24),
                    ],
                  ),
  
  
                  // Link điều hướng qua Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account?  ',
                        style: GoogleFonts.inter(
                          color: secondaryTextColor,
                          letterSpacing: 0.0,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Khi nhấn vào, điều hướng đến SignUpScreen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Sign Up', // Text bạn muốn nhấn vào
                          style: GoogleFonts.inter(
                            color: primaryColor, // Màu chính
                            letterSpacing: 0.0,
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
    );
  }
}