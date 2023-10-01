import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc_application/widgets/recycle_bin.dart';

import 'package:flutter_bloc_application/widgets/task_tile.dart';

class TaskList extends StatelessWidget {
  final String screenIndex;
  final String screenName;

  const TaskList(
      {super.key, required this.screenIndex, required this.screenName});

  // void fetchDataFromDB() {
  //   final user = FirebaseAuth.instance.currentUser;
  //   final snapshot = FirebaseFirestore.instance
  //       .collection("All User Tasks")
  //       .where("userEmail", isEqualTo: user!.email)
  //       .get();
  //   final userTask = print(snapshot);
  // }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    // fetchDataFromDB();
    return Expanded(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("All User Tasks")
                .where("userEmail", isEqualTo: user!.email)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var tasks = snapshot.data!.docs[index];
                        //Task task = list[index];
                        return Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                child: Tasktile(
                                  tasks: tasks,
                                  screenIndex: screenIndex,
                                  screenName: screenName,
                                )));
                      });
                } else {
                  return SizedBox(
                    height: 700,
                    child: Center(
                      child: Text(
                        screenName == RecycleBin.name
                            ? "No tasks in task bin."
                            : screenIndex == "0"
                                ? "You have no taks already."
                                : '',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }
              }
              return Container();
            }
            //  TaskTile(
            //   task: tasks,
            //   screenIndex: screenIndex,
            // )
            ));
  }
}


    

        //      ListView.builder(
        //   itemCount: list.length,
        //   itemBuilder: (context, index) {
        //     Task task = list[index];
        //     return Padding(
        //         padding: const EdgeInsets.only(left: 10, right: 10),
        //         child: Card(
        //             elevation: 2,
        //             shape: RoundedRectangleBorder(
        //                 borderRadius: BorderRadius.circular(25)),
        //             child: TaskTile(
        //               task: task,
        //               screenIndex: screenIndex,
        //             )));
        //   },
        // )
        
