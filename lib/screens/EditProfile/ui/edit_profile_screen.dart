import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_application/screens/Home/bloc/home_bloc.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});
  static const name = "EditProfileScreen";

  @override
  Widget build(BuildContext context) {
    TextEditingController userNameController = TextEditingController();
    TextEditingController bioController = TextEditingController();
    bool isUserName = true;
    bool isBio = true;
    final user = FirebaseAuth.instance.currentUser;
    var userList = [];
    return Scaffold(
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeInitial) {
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Users')
                  .where('userEmail', isEqualTo: user!.email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    for (var i in snapshot.data!.docs) {
                      userList.add(i);
                    }
                    userNameController.text = userList[0]['userName'];
                    bioController.text = userList[0]['Bio'];
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 50),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios)),
                        const Padding(
                          padding: EdgeInsets.only(left: 135),
                          child: Text(
                            "Edit",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Text('')
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(
                            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQS6qO7B0yiJcyOQ4BxsI03B_VPXQgxAOOUMw&usqp=CAU"),
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 30, top: 40),
                        child: Text(
                          "User Name",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: userNameController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.grey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 30, top: 20),
                        child: Text(
                          "Bio",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: bioController,
                        decoration: const InputDecoration(
                            hintStyle: TextStyle(fontSize: 14),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            prefixIcon: Icon(Icons.description),
                            prefixIconColor: Colors.grey),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 45,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFff9f1c)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ))),
                          onPressed: () {
                            if (userNameController.text == '') {
                              isUserName = false;
                            }
                            if (bioController.text == '') {
                              isBio = false;
                            }
                            context.read<HomeBloc>().add(UpdateProfile(
                                userList[0].id,
                                userNameController.text,
                                bioController.text));
                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ),
                    )
                  ],
                );
              },
            );
          }
          return Container();
        },
      ),
    );
  }
}
