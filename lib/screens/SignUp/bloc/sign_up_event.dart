part of 'sign_up_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignupWithEmailEvent extends SignUpEvent {
  final String email;
  final String password;

  const SignupWithEmailEvent({required this.email, required this.password});
}

class SignupWithGoogleEvent extends SignUpEvent {}
