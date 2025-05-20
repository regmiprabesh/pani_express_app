import 'package:pani_express/models/user.dart';
import 'package:pani_express/services/api_service.dart';

class UserRepository {
  final ApiService apiService;

  UserRepository({required this.apiService});

  Future<User> getUserProfile() async {
    final response = await apiService.get('user/profile');
    return User.fromJson(response['user']);
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String address,
  }) async {
    await apiService.put('user/profile', {
      'full_name': fullName,
      'address': address,
    });
  }

  Future<Map<String, dynamic>> getReferralStats() async {
    final response = await apiService.get('user/referrals');
    return {
      'referralCode': response['referral_code'],
      'referralCount': response['referral_count'],
      'referralUsers': (response['referral_users'] as List)
          .map((e) => User.fromJson(e))
          .toList(),
    };
  }
}
