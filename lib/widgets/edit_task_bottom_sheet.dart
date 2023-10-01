import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';

class EditTaskScreen extends StatelessWidget {
  // final Task oldTask;
  final String taskId;
  final String title;
  final String description;
  const EditTaskScreen({
    super.key,
    required this.taskId,
    required this.title,
    required this.description,
    // required this.oldTask,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController(text: title);
    TextEditingController descriptionController =
        TextEditingController(text: description);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            "Edit Task",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      fixedSize: const Size(100, 40),
                      backgroundColor: const Color(0xFF2ec4b6)),
                  onPressed: () {
                    // var editedTask = Task(
                    //     title: titleController.text,
                    //     description: descriptionController.text,
                    //     id: '',
                    //     isFav: false,
                    //     isDone: false,
                    //     dateTime: DateTime.now().toString());
                    context.read<HomeBloc>().add(EditTask(taskId,
                        titleController.text, descriptionController.text));

                    Navigator.pop(context);
                  },
                  child: const Text("Add"))
            ],
          )
        ],
      ),
    );
  }
}
