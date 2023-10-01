import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';
import 'package:flutter_bloc_application/screens/Home/ui/completed_tasks.dart';
import 'package:flutter_bloc_application/screens/Home/ui/favourite.dart';
import 'package:flutter_bloc_application/screens/Home/ui/home.dart';
import 'package:flutter_bloc_application/widgets/add_task_bottom_sheet.dart';
import 'package:flutter_bloc_application/widgets/drawer_widget.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});
  static const name = "TabsScreen";
  // final String userId;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  var selectedIndex = 0;
  final List<Widget> pageDetails = <Widget>[
    const Home(
      screenIndex: "0",
    ),
    const CompletedTasks(
      screenIndex: "1",
    ),
    const Favourite(
      screenIndex: "2",
    )
  ];

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      // backgroundColor: const Color(0xFFf9dcc4),
      key: key,
      body: Column(
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
                    "My Todo",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Row(
                children: [AddTaskBottomSheet()],
              )
            ],
          ),
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial) {
                if (selectedIndex == 0) {
                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("All User Tasks")
                        .where("userEmail", isEqualTo: user!.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data!.docs.isNotEmpty) {
                          var totalTask = [];
                          var completedTask = [];
                          for (var i in snapshot.data!.docs) {
                            i['isDone'] ? completedTask.add(i) : completedTask;
                            i['isDelete'] ? totalTask : totalTask.add(i);
                          }
                          return Padding(
                            padding: const EdgeInsets.only(left: 20, top: 20),
                            child: Text(
                              "${completedTask.length} / ${totalTask.length} Completed.",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          );
                        }
                      } else {
                        return Container();
                      }
                      return Container();
                    },
                  );
                }
              }
              return Container();
            },
          ),
          pageDetails.elementAt(selectedIndex)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: const Color(
        //   0xFFff9f1c,
        // ),
        unselectedLabelStyle:
            const TextStyle(fontSize: 14, color: Colors.black12),
        selectedItemColor: Colors.black87,
        unselectedIconTheme: const IconThemeData(color: Colors.black12),
        iconSize: 28,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
              ),
              label: "Home"),
          BottomNavigationBarItem(
              icon: Icon(Icons.done), label: "Completed Tasks"),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
              ),
              label: "Favourite")
        ],
      ),
      drawer: DrawerWidget(user: user),
    );
  }
}
