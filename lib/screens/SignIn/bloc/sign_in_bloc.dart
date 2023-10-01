import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc_application/data/repos/auth_repositories.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthRepository authRepository;
  SignInBloc(this.authRepository) : super(SignInInitial()) {
    on<SignInWithEmailEvent>(signInWithEmailEvent);
    on<SignInWithGoogleEvent>(signInWithGoogleEvent);
  }

  FutureOr<void> signInWithEmailEvent(
      SignInWithEmailEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());
    try {
      await authRepository.signIn(email: event.email, password: event.password);
      emit(EmailSignInSuccessActionState());
    } catch (e) {
      emit(SignInErrorState(error: e.toString()));
      emit(SignInInitial());
    }
  }

  FutureOr<void> signInWithGoogleEvent(
      SignInWithGoogleEvent event, Emitter<SignInState> emit) async {
    emit(SignInLoadingState());
    try {
      await authRepository.signInWithGoogle();
      emit(GoogleSignInSuccessActionState());
    } catch (e) {
      emit(SignInErrorState(error: e.toString()));
      emit(SignInInitial());
    }
  }
}
