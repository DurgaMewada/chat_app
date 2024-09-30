import 'dart:developer';

import 'package:chat_app/Controller/chat_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Modal/chat_modal.dart';
import '../../Services/auth_services.dart';
import '../../Services/cloud_firestore_services.dart';
import '../../Services/storage_service.dart';
import 'home_screen.dart';

ChatController chatController = Get.put(ChatController());

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Color(0xff0d0603),
      appBar: AppBar(
        backgroundColor: Color(0xff0d0603),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(chatController.receiverImage.value),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              chatController.receiverName.value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Active now",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
        actions: [
          Icon(Icons.phone, color: Colors.white),
          SizedBox(width: 5,),
          Icon(Icons.more_vert, color: Colors.white),
          SizedBox(width: 10,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Container(
                height: 610,
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))
                ),
                child:Column(
                  children: [
                    Expanded(
                      child: StreamBuilder(
                        stream: CloudFireStoreService.cloudFireStoreService
                            .readChatFromFireStore(chatController.receiverEmail.value),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error.toString()}"),
                            );
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("");
                          }

                          List data = snapshot.data!.docs;
                          List<ChatModal> chatList = [];
                          List<String> docIdList = [];

                          for (QueryDocumentSnapshot snap in data) {
                            {
                              docIdList.add(snap.id);
                              chatList.add(ChatModal.fromMap(
                                  snap.data() as Map<String, dynamic>));
                            }
                          }

                          return Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ListView.builder(
                              itemCount: chatList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Align(
                                    alignment: chatList[index].sender ==
                                        AuthService.authService
                                            .getUser()!
                                            .email
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: chatList[index].sender ==
                                          AuthService.authService
                                              .getUser()!
                                              .email
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(3),
                                          margin:
                                          const EdgeInsets.symmetric(vertical: 3),
                                          constraints: BoxConstraints(
                                            maxWidth: size.width * 0.80,
                                          ),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: chatList[index].sender ==
                                                  AuthService.authService
                                                      .getUser()!
                                                      .email
                                                  ? [
                                                Color(0xffe3f3ff),
                                                Color(0xffe3f3ff)
                                              ]
                                                  : [
                                                Color(0xffebd3d6),
                                                Color(0xffebd3d6)
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(15),
                                              topLeft: chatList[index].sender ==
                                                  AuthService.authService
                                                      .getUser()!
                                                      .email
                                                  ? Radius.circular(15)
                                                  : Radius.zero,
                                              topRight: chatList[index].sender !=
                                                  AuthService.authService
                                                      .getUser()!
                                                      .email
                                                  ? Radius.circular(15)
                                                  : Radius.zero,
                                            ),
                                          ),
                                          child: Stack(
                                            children: [
                                              chatList[index].image!.isEmpty &&
                                                  chatList[index].image! == ""
                                                  ? Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 15,
                                                      bottom: 25.0,
                                                      right: 70.0,
                                                      top: 5),

                                                  child: Text(
                                                    chatList[index].message!,
                                                    style: TextStyle(

                                                      color: chatList[index]
                                                          .sender ==
                                                          AuthService
                                                              .authService
                                                              .getUser()!
                                                              .email
                                                          ? Colors.black
                                                          : Colors.black,
                                                      fontSize: 13,
                                                    ),
                                                  ))
                                                  : Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: AspectRatio(
                                                    aspectRatio: 5 / 4,
                                                    child: Image.network(
                                                      chatList[index].image!,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 2,
                                                right: 0,
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            showDialog(
                                                              context: context,
                                                              builder: (BuildContext
                                                              context) {
                                                                return CupertinoAlertDialog(
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      onPressed: () {
                                                                        Navigator.of(
                                                                            context)
                                                                            .pop();
                                                                      },
                                                                      child:
                                                                      Text("Copy"),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      onPressed: () {
                                                                        Navigator.of(
                                                                            context)
                                                                            .pop();
                                                                        if (chatList[index]
                                                                            .sender ==
                                                                            AuthService
                                                                                .authService
                                                                                .getUser()!
                                                                                .email) {
                                                                          // Directly call the dialog without Future.delayed
                                                                          chatController
                                                                              .txtUpdateMessage =
                                                                              TextEditingController(
                                                                                  text: chatList[index]
                                                                                      .message);

                                                                          showDialog(
                                                                            context: context,
                                                                            builder: (
                                                                                context) {
                                                                              return AlertDialog(
                                                                                title: Text(
                                                                                  'Edit Message',
                                                                                  style: TextStyle(
                                                                                    fontWeight: FontWeight
                                                                                        .w600,
                                                                                    fontSize: 18,
                                                                                    color: Colors
                                                                                        .black,
                                                                                  ),
                                                                                ),
                                                                                content: Container(
                                                                                  width: 300,
                                                                                  child: TextField(
                                                                                    cursorColor: Colors
                                                                                        .grey[700],
                                                                                    controller: chatController
                                                                                        .txtUpdateMessage,
                                                                                    decoration: InputDecoration(
                                                                                      border: OutlineInputBorder(
                                                                                        borderRadius: BorderRadius
                                                                                            .circular(
                                                                                            10.0),
                                                                                        borderSide: BorderSide
                                                                                            .none,
                                                                                      ),
                                                                                      fillColor: Colors
                                                                                          .grey[200],
                                                                                      filled: true,
                                                                                      hintText: 'Enter your message here...',
                                                                                      hintStyle: TextStyle(
                                                                                          color: Colors
                                                                                              .grey[600]),
                                                                                      contentPadding: EdgeInsets
                                                                                          .symmetric(
                                                                                          vertical: 10,
                                                                                          horizontal: 15),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                actions: [
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      Navigator
                                                                                          .of(
                                                                                          context)
                                                                                          .pop();
                                                                                    },
                                                                                    child: Text(
                                                                                      'Cancel',
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .blueAccent),
                                                                                    ),
                                                                                  ),
                                                                                  TextButton(
                                                                                    onPressed: () {
                                                                                      String dcId = docIdList[index];
                                                                                      Navigator
                                                                                          .of(
                                                                                          context)
                                                                                          .pop();
                                                                                      CloudFireStoreService
                                                                                          .cloudFireStoreService
                                                                                          .updateChat(
                                                                                        dcId,
                                                                                        chatController
                                                                                            .txtUpdateMessage
                                                                                            .text,
                                                                                        chatController
                                                                                            .receiverEmail
                                                                                            .value,
                                                                                      );
                                                                                      Get
                                                                                          .back();
                                                                                    },
                                                                                    child: Text(
                                                                                      'Edit',
                                                                                      style: TextStyle(
                                                                                          color: Colors
                                                                                              .blueAccent),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                                shape: RoundedRectangleBorder(
                                                                                  borderRadius: BorderRadius
                                                                                      .circular(
                                                                                      15.0),
                                                                                ),
                                                                                elevation: 5,
                                                                                backgroundColor: Colors
                                                                                    .white,
                                                                              );
                                                                            },
                                                                          );
                                                                        }
                                                                      },
                                                                      child: Text("Edit"),
                                                                    ),

                                                                    CupertinoDialogAction(
                                                                      onPressed: () {
                                                                        Navigator.of(
                                                                            context)
                                                                            .pop();
                                                                        showDialog(
                                                                          context:
                                                                          context,
                                                                          builder:
                                                                              (context) {
                                                                            return AlertDialog(
                                                                              title: Text(
                                                                                  'Delete Message'),
                                                                              content: Text(
                                                                                  'Are you sure you want to delete this message?'),
                                                                              actions: [
                                                                                TextButton(
                                                                                  onPressed:
                                                                                      () {
                                                                                    Navigator
                                                                                        .of(
                                                                                        context)
                                                                                        .pop();
                                                                                  },
                                                                                  child:
                                                                                  Text(
                                                                                      'Cancel'),
                                                                                ),
                                                                                TextButton(
                                                                                  onPressed:
                                                                                      () {
                                                                                    CloudFireStoreService
                                                                                        .cloudFireStoreService
                                                                                        .removeChat(
                                                                                      docIdList[index],
                                                                                      chatController
                                                                                          .receiverEmail
                                                                                          .value,
                                                                                    );
                                                                                    Navigator
                                                                                        .of(
                                                                                        context)
                                                                                        .pop();
                                                                                  },
                                                                                  child:
                                                                                  Text(
                                                                                      'Delete'),
                                                                                ),
                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                      child: Text(
                                                                          "Delete"),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            );
                                                            ;
                                                          },
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.only(
                                                                left: 4.0),
                                                            child: chatList[index]
                                                                .sender ==
                                                                AuthService
                                                                    .authService
                                                                    .getUser()!
                                                                    .email
                                                                ? Icon(Icons.touch_app,
                                                              color:Color(0xffe3f3ff),
                                                              size: 50,)
                                                                : null,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: TextField(
                                  controller: chatController.txtMessage,
                                  decoration: InputDecoration(
                                    hintText: 'Type your message...',
                                    border: InputBorder.none,
                                    suffixIcon: IconButton(
                                      icon: const Icon(
                                        Icons.image,
                                      ),
                                      onPressed: () async {
                                        String url =
                                        await StorageServices.storageServices
                                            .uploadImageToStorage();
                                        chatController.getImage(url);
                                        print("photo pressed");
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          CircleAvatar(
                              radius: 25,
                              backgroundColor: Color(0xff0d0603),
                              child: IconButton(
                                icon: Icon(Icons.send, color: Colors.white,size: 20,),
                                onPressed: () async {
                                  if (!chatController.isMessageEmpty.value) {
                                    ChatModal chat = ChatModal(
                                      image: chatController.image.value,
                                      sender: AuthService.authService
                                          .getUser()!
                                          .email,
                                      receiver: chatController.receiverEmail.value,
                                      message: chatController.txtMessage.text.trim(),
                                      time: Timestamp.now(),
                                    );
                                    await CloudFireStoreService.cloudFireStoreService
                                        .addChatInFireStore(chat);

                                    chatController.txtMessage.clear();
                                    chatController.getImage("");
                                  }
                                },
                              )),
                        ],
                      ),
                    ),
                  ],
                )
            ),
            
          ],
        ),
      ),
    );
  }


}