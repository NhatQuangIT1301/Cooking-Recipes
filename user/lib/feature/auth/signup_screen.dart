import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // ĐÃ XÓA
import '../auth/login_screen.dart';
// THÊM MỚI: Import trang OTP vừa tạo
import 'otp_screen.dart';
// THÊM MỚI: Import trang Home (để dùng trong OTP Screen)


/// Create a page for sign Up, can sign up by Google or Facebook
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _fullNameController;
  late FocusNode _fullNameFocusNode;

  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;

  late TextEditingController _passwordController;
  late FocusNode _passwordFocusNode;
  bool _passwordVisibility = false;
  
  // SỬA ĐỔI: Loading mặc định là false
  bool _isLoading = false; 

  // Định nghĩa các màu và style
  final Color primaryColor = const Color(0xFF568C4C);
  final Color primaryBackgroundColor = const Color(0xFFF1F4F8); // Giả định
  final Color secondaryBackgroundColor = const Color(0xFFFFFFFF);
  final Color secondaryTextColor = const Color(0xFF57636C);
  final Color alternateColor = const Color(0xFFE0E3E7);
  final Color primaryTextColor = const Color(0xFF14181B);

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _fullNameFocusNode = FocusNode();

    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();

    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
    _passwordVisibility = false; 
    // _isLoading = false; // Đã sửa ở trên
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _fullNameFocusNode.dispose();
    _emailController.dispose();
    _emailFocusNode.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  // --- Các hàm Validators (Giữ nguyên) ---
  String? _nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
  // --- Hết Validators ---

  // --- THÊM MỚI: Hàm xử lý Đăng ký và chuyển sang OTP ---
  Future<void> _handleSignUp() async {
    // 1. Kiểm tra Form hợp lệ
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Bật Loading
    setState(() => _isLoading = true);

    // 3. Giả lập gọi API gửi OTP (1.5 giây)
    await Future.delayed(const Duration(milliseconds: 1500));

    // 4. Tắt Loading
    setState(() => _isLoading = false);

    // 5. Chuyển sang màn hình OTP (mang theo dữ liệu đã nhập)
    if (mounted) { // Kiểm tra xem widget còn tồn tại không
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpScreen(
            fullName: _fullNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          ),
        ),
      );
    }

    /* --- PHẦN CODE BACKEND THẬT SẼ VIẾT SAU ---
    try {
      // 1. Gọi API /api/auth/send-otp
      // ... http.post ...
      
      // 2. Nếu thành công (response.statusCode == 200)
      Navigator.push(context, MaterialPageRoute(...));

      // 3. Nếu thất bại (email trùng, lỗi server...)
      // ScaffoldMessenger.of(context).showSnackBar(...)

    } catch (e) { ... }
    finally {
      setState(() => _isLoading = false);
    }
    */
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: primaryBackgroundColor,
        body: SafeArea(
          top: true,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // --- Phần Header ---
                      Align(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Create Account',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.interTight(
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold,
                                color: primaryTextColor,
                              ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Join us today and get started',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: secondaryTextColor,
                                fontSize: 16, 
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32.0), 

                      // --- Phần Form ---
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Form(
                            key: _formKey,
                            autovalidateMode: AutovalidateMode.disabled,
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                // --- Full Name ---
                                TextFormField(
                                  controller: _fullNameController,
                                  focusNode: _fullNameFocusNode,
                                  autofocus: false,
                                  textCapitalization: TextCapitalization.words,
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Full Name',
                                    hintStyle: GoogleFonts.inter(
                                      color: secondaryTextColor,
                                      letterSpacing: 0.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: alternateColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.error,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.error,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: secondaryBackgroundColor,
                                    contentPadding: const EdgeInsets.all(16.0),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: primaryTextColor,
                                    letterSpacing: 0.0,
                                  ),
                                  keyboardType: TextInputType.name,
                                  cursorColor: primaryColor,
                                  validator: _nameValidator,
                                ),
                                const SizedBox(height: 16.0),
                                // --- Email ---
                                TextFormField(
                                  controller: _emailController,
                                  focusNode: _emailFocusNode,
                                  autofocus: false,
                                  textInputAction: TextInputAction.next,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    hintText: 'Email Address',
                                    hintStyle: GoogleFonts.inter(
                                      color: secondaryTextColor,
                                      letterSpacing: 0.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: alternateColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.error,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.error,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: secondaryBackgroundColor,
                                    contentPadding: const EdgeInsets.all(16.0),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: primaryTextColor,
                                    letterSpacing: 0.0,
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                  cursorColor: primaryColor,
                                  validator: _emailValidator,
                                ),
                                const SizedBox(height: 16.0),
                                // --- Password ---
                                TextFormField(
                                  controller: _passwordController,
                                  focusNode: _passwordFocusNode,
                                  autofocus: false,
                                  textInputAction: TextInputAction.done,
                                  obscureText: !_passwordVisibility,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.inter(
                                      color: secondaryTextColor,
                                      letterSpacing: 0.0,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: alternateColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: primaryColor,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.error,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Theme.of(context).colorScheme.error,
                                        width: 1.0,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(12.0),
                                    ),
                                    filled: true,
                                    fillColor: secondaryBackgroundColor,
                                    contentPadding: const EdgeInsets.all(16.0),
                                    suffixIcon: InkWell(
                                      onTap: () => setState(
                                        () => _passwordVisibility =
                                            !_passwordVisibility,
                                      ),
                                      focusNode:
                                          FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _passwordVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: secondaryTextColor,
                                        size: 20.0,
                                      ),
                                    ),
                                  ),
                                  style: GoogleFonts.inter(
                                    color: primaryTextColor,
                                    letterSpacing: 0.0,
                                  ),
                                  cursorColor: primaryColor,
                                  validator: _passwordValidator,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          // --- Nút Create Account ---
                          ElevatedButton(
                            // SỬA ĐỔI: Thêm logic loading
                            onPressed: _isLoading ? null : _handleSignUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor, 
                              minimumSize: const Size(double.infinity, 50.0),
                              padding: const EdgeInsets.all(8.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 0.0,
                            ),
                            // SỬA ĐỔI: Hiển thị vòng xoay
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
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
                        ],
                      ),
                      const SizedBox(height: 32.0), // Khoảng cách

                      // --- PHẦN SOCIAL ĐÃ BỊ XÓA ---
                      
                      // --- Phần "Sign In" ---
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?  ',
                            style: GoogleFonts.inter(
                              color: secondaryTextColor,
                              letterSpacing: 0.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              } else {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen()));
                              }
                            },
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.inter(
                                color: primaryColor, 
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}