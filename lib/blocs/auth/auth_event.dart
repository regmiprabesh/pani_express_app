import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class PhoneNumberSubmitted extends AuthEvent {
  final String phoneNumber;

  const PhoneNumberSubmitted(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class OtpSubmitted extends AuthEvent {
  final String otp;

  const OtpSubmitted(this.otp);

  @override
  List<Object> get props => [otp];
}

class UserDetailsSubmitted extends AuthEvent {
  final String fullName;
  final String address;
  final String? referralCode;

  const UserDetailsSubmitted({
    required this.fullName,
    required this.address,
    this.referralCode,
  });

  @override
  List<Object> get props => [fullName, address, referralCode ?? ''];
}

class LogoutRequested extends AuthEvent {}

class CheckAuthStatus extends AuthEvent {}
