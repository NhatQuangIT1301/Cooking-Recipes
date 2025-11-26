import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // --- CẤU HÌNH CỦA CLASS ---
  // Biến này có thể được truy cập bởi mọi hàm trong class
  final String baseUrl = "https://jade-tangential-ralph.ngrok-free.dev/api/auth"; 

  // ==========================================================
  // CẤU HÌNH GOOGLE SIGN IN
  // ==========================================================
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // Thay YOUR_WEB_CLIENT_ID_FROM_GCP_CONSOLE bằng Client ID thực tế của bạn
    serverClientId: '579746797348-l9tht58g9c99bu4r05mu8jj47ued03os.apps.googleusercontent.com', 
    scopes: ['email', 'profile'],
  );
  // ==========================================================
  // CHỨC NĂNG 1: ĐĂNG NHẬP BẰNG GOOGLE (Đã thêm vào)
  // ==========================================================
  Future<bool> loginWithGoogle() async {
    try {
      // 1. Mở cửa sổ đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return false; // Người dùng hủy đăng nhập
      }

      // 2. Lấy Authentication (chứa idToken)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      String? idToken = googleAuth.idToken; 

      if (idToken == null) {
        print("❌ Không lấy được ID Token từ Google");
        return false;
      }

      // 3. Gửi Token lên Backend Node.js
      final response = await http.post(
        Uri.parse('$baseUrl/google-login'), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "idToken": idToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Google Login thành công: ${data['message']}");
        // Bạn có thể lưu token vào SharedPreferences tại đây nếu cần
        return true;
      } else {
        print("❌ Lỗi Server Google Login: ${response.body}");
        return false;
      }

    } catch (error) {
      print("❌ Lỗi Google Sign In: $error");
      return false;
    }
  }

  // ==========================================================
  // CHỨC NĂNG 2: ĐĂNG NHẬP EMAIL/PASSWORD 
  // ==========================================================
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );
      final data = jsonDecode(response.body);
      print("✨ API Response: $data");
      if (response.statusCode == 200) {
        return data['token']; // Thành công
      } else {
        return data['message'] ?? "Đăng nhập thất bại";
      }
    } catch (e) {
      print("❌ Lỗi Login Email: $e");
      return "Lỗi kết nối Server.";
    }
  }

  // ==========================================================
  // PHẦN 3: ĐĂNG KÝ OTP 
  // ==========================================================

  Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200) return true;
      else return false;
    } catch (e) {
      print("❌ Lỗi kết nối API Send OTP: $e");
      return false;
    }
  }

  Future<bool> verifyAndRegister(String email, String password, String fullName, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'otp': otp
        }),
      );

      if (response.statusCode == 200) return true;
      else return false;
    } catch (e) {
      print("❌ Lỗi kết nối API Register: $e");
      return false;
    }
  }

  // ==========================================================
  // PHẦN 4: QUÊN MẬT KHẨU 
  // ==========================================================
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/forgot-password'), 
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        return true; // Gửi thành công
      } else {
        final data = jsonDecode(response.body);
        print("❌ Lỗi Forgot Password: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi kết nối: $e");
      return false;
    }
  }

  // ==========================================================
  // CHỨC NĂNG 5: ĐẶT LẠI MẬT KHẨU MỚI (Dùng OTP)
  // ==========================================================
  Future<bool> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password'),
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("❌ Lỗi Reset Pass: ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Lỗi kết nối: $e");
      return false;
    }
  }

  // API Đổi mật khẩu mới (Sửa để trả về String thông báo)
  Future<bool> resetPasswordWithOTP(String email, String otp, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/reset-password-otp'), 
        headers: {
           "Content-Type": "application/json",
           "ngrok-skip-browser-warning": "true", 
        },
        body: jsonEncode({
          "email": email,
          "otp": otp,
          "newPassword": newPassword
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Lỗi reset pass: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  // ==========================================================
  // BỔ SUNG: LẤY PROFILE
  // ==========================================================
  // Future<Map<String, dynamic>?> getUserProfile(String token) async {
  //   try {
  //     // Lưu ý: Bạn cần đảm bảo Backend đã có route GET /api/auth/profile
  //     final response = await http.get(
  //       Uri.parse('$baseUrl/profile'), 
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token', // Gửi kèm Token xác thực
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       return jsonDecode(response.body);
  //     } else {
  //       print("Lỗi lấy Profile: ${response.body}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Lỗi kết nối lấy Profile: $e");
  //     return null;
  //   }
  // }
}