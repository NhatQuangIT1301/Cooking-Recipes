import 'dart:convert';
// import 'package:firebase_auth/firebase_auth.dart'; 
// import 'package:google_sign_in/google_sign_in.dart'; 
import 'package:http/http.dart' as http;

class AuthService {
  // --- CẤU HÌNH CỦA CLASS (BIẾN baseUrl NẰM Ở ĐÂY) ---
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final GoogleSignIn _googleSignIn = GoogleSignIn();
  
  // Biến này có thể được truy cập bởi mọi hàm trong class
  final String baseUrl = "https://jade-tangential-ralph.ngrok-free.dev/api/auth"; 

  // ==========================================================
  // PHẦN 1: ĐĂNG NHẬP GOOGLE 
  // (Giữ lại logic này để đảm bảo nút Google Login không bị lỗi)
  // ==========================================================
  
  // Future<String?> signInWithGoogle() async { 
  //   try {
  //     final googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) return "Lỗi: Người dùng hủy đăng nhập.";

  //     final googleAuth = await googleUser.authentication;
  //     final String? idToken = googleAuth.idToken;

  //     if (idToken == null) return "Lỗi: Không lấy được ID Token.";
      
  //     final response = await http.post(
  //       Uri.parse('$baseUrl/google-login'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'idToken': idToken,
  //         'email': googleUser.email,
  //         'name': googleUser.displayName,
  //       }),
  //     );

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       return data['token']; 
  //     } else {
  //       return data['message'] ?? "Lỗi đăng nhập từ Server.";
  //     }
  //   } catch (e) {
  //     print("❌ Lỗi đăng nhập Google: $e");
  //     return "Lỗi kết nối hoặc cấu hình Firebase.";
  //   }
  // }

  // Future<void> signOut() async {
  //   await _googleSignIn.signOut();
  //   await _auth.signOut();
  // }

  // ==========================================================
  // PHẦN 2: ĐĂNG NHẬP EMAIL/PASS (HÀM CẦN BỔ SUNG)
  // ==========================================================
  
// Hàm này trả về JWT Token (String) nếu thành công hoặc String lỗi.
//   Future<String?> signInWithEmail(String email, String password) async {
//     try {
//       final response = await http.post(
//         // ✅ TRUY CẬP ĐÚNG baseUrl
//         Uri.parse('$baseUrl/login'), 
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200) {
//         return data['token']; // Đăng nhập thành công, trả về Token
//       } else {
//         // Trả về thông báo lỗi cụ thể từ Server 
//         return data['message'] ?? "Lỗi đăng nhập không xác định."; 
//       }
//     } catch (e) {
//       print("❌ Lỗi kết nối API Login: $e");
//       return "Lỗi kết nối Server.";
//     }
//   }
  // ==========================================================
  // PHẦN 3: ĐĂNG KÝ OTP (GIỮ NGUYÊN)
  // ==========================================================

  Future<bool> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
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
}