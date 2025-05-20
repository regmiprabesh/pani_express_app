class User {
  final int id;
  final String fullName;
  final String phoneNumber;
  final String address;
  final String referralCode;
  final int referralCount;

  User({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.referralCode,
    this.referralCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
      address: json['address'],
      referralCode: json['referral_code'],
      referralCount: json['referral_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'address': address,
      'referral_code': referralCode,
      'referral_count': referralCount,
    };
  }
}
