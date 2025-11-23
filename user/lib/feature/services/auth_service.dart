import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  // Cấu hình địa chỉ backend
  // Use `10.0.2.2` for Android emulator, or replace with device LAN IP when testing on a real device
  final String _backendUrl = 'http://10.0.2.2:5000/api/user/google-login';

  Future<bool> signInWithGoogle() async {
    try {
      // 1. Mở cửa sổ đăng nhập
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return false;
      }
      print('Đã lấy được Google User: ${googleUser.email}');

      // 2. Gửi thông tin về backend để lưu vào database
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'googleId': googleUser.id,
          'email': googleUser.email,
          'name': googleUser.displayName ?? 'Full Name',
          'avatar': googleUser.photoUrl ?? '',
        }),
      );

      // 3. Kiểm tra phản hồi từ server
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Server trả về: $responseData');

        // TODO: Bạn có thể lưu _id hoặc token vào bộ nhớ máy ở đây (Shared Preferences)
        return true;
      } else {
        print('Lỗi Server: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Lỗi Đăng Nhập: $error');
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}