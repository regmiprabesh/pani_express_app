import 'package:equatable/equatable.dart';
import 'package:pani_express/models/user.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  newUser
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final String? phoneNumber;
  final String? sessionId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
    this.phoneNumber,
    this.sessionId,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    String? phoneNumber,
    String? sessionId,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  @override
  List<Object?> get props =>
      [status, user, errorMessage, phoneNumber, sessionId];
}
