part of 'sign_up_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

abstract class SignUpActionState extends SignUpState {
  const SignUpActionState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpLoadingState extends SignUpState {}

class EmailSignUpSuccessActionState extends SignUpActionState {}

class GoogleSignUpSuccessActionState extends SignUpActionState {}

class SignUpErrorState extends SignUpActionState {
  final String error;

  const SignUpErrorState({required this.error});
}
