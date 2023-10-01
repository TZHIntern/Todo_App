part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {
  const SignInEvent();

  @override
  List<Object> get props => [];
}

class SignInWithEmailEvent extends SignInEvent {
  final String email;
  final String password;

  const SignInWithEmailEvent({required this.email, required this.password});
}

class SignInWithGoogleEvent extends SignInEvent {}
