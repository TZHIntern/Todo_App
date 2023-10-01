import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_application/screens/EditProfile/ui/edit_profile_screen.dart';

import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';
import 'package:flutter_bloc_application/screens/Home/ui/tabs_screen.dart';
import 'package:flutter_bloc_application/screens/SignIn/ui/sign_in.dart';
import 'package:flutter_bloc_application/widgets/recycle_bin.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var userList = [];
    var userName = '';
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(25), bottomRight: Radius.circular(25)),
      child: Drawer(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(
          //   height: 30,
          // ),
          SizedBox(
            height: 200,
            width: 310,
            child: DrawerHeader(
              decoration: const BoxDecoration(),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Users")
                    .where("userEmail", isEqualTo: user!.email)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      for (var i in snapshot.data!.docs) {
                        userList.add(i);
                      }
                      userName = userList[0]['userName'];
                    }
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQS6qO7B0yiJcyOQ4BxsI03B_VPXQgxAOOUMw&usqp=CAU"),
                            ),
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  backgroundColor: const Color(0xFFEEEDE7)),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(EditProfile.name);
                              },
                              child: const Text(
                                "Edit",
                                style: TextStyle(color: Colors.grey),
                              ))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "$userName",
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${user.email}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const Padding(
              padding: EdgeInsets.only(left: 30), child: Text("BROWSE")),
          const SizedBox(
            height: 10,
          ),
          BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeInitial) {
              return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("All User Tasks")
                      .where("userEmail", isEqualTo: user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var totalTask = [];
                      var removedTask = [];
                      if (snapshot.data!.docs.isNotEmpty) {
                        for (var i in snapshot.data!.docs) {
                          i['isDelete'] ? removedTask.add(i) : totalTask.add(i);
                        }
                      }
                      return Column(
                        children: [
                          GestureDetector(
                            child: ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.feed,
                                  color: Color(0xFFff9f1c),
                                ),
                                onPressed: () {},
                              ),
                              title: const Text("Feed"),
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(RecycleBin.name),
                          ),
                          GestureDetector(
                            child: ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.task,
                                  color: Color(0xFFff9f1c),
                                ),
                                onPressed: () {},
                              ),
                              title: const Text("My Tasks"),
                              trailing: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFFFB4570),
                                  child: Text(
                                    '${totalTask.length}',
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(TabsScreen.name),
                          ),
                          GestureDetector(
                            child: ListTile(
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Color(0xFFff9f1c),
                                ),
                                onPressed: () {},
                              ),
                              title: const Text("Task Bin"),
                              trailing: CircleAvatar(
                                  radius: 14,
                                  backgroundColor: const Color(0xFFFB4570),
                                  child: Text(
                                    "${removedTask.length}",
                                    style: const TextStyle(color: Colors.white),
                                  )),
                            ),
                            onTap: () => Navigator.of(context)
                                .pushNamed(RecycleBin.name),
                          )
                        ],
                      );
                    } else {
                      return Container();
                    }
                  });
            }
            return Container();
          }),

          GestureDetector(
            child: ListTile(
              leading: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {},
              ),
              title: const Text("Logout"),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(SignIn.name);
              context.read<HomeBloc>().add(LogoutButtonPressedEvent());
            },
          )
        ],
      )),
    );
  }
}
