import 'package:email_validator/email_validator.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_application/data/repos/auth_repositories.dart';
import 'package:flutter_bloc_application/screens/Home/ui/home.dart';
import 'package:flutter_bloc_application/screens/SignIn/ui/sign_in.dart';
import 'package:flutter_bloc_application/screens/SignUp/bloc/sign_up_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final SignUpBloc signUpBloc = SignUpBloc(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<SignUpBloc, SignUpState>(
            bloc: signUpBloc,
            buildWhen: (previous, current) => current is! SignUpActionState,
            listenWhen: (previous, current) => current is SignUpActionState,
            listener: (context, state) {
              if (state is EmailSignUpSuccessActionState) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ));
              }
              if (state is GoogleSignUpSuccessActionState) {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Home(
                        screenIndex: "0",
                      ),
                    ));
              }
              if (state is SignUpErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              if (state is SignUpLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ),
                );
              }
              if (state is SignUpInitial) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Create an Account",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          Center(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // TextFormField(
                                  //   keyboardType: TextInputType.text,
                                  //   controller: _usernamecontroller,
                                  //   decoration: const InputDecoration(
                                  //       hintText: "User Name",
                                  //       filled: true,
                                  //       fillColor:
                                  //           Color.fromARGB(255, 228, 227, 227),
                                  //       border: OutlineInputBorder(
                                  //           borderSide: BorderSide.none,
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(30))),
                                  //       prefixIcon: Icon(Icons.person),
                                  //       prefixIconColor: Colors.grey),
                                  //   autovalidateMode:
                                  //       AutovalidateMode.onUserInteraction,
                                  //   validator: (value) {
                                  //     return value != null
                                  //         ? 'Enter username'
                                  //         : null;
                                  //   },
                                  // ),
                                  // const SizedBox(
                                  //   height: 30,
                                  // ),
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _emailcontroller,
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 228, 227, 227),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        prefixIcon: Icon(Icons.email_rounded),
                                        prefixIconColor: Colors.grey),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null &&
                                              !EmailValidator.validate(value)
                                          ? 'Enter a valid email'
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    controller: _passwordcontroller,
                                    decoration: const InputDecoration(
                                        hintText: "Password",
                                        filled: true,
                                        fillColor:
                                            Color.fromARGB(255, 228, 227, 227),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30))),
                                        prefixIcon:
                                            Icon(Icons.lock_open_rounded),
                                        prefixIconColor: Colors.grey),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value != null && value.length < 6
                                          ? "Enter min. 6 characters"
                                          : null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  // TextFormField(
                                  //   keyboardType: TextInputType.text,
                                  //   controller: _city,
                                  //   decoration: const InputDecoration(
                                  //       hintText: "City",
                                  //       filled: true,
                                  //       fillColor:
                                  //           Color.fromARGB(255, 228, 227, 227),
                                  //       border: OutlineInputBorder(
                                  //           borderSide: BorderSide.none,
                                  //           borderRadius: BorderRadius.all(
                                  //               Radius.circular(30))),
                                  //       prefixIcon: Icon(Icons.home),
                                  //       prefixIconColor: Colors.grey),
                                  //   autovalidateMode:
                                  //       AutovalidateMode.onUserInteraction,
                                  //   validator: (value) {
                                  //     return value != null
                                  //         ? 'Enter your city'
                                  //         : null;
                                  //   },
                                  // ),
                                  // const SizedBox(
                                  //   height: 30,
                                  // ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height: 45,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.black),
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ))),
                                      onPressed: () {
                                        _authenticateWithEmailAndPassword(
                                            context);
                                      },
                                      child: const Text('Sign Up'),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _authenticateWithGoogle(context);
                            },
                            icon: Image.network(
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/5/53/Google_%22G%22_Logo.svg/1200px-Google_%22G%22_Logo.svg.png",
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const Text("Already have an acccount?"),
                          InkWell(
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignIn()),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
              return Container();
            }));
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      signUpBloc.add(SignupWithEmailEvent(
          email: _emailcontroller.text, password: _passwordcontroller.text));
    }
  }

//
  void _authenticateWithGoogle(context) {
    signUpBloc.add(SignupWithGoogleEvent());
  }
}
