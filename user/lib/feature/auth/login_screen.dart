import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../survey/collect_information_screen.dart'; 
// import 'onboarding_flow_screen.dart'; // Import trang đích sau khi login
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color primaryColor = const Color(0xFF568C4C);
  final Color primaryBackgroundColor = const Color(0xFFF1F4F8);
  final Color secondaryTextColor = const Color(0xFF57636C);
  final Color textFieldBorderColor = const Color(0xFFE0E3E7);
  final Color whiteColor = const Color(0xFFFFFFFF);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  
  // Thêm biến loading để xoay vòng tròn khi đang đăng nhập
  bool _isLoading = false; 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm hiển thị lỗi
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      // Hiển thị vòng tròn loading nếu đang xử lý
      body: _isLoading 
        ? Center(child: CircularProgressIndicator(color: primaryColor))
        : SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
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
  
                  // Email Field
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
                      prefixIcon: Icon(Icons.email_outlined, color: secondaryTextColor),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: GoogleFonts.inter(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password...',
                      labelStyle: GoogleFonts.inter(color: secondaryTextColor),
                      hintStyle: GoogleFonts.inter(color: secondaryTextColor),
                      filled: true,
                      fillColor: whiteColor,
                      prefixIcon: Icon(Icons.lock_outline, color: secondaryTextColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: secondaryTextColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: textFieldBorderColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: primaryColor, width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: GoogleFonts.inter(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
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
                  const SizedBox(height: 24),
  
                  // Nút Login (Email/Pass)
                  ElevatedButton(
                    onPressed: () {
                      // Logic đăng nhập Email/Pass (Giữ nguyên hoặc update sau)
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()), // Ví dụ chuyển trang
                        (route) => false, 
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                      elevation: 3.0,
                    ),
                    child: Text(
                      'Login',
                      style: GoogleFonts.inter(fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ),
  
                  const SizedBox(height: 30),
  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(child: Divider(color: secondaryTextColor.withOpacity(0.5), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Or continue with', style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 14.0)),
                      ),
                      Expanded(child: Divider(color: secondaryTextColor.withOpacity(0.5), thickness: 1)),
                    ],
                  ),
  
                  const SizedBox(height: 30),
  
                  // --- CODE ĐÃ SỬA Ở ĐÂY: Nút Google ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: textFieldBorderColor, width: 2.0),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2))],
                        ),
                        child: IconButton(
                          onPressed: () async {
                            // 1. Bật loading
                            setState(() => _isLoading = true);
                            
                            // 2. Gọi Service đăng nhập
                            final AuthService authService = AuthService();
                            final userCredential = await authService.signInWithGoogle();

                            // 3. Tắt loading
                            setState(() => _isLoading = false);

                            // 4. Kiểm tra kết quả
                            if (userCredential != null) {
                              // Đăng nhập thành công -> Chuyển trang
                              print("Đăng nhập Google thành công: ${userCredential.user?.email}");
                              
                              if (!mounted) return;
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  // Chuyển đến trang Khảo sát (nếu user mới) hoặc Trang chủ
                                  builder: (context) => const OnboardingFlowScreen(),
                                ),
                                (route) => false,
                              );
                            } else {
                              // Đăng nhập thất bại hoặc hủy
                               _showError("Đăng nhập Google thất bại");
                            }
                          },
                          icon: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg',
                            height: 24.0,
                            width: 24.0,
                            errorBuilder: (context, error, stackTrace) => 
                              const Icon(Icons.g_mobiledata, color: Colors.red),
                          ),
                          iconSize: 30,
                          padding: const EdgeInsets.all(16.0),
                        ),
                      ),
                      // Nếu có nút Facebook thì để ở đây
                    ],
                  ),
                  // -------------------------------------

                  const SizedBox(height: 30), // Khoảng cách cuối
                  
                   // Link Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?  ', style: GoogleFonts.inter(color: secondaryTextColor)),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                        },
                        child: Text('Sign Up', style: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w600)),
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