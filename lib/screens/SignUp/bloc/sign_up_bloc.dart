import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc_application/data/repos/auth_repositories.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthRepository authRepository;
  SignUpBloc(this.authRepository) : super(SignUpInitial()) {
    on<SignupWithEmailEvent>(signupWithEmailEvent);
    on<SignupWithGoogleEvent>(signupWithGoogleEvent);
  }

  FutureOr<void> signupWithEmailEvent(
      SignupWithEmailEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    try {
      await authRepository.signUp(email: event.email, password: event.password);
      final user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection("Users").add({
        'userEmail': user!.email,
        'userName': '',
        'Bio': '',
        'Profileimg': '',
        'TimeStamp': DateTime.now().toString(),
      });
      emit(EmailSignUpSuccessActionState());
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
      emit(SignUpInitial());
    }
  }

  FutureOr<void> signupWithGoogleEvent(
      SignupWithGoogleEvent event, Emitter<SignUpState> emit) async {
    emit(SignUpLoadingState());
    try {
      await authRepository.signInWithGoogle();
      emit(GoogleSignUpSuccessActionState());
    } catch (e) {
      emit(SignUpErrorState(error: e.toString()));
      emit(SignUpInitial());
    }
  }
}
