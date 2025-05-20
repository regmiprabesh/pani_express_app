import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pani_express/blocs/auth/auth_event.dart';
import 'package:pani_express/blocs/auth/auth_state.dart';
import 'package:pani_express/repositories/auth_repository.dart';
import 'package:pani_express/utils/secure_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  final SecureStorage secureStorage = SecureStorage();

  AuthBloc({required this.authRepository}) : super(const AuthState()) {
    on<PhoneNumberSubmitted>(_onPhoneNumberSubmitted);
    on<OtpSubmitted>(_onOtpSubmitted);
    on<UserDetailsSubmitted>(_onUserDetailsSubmitted);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onPhoneNumberSubmitted(
    PhoneNumberSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final result = await authRepository.sendOtp(event.phoneNumber);

      if (result['isRegistered'] == true) {
        // User exists, OTP sent, waiting for verification
        emit(state.copyWith(
          status: AuthStatus.otpSent,
          phoneNumber: event.phoneNumber,
          sessionId: result['sessionId'],
        ));
      } else {
        // New user, OTP sent, will need additional details after verification
        emit(state.copyWith(
          status: AuthStatus.otpSent,
          phoneNumber: event.phoneNumber,
          sessionId: result['sessionId'],
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onOtpSubmitted(
    OtpSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final result = await authRepository.verifyOtp(
        state.phoneNumber!,
        event.otp,
        state.sessionId!,
      );

      if (result['isRegistered'] == true) {
        // Existing user, authenticated
        await secureStorage.writeToken(result['token']);

        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: result['user'],
        ));
      } else {
        // New user, needs to provide additional details
        emit(state.copyWith(
          status: AuthStatus.newUser,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.otpSent, // Back to OTP entry state
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onUserDetailsSubmitted(
    UserDetailsSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final result = await authRepository.registerUser(
        phoneNumber: state.phoneNumber!,
        fullName: event.fullName,
        address: event.address,
        referralCode: event.referralCode,
      );

      await secureStorage.writeToken(result['token']);

      emit(state.copyWith(
        status: AuthStatus.authenticated,
        user: result['user'],
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AuthStatus.newUser, // Back to registration form
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      await authRepository.logout();
      await secureStorage.deleteToken();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    } catch (e) {
      // Even if logout fails on server, we clear local storage
      await secureStorage.deleteToken();
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(status: AuthStatus.loading));
    try {
      final token = await secureStorage.readToken();
      if (token != null) {
        final user = await authRepository.getCurrentUser();
        emit(state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
        ));
      } else {
        emit(const AuthState(status: AuthStatus.unauthenticated));
      }
    } catch (e) {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }
}
