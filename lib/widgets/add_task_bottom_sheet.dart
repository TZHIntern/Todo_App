import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_application/data/models/tasks.dart';

import '../screens/Home/bloc/home_bloc.dart';
import 'package:uuid/uuid.dart';

class AddTaskBottomSheet extends StatelessWidget {
  const AddTaskBottomSheet({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: CircleAvatar(
        backgroundColor: const Color(0xFFff9f1c),
        child: IconButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              const Text(
                                "Add Task",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500),
                              ),
                              TextFormField(
                                controller: titleController,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.note),
                                    prefixIconColor: Color(0xFFffbf69),
                                    hintText: "Enter Title"),
                              ),
                              TextFormField(
                                controller: descriptionController,
                                minLines: 1,
                                maxLines: 5,
                                autofocus: true,
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.description),
                                    prefixIconColor: Color(0xFFffbf69),
                                    hintText: "Enter Description"),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          fixedSize: const Size(100, 40),
                                          backgroundColor:
                                              const Color(0xFF2ec4b6)),
                                      onPressed: () {
                                        var taskId = const Uuid().v1();
                                        var task = Task(
                                            title: titleController.text,
                                            description:
                                                descriptionController.text,
                                            id: taskId,
                                            dateTime:
                                                DateTime.now().toString());
                                        context
                                            .read<HomeBloc>()
                                            .add(AddTaskButtonClickEvent(task));

                                        Navigator.pop(context);
                                      },
                                      child: const Text("Add"))
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}
