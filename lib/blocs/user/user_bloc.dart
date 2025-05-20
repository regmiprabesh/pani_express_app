import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pani_express/models/user.dart';
import 'package:pani_express/repositories/user_repository.dart';

// Events
abstract class UserEvent {}

class UserProfileRequested extends UserEvent {}

class UserProfileUpdateRequested extends UserEvent {
  final String fullName;
  final String address;

  UserProfileUpdateRequested({
    required this.fullName,
    required this.address,
  });
}

class UserReferralsRequested extends UserEvent {}

// States
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserProfileLoaded extends UserState {
  final User user;

  UserProfileLoaded(this.user);
}

class UserReferralsLoaded extends UserState {
  final String referralCode;
  final int referralCount;
  final List<User> referralUsers;

  UserReferralsLoaded({
    required this.referralCode,
    required this.referralCount,
    required this.referralUsers,
  });
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}

// BLoC
class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<UserProfileRequested>(_onUserProfileRequested);
    on<UserProfileUpdateRequested>(_onUserProfileUpdateRequested);
    on<UserReferralsRequested>(_onUserReferralsRequested);
  }

  Future<void> _onUserProfileRequested(
    UserProfileRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final user = await userRepository.getUserProfile();
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUserProfileUpdateRequested(
    UserProfileUpdateRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await userRepository.updateUserProfile(
        fullName: event.fullName,
        address: event.address,
      );
      final user = await userRepository.getUserProfile();
      emit(UserProfileLoaded(user));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  Future<void> _onUserReferralsRequested(
    UserReferralsRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final stats = await userRepository.getReferralStats();
      emit(UserReferralsLoaded(
        referralCode: stats['referralCode'],
        referralCount: stats['referralCount'],
        referralUsers: stats['referralUsers'],
      ));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }
}
