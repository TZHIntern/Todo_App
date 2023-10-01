import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';
import 'package:flutter_bloc_application/widgets/edit_task_bottom_sheet.dart';
import 'package:flutter_bloc_application/widgets/recycle_bin.dart';
import 'package:intl/intl.dart';

@override
class Tasktile extends StatelessWidget {
  const Tasktile({
    super.key,
    required this.tasks,
    required this.screenIndex,
    required this.screenName,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> tasks;
  final String screenIndex;
  final String screenName;

  @override
  Widget build(BuildContext context) {
    return screenName == RecycleBin.name
        ? tasks['isDelete'] == true
            ? TaskExpansionTile(tasks: tasks, screenIndex: screenIndex)
            : Container()
        : screenIndex == "0"
            ? tasks['isDelete'] == false
                ? TaskExpansionTile(tasks: tasks, screenIndex: screenIndex)
                : Container()
            : screenIndex == "1"
                ? tasks['isDone'] == true
                    ? TaskExpansionTile(tasks: tasks, screenIndex: screenIndex)
                    : Container()
                : screenIndex == "2"
                    ? tasks['isFav'] == true
                        ? TaskExpansionTile(
                            tasks: tasks, screenIndex: screenIndex)
                        : Container()
                    : Container();
  }
}

class TaskExpansionTile extends StatelessWidget {
  const TaskExpansionTile({
    super.key,
    required this.tasks,
    required this.screenIndex,
  });

  final QueryDocumentSnapshot<Map<String, dynamic>> tasks;
  final String screenIndex;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      textColor: Colors.black87,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tasks['taskTitle'],
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(),
              ),
              Text(
                DateFormat()
                    .add_yMMMMd()
                    .add_Hms()
                    .format(DateTime.parse(tasks['TimeStamp'])),
                style: const TextStyle(fontSize: 12),
              )
            ],
          ),
          PopupMenuButton(
              itemBuilder: tasks['isDelete'] == false
                  ? screenIndex == "0"
                      ? (context) => [
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: () async {
                                    var collection = FirebaseFirestore.instance
                                        .collection('All User Tasks');
                                    var docSnapshot =
                                        await collection.doc(tasks.id).get();
                                    var title = '';
                                    var description = '';
                                    if (docSnapshot.exists) {
                                      Map<String, dynamic>? data =
                                          docSnapshot.data();
                                      title = data?['taskTitle'];
                                      description = data?['taskDescription'];
                                    }
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                    // ignore: use_build_context_synchronously
                                    editTask(
                                        context, tasks.id, title, description);
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text("Edit")),
                              onTap: () {},
                            ),
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    isTaskFavorNot(context, tasks.id);
                                  },
                                  icon: tasks['isFav'] == false
                                      ? const Icon(Icons.bookmark_add)
                                      : const Icon(Icons.bookmark_remove),
                                  label: tasks['isFav'] == false
                                      ? const Text("Add BookMark")
                                      : const Text("Remove BookMark")),
                              onTap: () {
                                // Navigator.of(context).pop();
                                // isTaskFavorNot(context, tasks.id);
                              },
                            ),
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.delete),
                                  label: const Text("Delete")),
                              onTap: () {
                                deleteOrremove(context, tasks.id);
                              },
                            ),
                          ]
                      : (context) => [
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: () async {
                                    var collection = FirebaseFirestore.instance
                                        .collection('All User Tasks');
                                    var docSnapshot =
                                        await collection.doc(tasks.id).get();
                                    var title = '';
                                    var description = '';
                                    if (docSnapshot.exists) {
                                      Map<String, dynamic>? data =
                                          docSnapshot.data();
                                      title = data?['taskTitle'];
                                      description = data?['taskDescription'];
                                    }
                                    // ignore: use_build_context_synchronously
                                    Navigator.of(context).pop();
                                    // ignore: use_build_context_synchronously
                                    editTask(
                                        context, tasks.id, title, description);
                                  },
                                  icon: const Icon(Icons.edit),
                                  label: const Text("Edit")),
                              onTap: () async {
                                // Navigator.of(context).pop();
                                // editTask(context, tasks.id);
                              },
                            ),
                            PopupMenuItem(
                              child: TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    isTaskFavorNot(context, tasks.id);
                                  },
                                  icon: tasks['isFav'] == false
                                      ? const Icon(Icons.bookmark_add)
                                      : const Icon(Icons.bookmark_remove),
                                  label: tasks['isFav'] == false
                                      ? const Text("Add BookMark")
                                      : const Text("Remove BookMark")),
                              onTap: () {},
                            ),
                          ]
                  : (context) => [
                        PopupMenuItem(
                          child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.restore),
                              label: const Text("Restore")),
                          onTap: () {
                            context
                                .read<HomeBloc>()
                                .add(RestoreDeletedItem(tasks.id));
                          },
                        ),
                        PopupMenuItem(
                          child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.delete),
                              label: const Text("Delete Forever")),
                          onTap: () {
                            deleteOrremove(context, tasks.id);
                          },
                        ),
                      ]),
          tasks['isFav'] == false
              ? const Icon(Icons.star_outline)
              : const Icon(
                  Icons.star_border_purple500_rounded,
                  color: Color(0xFFF31559),
                )
        ],
      ),
      leading: Checkbox(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        value: tasks['isDone'],
        onChanged: (value) {
          tasks['isDelete'] == false
              ? isTaskDoneorNot(context, tasks.id)
              : null;
        },
      ),
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: SelectableText.rich(TextSpan(children: [
                const TextSpan(
                  text: "Description \n",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(
                    text: tasks['taskDescription'],
                    style: const TextStyle(fontSize: 14))
              ])),
            ),
          ],
        )
      ],
    );
  }

  void editTask(
      BuildContext context, String taskId, String title, String description) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15), topRight: Radius.circular(15))),
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: EditTaskScreen(
                taskId: taskId,
                title: title,
                description: description,
              ),
            ),
          );
        });
  }
}

Future<void> deleteOrremove(BuildContext context, String taskId) async {
  var collection = FirebaseFirestore.instance.collection('All User Tasks');
  var docSnapshot = await collection.doc(taskId).get();
  var isDeleteValue = false;
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    isDeleteValue = data?['isDelete'];
  }

  if (isDeleteValue == false) {
    // ignore: use_build_context_synchronously
    context.read<HomeBloc>().add(DeleteTaskButtonClickEvent(taskId));
  } else {
    // ignore: use_build_context_synchronously
    context.read<HomeBloc>().add(DeleteFromRecycleBinEvent(taskId));
  }
}

Future<void> isTaskDoneorNot(BuildContext context, String taskId) async {
  var collection = FirebaseFirestore.instance.collection('All User Tasks');
  var docSnapshot = await collection.doc(taskId).get();
  var isDone = false;
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    isDone = data?['isDone'];
  }

  // ignore: use_build_context_synchronously
  context
      .read<HomeBloc>()
      .add(UpdateCompleteCheckBoxClickEvent(taskId, isDone));
}

Future<void> isTaskFavorNot(BuildContext context, String taskId) async {
  var collection = FirebaseFirestore.instance.collection('All User Tasks');
  var docSnapshot = await collection.doc(taskId).get();
  var isFav = false;
  if (docSnapshot.exists) {
    Map<String, dynamic>? data = docSnapshot.data();
    isFav = data?['isFav'];
  }

  // ignore: use_build_context_synchronously
  context.read<HomeBloc>().add(AddtoFavouriteBookMark(taskId, isFav));
}
