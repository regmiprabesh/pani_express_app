import 'package:pani_express/models/user.dart';
import 'package:pani_express/services/api_service.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    final response = await apiService.post('auth/send-otp', {
      'phone_number': phoneNumber,
    });

    return {
      'isRegistered': response['is_registered'] ?? false,
      'sessionId': response['session_id'],
    };
  }

  Future<Map<String, dynamic>> verifyOtp(
    String phoneNumber,
    String otp,
    String sessionId,
  ) async {
    final response = await apiService.post('auth/verify-otp', {
      'phone_number': phoneNumber,
      'otp': otp,
      'session_id': sessionId,
    });

    return {
      'isRegistered': response['is_registered'] ?? false,
      'token': response['token'],
      'user':
          response['is_registered'] ? User.fromJson(response['user']) : null,
    };
  }

  Future<Map<String, dynamic>> registerUser({
    required String phoneNumber,
    required String fullName,
    required String address,
    String? referralCode,
  }) async {
    final response = await apiService.post('auth/register', {
      'phone_number': phoneNumber,
      'full_name': fullName,
      'address': address,
      if (referralCode != null && referralCode.isNotEmpty)
        'referral_code': referralCode,
    });

    return {
      'token': response['token'],
      'user': User.fromJson(response['user']),
    };
  }

  Future<User> getCurrentUser() async {
    final response = await apiService.get('auth/user');
    return User.fromJson(response['user']);
  }

  Future<void> logout() async {
    await apiService.post('auth/logout', {});
  }
}
