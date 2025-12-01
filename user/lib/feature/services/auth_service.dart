import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart';

class AuthService {
  // --- CẤU HÌNH ---
  final String baseUrl = "https://kellie-unsarcastic-hoa.ngrok-free.dev/api/auth"; 

  // ==========================================================
  // CẤU HÌNH GOOGLE SIGN IN
  // ==========================================================
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId: '579746797348-l9tht58g9c99bu4r05mu8jj47ued03os.apps.googleusercontent.com', 
    scopes: ['email', 'profile'],
  );

  // ==========================================================
  // 1. ĐĂNG NHẬP GOOGLE
  // ==========================================================
  Future<bool> loginWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Đăng xuất trước để chọn lại tài khoản
      
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return false; 

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      String? idToken = googleAuth.idToken; 

      if (idToken == null) {
        print("Lỗi: Không lấy được ID Token từ Google");
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/google-login'), 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({ "idToken": idToken }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Đăng nhập Google thành công! Token: ${data['token']}");
        // TODO: Lưu token vào SharedPreferences
        return true;
      } else {
        print("Lỗi Server: ${response.body}");
        return false;
      }
    } catch (error) {
      print("Lỗi Google Sign In: $error");
      return false;
    }
  }

  // ==========================================================
  // 2. ĐĂNG NHẬP EMAIL/PASSWORD
  // ==========================================================
  Future<Map<String, dynamic>> signInWithEmail(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({ 'email': email, 'password': password }),
      );
      
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return { 'success': true, 'token': data['token'] };
      } else {
        return { 'success': false, 'message': data['message'] ?? "Đăng nhập thất bại" };
      }
    } catch (e) {
      print("Lỗi Login: $e");
      return { 'success': false, 'message': "Lỗi kết nối Server." };
    }
  }

  // ==========================================================
  // 3. GỬI OTP (DÙNG CHUNG CHO ĐĂNG KÝ & QUÊN MK)
  // ==========================================================
  // 🔥 Thêm tham số 'type' để phân biệt
  Future<bool> sendOtp({String? email, String? phone, String type = 'register'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/send-otp'),
        headers: {
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({
          'email': email, // Có thể null
          'phone': phone, // Có thể null
          'type': type
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        final data = jsonDecode(response.body);
        print("Gửi OTP thất bại: ${data['message']}");  
        return false;
      }
    } catch (e) {
      print("Lỗi kết nối API Send OTP: $e");
      return false;
    }
  }

  // ==========================================================
  // 4. XÁC THỰC VÀ ĐĂNG KÝ (BƯỚC 2 CỦA SIGN UP)
  // ==========================================================
  Future<bool> verifyAndRegister(String email, String password, String fullName, String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'), 
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone,
          'otp': otp
        }),
      );

      if (response.statusCode == 200) return true;
      else {
        print("Đăng ký thất bại: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Lỗi kết nối API Register: $e");
      return false;
    }
  }

  // ==========================================================
  // 5. QUÊN MẬT KHẨU (GỬI OTP)
  // ==========================================================
  Future<bool> forgotPassword({String? email, String? phone}) async {
    // Gọi hàm sendOtp với type='forgot'
    return await sendOtp(email: email, phone: phone, type: 'forgot');
  }

  // ==========================================================
  // 6. ĐẶT LẠI MẬT KHẨU MỚI (SAU KHI CÓ OTP)
  // ==========================================================
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
  // 7. LẤY PROFILE
  // ==========================================================
  Future<Map<String, dynamic>?> getUserProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'), // Lưu ý route /auth/
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
  // ==========================================================
  // 🔥 8. LẤY DANH SÁCH TÙY CHỌN KHẢO SÁT (MỚI THÊM)
  // ==========================================================
  Future<Map<String, List<String>>> getSurveyOptions() async {
    try {
      // Gọi API lấy danh sách tags (lưu ý đường dẫn /options/survey-options)
      final response = await http.get(
        Uri.parse('$baseUrl/options/survey-options'), 
        headers: {
          'Content-Type': 'application/json',
          "ngrok-skip-browser-warning": "true",
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final data = jsonResponse['data'];

        // Trả về Map chứa các list tags
        return {
          'health_conditions': List<String>.from(data['health_conditions'] ?? []),
          'habits': List<String>.from(data['habits'] ?? []),
          'goals': List<String>.from(data['goals'] ?? []),
          'diets': List<String>.from(data['diets'] ?? []),
        };
      } else {
        print("Lỗi lấy options: ${response.body}");
        return {};
      }
    } catch (e) {
      print("Lỗi kết nối API Options: $e");
      // Trả về data giả (Fallback) nếu mất mạng để app không bị trắng trơn
      return {
        'health_conditions': ['Tiểu đường', 'Cao huyết áp', 'Không có'],
        'habits': ['Ăn khuya', 'Bỏ bữa sáng', 'Ăn nhanh'],
        'goals': ['Giảm cân', 'Tăng cân', 'Giữ dáng'],
        'diets': ['Mặn', 'Chay'],
      };
    }
  }

  // ==========================================================
  // 9. GỬI KHẢO SÁT & NHẬN PHÂN TÍCH AI (SUBMIT SURVEY)
  // ==========================================================
  Future<Map<String, dynamic>?> submitSurvey(String email, Map<String, dynamic> formData)  async {
    try{
      final response = await http.post(
        Uri.parse('$baseUrl/submit-survey'),
        headers: {
          "Content-type": "application/json",
          "ngrok-skip-browser-warning": "true",
        },
        body: jsonEncode({
          'email': email,
          'formData': formData
        }),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'];
      } else {
        print("Lỗi Server: ${response.body}");
        return null;
      }
    } catch(e){
      print("Lỗi kết nối");
      return null;
    }
  }
}
