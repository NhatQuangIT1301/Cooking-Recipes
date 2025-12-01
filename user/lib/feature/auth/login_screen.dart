import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import '../survey/collect_information_screen.dart'; 
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
  
  // FIX: Thay 'final' bằng 'late' để state loading có thể thay đổi
  late bool _isLoading = false; 
  final _formKey = GlobalKey<FormState>(); // Thêm Form Key

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Hàm hiển thị lỗi
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red.shade400, behavior: SnackBarBehavior.floating),
    );
  }
  // HÀM 1: XỬ LÝ LOGIN GOOGLE
  Future<void> _handleGoogleLogin() async {
    setState(() => _isLoading = true);
    
    final authService = AuthService();
    // Gọi hàm loginWithGoogle trả về bool
    final bool success = await authService.loginWithGoogle();
  
    setState(() => _isLoading = false);

    if (success) {
      if (!mounted) return;
      // Đăng nhập thành công -> Chuyển hướng
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()),
        (route) => false,
      );
    } else {
      _showError("Đăng nhập Google thất bại.");
    }
  }
  // HÀM 2: XỬ LÝ LOGIN EMAIL/PASS 
  Future<void> _handleLogin() async{
    if (_emailController.text.trim().isEmpty || _passwordController.text.isEmpty){
      _showError("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    setState(() => _isLoading = true);
    
    final authService = AuthService();
    
    // Gọi hàm và nhận về Map {success, message/token}
    final result = await authService.signInWithEmail(
      _emailController.text.trim(), 
      _passwordController.text.trim(),
    );
    
    setState(() => _isLoading = false);

    // Kiểm tra kết quả dựa trên biến boolean 'success' -> CHÍNH XÁC 100%
    if (result['success'] == true) {
      // ✅ Thành công
      print("Token nhận được: ${result['token']}");
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()),
        (route) => false,
      );
    } else {
      // ❌ Thất bại -> Hiện đúng thông báo lỗi từ Server (VD: Email hoặc mật khẩu không đúng)
      _showError(result['message']);
    }
  }

  // HÀM PHỤ: Xử lý kết quả chung (đỡ phải viết lặp lại)
  void _processLoginResult(String? result){
    if(result != null && !result.startsWith('Lỗi') && !result.contains('thất bại')) {
      // ✅ Thành công (result là Token)
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const OnboardingFlowScreen()),
        (route) => false,
      );
    } else {
      // ❌ Thất bại (result là thông báo lỗi)
      _showError(result ?? "Đăng nhập thất bại. Vui lòng thử lại.");
    }
  }


  @override
  Widget build(BuildContext context) {
    final bool isProcessing = _isLoading; 

    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: isProcessing 
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
                  // --- HEADER ---
                  Text('Login', style: GoogleFonts.interTight(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 16),
                  Text('Welcome back! Please enter your details.', style: GoogleFonts.inter(fontSize: 16.0, color: secondaryTextColor)),
                  const SizedBox(height: 40),
  
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email', hintText: 'Enter your email...', labelStyle: GoogleFonts.inter(color: secondaryTextColor),
                      filled: true, fillColor: whiteColor, prefixIcon: Icon(Icons.email_outlined, color: secondaryTextColor),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 2.0), borderRadius: BorderRadius.circular(12.0)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2.0), borderRadius: BorderRadius.circular(12.0)),
                    ),
                    style: GoogleFonts.inter(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password', hintText: 'Enter your password...', labelStyle: GoogleFonts.inter(color: secondaryTextColor),
                      filled: true, fillColor: whiteColor, prefixIcon: Icon(Icons.lock_outline, color: secondaryTextColor),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: secondaryTextColor),
                        onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                      ),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: textFieldBorderColor, width: 2.0), borderRadius: BorderRadius.circular(12.0)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor, width: 2.0), borderRadius: BorderRadius.circular(12.0)),
                    ),
                    style: GoogleFonts.inter(color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
  
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen())),
                      child: Text('Forgot Password?', style: GoogleFonts.inter(color: primaryColor, fontWeight: FontWeight.w600, fontSize: 14.0)),
                    ),
                  ),
                  const SizedBox(height: 24),
  
                  // --- NÚT LOGIN CHÍNH ---
                  ElevatedButton(
                    // 
                    // ⚠️ GỌI HÀM XỬ LÝ LOGIN THẬT SỰ
                    onPressed: isProcessing ? null : _handleLogin,
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
  
                  // --- DIVIDER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // FIX OPACITY
                      Expanded(
                        child: Divider(color: secondaryTextColor.withValues(alpha: 0.5), thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Or continue with', style: GoogleFonts.inter(color: secondaryTextColor, fontSize: 14.0)),
                      ),
                      // FIX OPACITY
                      Expanded(child: Divider(color: secondaryTextColor.withValues(alpha: 0.5), thickness: 1)),
                    ],
                  ),
  
                  const SizedBox(height: 30),
                  
                  // --- NÚT GOOGLE ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: whiteColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: textFieldBorderColor, width: 2.0),
                          // FIX OPACITY
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5, offset: const Offset(0, 2))],
                        ),
                        child: IconButton(
                          onPressed: isProcessing ? null : _handleGoogleLogin, // Gọi hàm Google Login
                          icon: const Icon(Icons.g_mobiledata, color: Colors.red, size: 40), // Tạm dùng icon này
                          padding: const EdgeInsets.all(8.0),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30), 
                  
                   // Link Sign Up
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?  ', style: GoogleFonts.inter(color: secondaryTextColor)),
                      InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
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