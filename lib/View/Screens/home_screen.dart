import 'dart:developer';

import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestore_services.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/chat_controller.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0d0603),
      appBar: AppBar(
        backgroundColor: const Color(0xff0d0603),
        leading: const Icon(
          Icons.menu_outlined,
          color: Colors.white,
        ),
        title: const Text(
          'WeChat',
          style: TextStyle(color: Colors.white),
        ),
        scrolledUnderElevation: 0.01,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: FutureBuilder(
            future:
                CloudFireStoreService.cloudFireStoreService.readCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              Map? data = snapshot.data!.data();
              UsersModal usersModal = UsersModal.fromMap(data!);
              return Column(
                children: [
                  DrawerHeader(
                      child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(usersModal.image!),
                  )),
                  Text(usersModal.name!),
                  Text(usersModal.email!),
                  Text(usersModal.phone!),
                  SizedBox(height: 15,),
                  ListTile(
                    title: Text("Safety"),
                    trailing: Icon(
                      Icons.safety_check,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5,),
                  ListTile(
                    title: Text("More"),
                    trailing: Icon(
                      Icons.more_rounded,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5,),
                  ListTile(
                    title: Text("Setting"),
                    trailing: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5,),
                  ListTile(
                    title: Text("Find Person"),
                    trailing: Icon(
                      Icons.wifi_find_rounded,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5,),
                  ListTile(
                    title: Text("Infomation"),
                    trailing: Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5,),
                  ListTile(
                    title: Text("Help"),
                    trailing: Icon(
                      Icons.help_center_rounded,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 5,),
                  ListTile(
                    onTap: () async {
                      await AuthService.authService.signOutUser();
                      await GoogleAuthService.googleAuthService
                          .singOutFormGoogle();
                      User? user = AuthService.authService.getUser();
                      if (user == null) {
                        Get.offAndToNamed('/');
                      }
                    },
                    title: Text("Log Out"),
                    trailing: Icon(
                      Icons.logout,
                      color: Colors.black,
                    ),
                  ),
                ],
              );
            }),
      ),
      body: FutureBuilder(
          future: CloudFireStoreService.cloudFireStoreService.readAllUser(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List data = snapshot.data!.docs;
            List<UsersModal> userList = [];
            for (var user in data) {
              userList.add(UsersModal.fromMap(user.data()));
            }
            return Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  height: 610,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  log("receiver name ${userList[index].email!}");
                                  chatController.getReceiver(
                                    userList[index].email!,
                                    userList[index].name!,
                                    userList[index].image!,
                                  );
                                  log("receiver name after click${chatController.receiverEmail.value}");

                                  Get.toNamed('/chat');
                                },
                                title: Text(userList[index].name!),
                                subtitle: const Text('Welcome ,start chatting'),
                                leading: CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(userList[index].image!),
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            );
          }),
    );
  }
}
