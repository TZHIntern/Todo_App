part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();

  @override
  List<Object> get props => [];
}

abstract class SignInActionState extends SignInState {
  const SignInActionState();

  @override
  List<Object> get props => [];
}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class EmailSignInSuccessActionState extends SignInActionState {}

class GoogleSignInSuccessActionState extends SignInActionState {}

class SignInErrorState extends SignInActionState {
  final String error;

  const SignInErrorState({required this.error});
}
