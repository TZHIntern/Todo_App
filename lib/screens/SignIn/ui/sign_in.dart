import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc_application/data/repos/auth_repositories.dart';
import 'package:flutter_bloc_application/screens/Home/ui/tabs_screen.dart';
import 'package:flutter_bloc_application/screens/SignIn/bloc/sign_in_bloc.dart';
import 'package:flutter_bloc_application/screens/SignUp/ui/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  static const name = 'SignInScreen';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  bool isEmail = true;
  bool isPassword = true;
  final SignInBloc signInBloc = SignInBloc(AuthRepository());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocConsumer<SignInBloc, SignInState>(
      bloc: signInBloc,
      listenWhen: (previous, current) => current is SignInActionState,
      buildWhen: (previous, current) => current is! SignInActionState,
      listener: (context, state) {
        if (state is EmailSignInSuccessActionState ||
            state is GoogleSignInSuccessActionState) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TabsScreen(),
              ));
        }
        if (state is SignInErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is SignInLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          );
        }
        if (state is SignInInitial) {
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
                        "Login",
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
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailcontroller,
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  errorText: isEmail == false
                                      ? "Please enter email"
                                      : '',
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 228, 227, 227),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  prefixIcon: const Icon(Icons.email_rounded),
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
                              height: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _passwordcontroller,
                              decoration: InputDecoration(
                                  hintText: "Password",
                                  errorText: isPassword == false
                                      ? "Please enter password"
                                      : '',
                                  filled: true,
                                  fillColor:
                                      const Color.fromARGB(255, 228, 227, 227),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  prefixIcon:
                                      const Icon(Icons.lock_open_rounded),
                                  prefixIconColor: Colors.grey),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return value != null && value.length < 6
                                    ? "Enter min. 6 characters"
                                    : null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 220),
                              child: InkWell(
                                child: const Text("Forget Password?"),
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 45,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.black),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                    ))),
                                onPressed: () {
                                  if (_emailcontroller.text == '') {
                                    isEmail = false;
                                  }
                                  if (_passwordcontroller.text == '') {
                                    isPassword = false;
                                  }
                                  _authenticateWithEmailAndPassword(context);
                                },
                                child: const Text('Login'),
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
                    const SizedBox(
                      height: 5,
                    ),
                    const Text("Don't have an account?"),
                    InkWell(
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUp()),
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
      },
    ));
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      signInBloc.add(SignInWithEmailEvent(
          email: _emailcontroller.text, password: _passwordcontroller.text));
    }
  }

//
  void _authenticateWithGoogle(context) {
    signInBloc.add(SignInWithGoogleEvent());
  }
}
