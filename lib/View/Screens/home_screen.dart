import 'package:chat_app/Modal/user_modal.dart';
import 'package:chat_app/Services/auth_services.dart';
import 'package:chat_app/Services/cloud_firestore_services.dart';
import 'package:chat_app/Services/google_auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/chat_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    ChatController chatController = ChatController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page '),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
               await AuthService.authService.signOutUser();
              await GoogleAuthService.googleAuthService.singOutFormGoogle();
                User? user = AuthService.authService.getUser();
                if (user == null) {
                  Get.offAndToNamed('/');
                }
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      drawer: Drawer(
        child: FutureBuilder(future: CloudFireStoreService.cloudFireStoreService.readCurrentUser(), builder: (context,snapshot){
          if(snapshot.hasError)
            {
              return Center(child: Text(snapshot.error.toString()),);
            }
          if(snapshot.connectionState == ConnectionState.waiting)
            {
              return const Center(child: CircularProgressIndicator(),);
            }
              Map? data = snapshot.data!.data();
              UsersModal usersModal = UsersModal.fromMap(data!);
              return Obx(
                  ()=>Column(
                    children: [
                      DrawerHeader(child: CircleAvatar(radius: 50,backgroundImage: NetworkImage(usersModal.image!),)),
                      Text(usersModal.name!),
                      Text(usersModal.email!),
                      Text(usersModal.phone!),
                    ],
                  )
              );

        }),
      ),
      body: FutureBuilder(future: CloudFireStoreService.cloudFireStoreService.readAllUser(), builder: (context,snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()),);
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        List data = snapshot.data!.docs;
        List<UsersModal> userList = [];
        for (var user in data) {
          userList.add(UsersModal.fromMap(user.data()));
        }
         return  ListView.builder(
         itemCount: userList.length,
    itemBuilder: (context, index)
        {
          return Column(
            children: [
              ListTile(
                onTap: () {
                  chatController.getReceiver(
                    userList[index].email!,
                    userList[index].name!,
                    userList[index].image!,
                  );
                  Get.toNamed('/chat');
                },
                trailing: CircleAvatar(
                  radius: 10,
                  backgroundColor: Colors.green,
                  child: Text('1', style: TextStyle(
                      color: Colors.white,

                      fontSize: 10

                  ),),
                ),
                title: Text(userList[index].name!),
                subtitle: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: CloudFireStoreService.cloudFireStoreService
                      .getLastMessageStream(userList[index].email!),
                  builder: (context, messageSnapshot) {
                    if (messageSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Text('Loading...');
                    }

                    if (messageSnapshot.hasError) {
                      return Text('Error: ${messageSnapshot.error}');
                    }

                    if (messageSnapshot.hasData &&
                        messageSnapshot.data!.docs.isNotEmpty) {
                      var lastMessageData = messageSnapshot.data!.docs[0];
                      String lastMessage =
                          lastMessageData['message'] ?? 'No message';
                      return Container(
                        height: 25,
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            overflow: TextOverflow.fade,
                            fontSize: MediaQuery
                                .of(context)
                                .size
                                .width * 0.04, // Responsive font size
                          ),
                        ),
                      );
                    } else {
                      return Text('No messages yet');
                    }
                  },
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(userList[index].image!),
                ),
              )
            ],
          );
        }
         );
      }
      ),
    );
  }
}






