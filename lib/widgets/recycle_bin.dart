import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';
import 'package:flutter_bloc_application/widgets/drawer_widget.dart';
import 'package:flutter_bloc_application/widgets/task_list.dart';

class RecycleBin extends StatelessWidget {
  const RecycleBin({super.key});
  static const name = 'RecycleScreen';

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    return Scaffold(
      // backgroundColor: const Color(0xFFf9dcc4),
      key: key,
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            size: 25,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            key.currentState!.openDrawer();
                          },
                        ),
                        const Text(
                          "Tasks Bin",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              size: 25,
                              color: Colors.grey,
                            )),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Delete All")),
                              onTap: () {
                                deleteAll(
                                  context,
                                );
                              },
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
                const TaskList(
                  screenIndex: '',
                  screenName: name,
                )
              ],
            );
          }
          return Container();
        },
      ),
      drawer: DrawerWidget(user: user),
    );
  }
}

Future<void> deleteAll(BuildContext context) async {
  var documents =
      await FirebaseFirestore.instance.collection("All User Tasks").get();
  var allTaskId = [];
  for (var i in documents.docs) {
    i['isDelete'] ? allTaskId.add(i.id) : allTaskId;
  }

  // ignore: use_build_context_synchronously
  context.read<HomeBloc>().add(DeleteAllFromRestoreItems(allTaskId));
}
