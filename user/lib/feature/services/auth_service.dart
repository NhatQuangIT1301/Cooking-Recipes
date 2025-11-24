// services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Hàm xử lý đăng nhập Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Kích hoạt luồng đăng nhập Google (mở popup chọn mail)
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // Người dùng hủy đăng nhập
      }

      // 2. Lấy thông tin xác thực (Token) từ request trên
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Tạo credential để gửi cho Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Đăng nhập vào Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // --- LƯU Ý QUAN TRỌNG CHO BACKEND NODE.JS ---
      // Nếu bạn dùng Node.js, bạn cần lấy ID Token này gửi về server:
      // String? idToken = await userCredential.user?.getIdToken();
      // await sendTokenToNodeJsBackend(idToken);
      // ---------------------------------------------

      return userCredential;
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      return null;
    }
  }

  // Hàm đăng xuất
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}