import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_app_sample/model/message.dart';

class ChatService {
  //get instance of firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //List<Map<String,dynamic>>={
  // 'email':
  //  'id':
  // }
  //get user stream
  Stream<List<Map<String, dynamic>>> getUserStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();

        return user;
      }).toList();
    });
  }

  //send message
  Future<void> sendMessage(String recieverId, message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      recieverID: recieverId,
      message: message,
      timeStamp: timestamp,
    );

    // chat romm ID for the two users()
    List<String> ids = [currentUserID, recieverId];
    // sort the ids(this ensure the chatroomId is the same of 2 people)
    ids.sort();
    String chatroomId = ids.join('_');
    // add new message to database

    await _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .add((newMessage.toMap()));
  }

  // get messages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    //construct a chatroom ID for two users
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatroomId = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatroomId)
        .collection("messages")
        .orderBy("timeStamp", descending: false)
        .snapshots();
  }
}
