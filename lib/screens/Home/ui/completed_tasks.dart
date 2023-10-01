import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';
import 'package:flutter_bloc_application/screens/SignIn/ui/sign_in.dart';

import 'package:flutter_bloc_application/widgets/task_list.dart';

class CompletedTasks extends StatelessWidget {
  final String screenIndex;
  const CompletedTasks({super.key, required this.screenIndex});
  static const name = 'TaskScreen';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is LoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is NavigateToLogInPageState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignIn(),
              ));
        }
        if (state is HomeInitial) {
          return TaskList(
            screenIndex: screenIndex,
            screenName: '',
          );
        }
        return Container();
      },
    );
  }
}
