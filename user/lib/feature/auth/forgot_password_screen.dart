import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  // Quản lý state trực tiếp, không cần model
  late TextEditingController _emailController;
  late FocusNode _emailFocusNode;

  // Định nghĩa màu sắc (trích xuất từ theme của FlutterFlow)
  final Color primaryBackgroundColor = const Color(0xFFF1F4F8);
  final Color primaryTextColor = const Color(0xFF15161E);
  final Color secondaryTextColor = const Color(0xFF606A85);
  final Color textFieldBorderColor = const Color(0xFFE5E7EB);
  final Color focusedBorderColor = const Color(0xFF6F61EF);
  final Color errorBorderColor = const Color(0xFFFF5963);
  final Color buttonColor = const Color(0xFF4FB239);
  final Color whiteColor = Colors.white;

  @override
  void initState() {
    super.initState();
    // Khởi tạo controller và focus node
    _emailController = TextEditingController();
    _emailFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Hủy controller và focus node khi widget bị hủy
    _emailController.dispose();
    _emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        automaticallyImplyLeading: false, // Tắt nút back tự động
        elevation: 0.0,
        centerTitle: false,
        // Thay FlutterFlowIconButton bằng IconButton chuẩn
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: primaryTextColor,
            size: 30.0,
          ),
          onPressed: () {
            // Dùng Navigator.pop chuẩn
            Navigator.of(context).pop();
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          // Thay FFLocalizations bằng Text chuẩn
          child: Text(
            'Back',
            // Thay FlutterFlowTheme bằng TextStyle chuẩn
            style: GoogleFonts.outfit(
              color: primaryTextColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Align(
        // Căn giữa và giới hạn chiều rộng
        alignment: Alignment.topCenter,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(
            maxWidth: 570.0,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tiêu đề
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Forgot Password',
                    style: GoogleFonts.outfit(
                      color: primaryTextColor,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Mô tả
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
                  child: Text(
                    'We will send you an email with a link to reset your password.',
                    style: GoogleFonts.plusJakartaSans(
                      color: secondaryTextColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Trường nhập Email
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
                  child: TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    decoration: InputDecoration(
                      labelText: 'Your email address...',
                      labelStyle: GoogleFonts.plusJakartaSans(
                        color: secondaryTextColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      hintText: 'Enter your email...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: secondaryTextColor,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: whiteColor,
                      contentPadding:
                          const EdgeInsets.fromLTRB(24.0, 24.0, 20.0, 24.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: textFieldBorderColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: focusedBorderColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: errorBorderColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: errorBorderColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    style: GoogleFonts.plusJakartaSans(
                      color: primaryTextColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    cursorColor: focusedBorderColor,
                  ),
                ),
                // Nút Gửi Link
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    // Thay FFButtonWidget bằng ElevatedButton chuẩn
                    child: ElevatedButton(
                      onPressed: () {
                        print('Button-Send Link pressed ...');
                        // TODO: Xử lý logic gửi email
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: whiteColor,
                        elevation: 3.0,
                        fixedSize: const Size(270.0, 50.0),
                        shape: RoundedRectangleBorder(
                          // Thêm border radius cho đồng bộ
                          borderRadius: BorderRadius.circular(12.0), 
                        ),
                      ),
                      child: Text(
                        'Send Link',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}