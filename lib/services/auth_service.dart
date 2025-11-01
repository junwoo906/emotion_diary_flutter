import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/user.dart';

class AuthService {
  static const bool _isTestMode = true; // 🚨 테스트 모드 플래그
  static const String baseUrl = 'http://localhost:8000/api'; // FastAPI 서버 주소
  
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );
  
  static User? _currentUser;
  
  // 현재 로그인된 사용자 가져오기
  static User? get currentUser => _currentUser;
  
  // Google 로그인
  static Future<User?> signInWithGoogle() async {
    try {
      if (_isTestMode) {
        // 🎭 Mock 로그인 (테스트용)
        print('🧪 테스트 모드: Mock 로그인 시작');
        
        // 로딩 시뮬레이션
        await Future.delayed(Duration(seconds: 2));
        
        // 가짜 사용자 데이터 생성
        _currentUser = User(
          id: 'mock_user_123',
          name: '테스트 사용자',
          email: 'test@example.com',
          profileImage: 'https://ui-avatars.com/api/?name=Test+User&background=6C63FF&color=fff&size=150',
        );
        
        // 가짜 JWT 토큰 저장
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', 'mock_jwt_token_12345');
        await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
        
        print('✅ Mock 로그인 성공: ${_currentUser!.name}');
        return _currentUser;
      } else {
        // 🌐 실제 Google 로그인
        print('🔐 실제 Google 로그인 시작');
        
        final GoogleSignInAccount? account = await _googleSignIn.signIn();
        if (account == null) {
          print('❌ Google 로그인 취소됨');
          return null;
        }
        
        final GoogleSignInAuthentication auth = await account.authentication;
        
        // FastAPI 서버에 Google 토큰 전송
        final response = await http.post(
          Uri.parse('$baseUrl/auth/google'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'google_token': auth.idToken,
            'access_token': auth.accessToken,
            'name': account.displayName,
            'email': account.email,
            'profile_image': account.photoUrl,
          }),
        );
        
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          
          // JWT 토큰 및 사용자 정보 저장
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', data['jwt_token']);
          
          _currentUser = User.fromJson(data['user']);
          await prefs.setString('user_data', jsonEncode(_currentUser!.toJson()));
          
          print('✅ 실제 로그인 성공: ${_currentUser!.name}');
          return _currentUser;
        } else {
          print('❌ 서버 로그인 실패: ${response.statusCode}');
          return null;
        }
      }
    } catch (e) {
      print('❌ 로그인 에러: $e');
      return null;
    }
  }
  
  // 로그아웃
  static Future<void> signOut() async {
    try {
      print('🚪 로그아웃 시작');
      
      if (!_isTestMode) {
        await _googleSignIn.signOut();
      }
      
      // 로컬 데이터 삭제
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('jwt_token');
      await prefs.remove('user_data');
      
      _currentUser = null;
      print('✅ 로그아웃 완료');
    } catch (e) {
      print('❌ 로그아웃 에러: $e');
    }
  }
  
  // 로그인 상태 확인
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final userData = prefs.getString('user_data');
      
      if (token != null && userData != null) {
        // 저장된 사용자 정보 복원
        final userJson = jsonDecode(userData);
        _currentUser = User.fromJson(userJson);
        print('✅ 로그인 상태 복원: ${_currentUser!.name}');
        return true;
      }
      
      print('ℹ️ 로그인되지 않은 상태');
      return false;
    } catch (e) {
      print('❌ 로그인 상태 확인 에러: $e');
      return false;
    }
  }
  
  // JWT 토큰 가져오기
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('jwt_token');
    } catch (e) {
      print('❌ 토큰 조회 에러: $e');
      return null;
    }
  }
  
  // API 호출용 헤더 생성
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
  
  // 🔧 테스트용 - 모든 데이터 삭제
  static Future<void> clearAllData() async {
    try {
      if (!_isTestMode) {
        await _googleSignIn.signOut();
      }
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      _currentUser = null;
      print('🧹 모든 데이터 삭제 완료');
    } catch (e) {
      print('❌ 데이터 삭제 에러: $e');
    }
  }
  
  // 테스트 모드 확인
  static bool get isTestMode => _isTestMode;
}