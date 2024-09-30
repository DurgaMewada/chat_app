import 'dart:developer';
import 'package:chat_app/Controller/auth_controller.dart';
import 'package:chat_app/Services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Controller/chat_controller.dart';
import '../../Modal/chat_modal.dart';
import '../../Services/auth_services.dart';
import '../../Services/cloud_firestore_services.dart';


ChatController chatController = ChatController();
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            buildContainer(),
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
                    try {
                      docIdList.add(snap.id);
                      chatList.add(ChatModal.fromMap(
                          snap.data() as Map<String, dynamic>));
                    } catch (e) {
                      log('Error : $e');
                    }
                  }

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: chatList.length,
                      itemBuilder: (context, index) {


                        var queryData = snapshot.data!.docs;
                        List chatsId = queryData.map((e) => e.id).toList();
                        if (
                            chatList[index].receiver ==
                                AuthService.authService
                                    .getUser()!
                                    .email) {
                          CloudFireStoreService.cloudFireStoreService
                              .updateChat(
                              chatController.receiverEmail.value,
                              chatsId[index],chatController.txtUpdateMessage.text);
                        }

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
                                  padding: const EdgeInsets.all(1),
                                  margin: const EdgeInsets.symmetric(vertical: 3),
                                  constraints: BoxConstraints(
                                    maxWidth: size.width * 0.75, // To limit max width similar to WhatsApp
                                  ),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: chatList[index].sender ==
                                          AuthService.authService
                                              .getUser()!
                                              .email
                                          ? [
                                        Colors.blueGrey[800]!,
                                        Colors.blueGrey[600]!
                                      ]
                                          : [
                                        Colors.blueGrey[200]!,
                                        Colors.blueGrey[400]!
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
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 13,
                                            bottom: 25.0,
                                            right: 70.0,
                                            top: 3),
                                        child: chatList[index].image!.isEmpty && chatList[index].image! == ""
                                            ? Text(
                                          chatList[index].message!,
                                          style: TextStyle(
                                            color: chatList[index].sender == AuthService.authService.getUser()!.email
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 13,
                                          ),
                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(8), // Round the image corners slightly
                                          child: AspectRatio(
                                            aspectRatio: 5 / 3, // Adjust this to maintain the aspect ratio
                                            child: Image.network(
                                              chatList[index].image!,
                                              fit: BoxFit.cover, // Makes the image fit the container smoothly
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
                                                if (chatList[index].isEdited)
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        right: 4.0),
                                                    child: Text(
                                                      "Edited ",
                                                      style: TextStyle(
                                                        color: chatList[index]
                                                            .sender ==
                                                            AuthService
                                                                .authService
                                                                .getUser()!
                                                                .email
                                                            ? Colors.grey[400]
                                                            : Colors.grey[200],
                                                        fontSize: 12,
                                                        fontStyle:
                                                        FontStyle.italic,
                                                      ),
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
                        borderRadius: BorderRadius.circular(25),
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
                                await StorageServices.storageServices.uploadImageToStorage();
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
                      backgroundColor: Colors.blueGrey[900],
                      child: IconButton(
                        icon:
                        // chatController.isMessageEmpty.value
                        //     ? const Icon(Icons.image, color: Colors.white)
                        const Icon(Icons.send, color: Colors.white),
                        onPressed: () async {
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
                              .addChatInFireStore(chat);// Notification Body (message text)
                          chatController.txtMessage.clear();
                          chatController.getImage("");
                        },
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container buildContainer() {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: Color(0xff11171d),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(chatController.receiverImage.value),
            ),
          ),
          const SizedBox(width: 20),
          Column(
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
          Spacer(),
          IconButton(
            icon: const Icon(CupertinoIcons.video_camera_solid,
                color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
