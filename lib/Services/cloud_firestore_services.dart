// import 'package:chat_app/Services/auth_services.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import '../Modal/chat_modal.dart';
// import '../Modal/user_modal.dart';
//
// class CloudFireStoreService {
//   CloudFireStoreService._();
//
//   static CloudFireStoreService cloudFireStoreService =
//       CloudFireStoreService._();
//
//   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
//
//   Future<void> insertUserInFireStore(UsersModal user) async {
//     await firebaseFirestore.collection("users").doc(user.email).set(
//       {
//         'email':user.email,
//         'name':user.name,
//         'phone':user.phone,
//         'image':user.image,
//         'token':user.token,
//       }
//     );
//   }
//
//   Future<DocumentSnapshot<Map<String, dynamic>>> readCurrentUser()
//   async {
//     User? user = AuthService.authService.getUser();
//     return await firebaseFirestore.collection("user").doc(user!.email).get();
//   }
//
//   Future<QuerySnapshot<Map<String, dynamic>>>
//   readAllUser() async {
//     User? user = AuthService.authService.getUser();
//     return await firebaseFirestore
//         .collection("users")
//         .where("email", isNotEqualTo: user!.email)
//         .get();
//   }
//
//   Future<void> addChatInFireStore(ChatModal chat) async {
//     String? sender = chat.sender;
//     String? receiver = chat.receiver;
//
//     List<String?> doc = [sender, receiver];
//     doc.sort();
//     String docId = doc.join("_");
//     await firebaseFirestore
//         .collection("chatroom")
//         .doc(docId)
//         .collection("chat")
//         .add(chat.toMap(chat));
//   }
//
//   Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(
//       String receiver) {
//     String sender = AuthService.authService.getUser()!.email!;
//     List<String?> doc = [sender, receiver];
//     doc.sort();
//
//     String docId = doc.join("_");
//
//     return firebaseFirestore
//         .collection("chatroom")
//         .doc(docId)
//         .collection("chat")
//         .orderBy('time', descending: false)
//         .snapshots();
//   }
//
//   Future<void> updateChat(String dcId, String message, String receiver) async {
//     String sender = AuthService.authService.getUser()!.email!;
//     List<String?> doc = [sender, receiver];
//     doc.sort();
//
//     String docId = doc.join("_");
//     await firebaseFirestore
//         .collection("chatroom")
//         .doc(docId)
//         .collection("chat")
//         .doc(dcId)
//         .update({
//       'message': message,
//       'isEdited': true,
//     });
//   }
//
//   Future<void> removeChat(String dcId, String receiver) async {
//     String sender = AuthService.authService.getUser()!.email!;
//     List<String?> doc = [sender, receiver];
//     doc.sort();
//     String docId = doc.join("_");
//
//     await firebaseFirestore
//         .collection("chatroom")
//         .doc(docId)
//         .collection("chat")
//         .doc(dcId)
//         .delete();
//   }
//
//   Future<void> updateToken(String token) async {
//     String sender = AuthService.authService.getUser()!.email!;
//     await firebaseFirestore.collection("users").doc(sender).update({
//       'token': token,
//     });
//   }
//
// }




import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Modal/chat_modal.dart';
import '../Modal/user_modal.dart';
import '../controller/chat_controller.dart';
import 'auth_services.dart';

class CloudFireStoreService {
  CloudFireStoreService._();

  static CloudFireStoreService cloudFireStoreService =
  CloudFireStoreService._();

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<void> insertUserInFireStore(UsersModal user) async {
    await fireStore.collection("users").doc(user.email).set({
      'name': user.name,
      'email': user.email,
      'image': user.image,
      'phone': user.phone,
      'token': user.token,
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>>
  readCurrentUser() async {
    User? user = AuthService.authService.getUser();
    return await fireStore.collection("users").doc(user!.email).get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>>
  readAllUser() async {
    User? user = AuthService.authService.getUser();
    return await fireStore
        .collection("users")
        .where("email", isNotEqualTo: user!.email)
        .get();
  }

  Future<void> addChatInFireStore(ChatModal chat) async {
    String? sender = chat.sender;
    String? receiver = chat.receiver;

    List doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");
    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .add(chat.toMap(chat));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readChatFromFireStore(
      String receiver,) {
    String sender = AuthService.authService.getUser()!.email!;
    List  doc = [sender, receiver];
    doc.sort();

    String docId = doc.join("_");

    return fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .orderBy('time', descending: false)
        .snapshots();
  }

  Future<void> updateChat(String dcId, String message, String receiver) async {
    String sender = AuthService.authService.getUser()!.email!;
    List doc = [sender, receiver];
    doc.sort();

    String docId = doc.join("_");
    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .update({
      'message': message,
      'isEdited': true,
    });
  }

  Future<void> removeChat(String dcId, String receiver) async {
    String sender = AuthService.authService.getUser()!.email!;
    List<String?> doc = [sender, receiver];
    doc.sort();
    String docId = doc.join("_");

    await fireStore
        .collection("chatroom")
        .doc(docId)
        .collection("chat")
        .doc(dcId)
        .delete();
  }


}