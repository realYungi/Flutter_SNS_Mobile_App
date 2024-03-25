import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uridachi/models/message.dart';

class ChatService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Stream<List<Map<String, dynamic>>> getUsersStream() {
  return FirebaseFirestore.instance
      .collection('Users')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());
}


  Future<void> sendMessage(String receiverID, message) async {

    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //create message
    Message newMessage = Message(
      senderId: currentUserID, 
      senderEmail: currentUserEmail, 
      receiverID: receiverID, 
      message: message, 
      timestamp: timestamp
    );
    
    //construct chatroom ID for the two users
    List<String> ids = [currentUserID, receiverID];
    ids.sort();
    String chatRoomID = ids.join('_');
    //add message to db
    
    await _firestore
    .collection("chat_rooms")
    .doc(chatRoomID)
    .collection("messages")
    .add(newMessage.toMap());


    


  }


    Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
      List<String> ids = [userID, otherUserID];
      ids.sort();
      String chatRoomID = ids.join('_');

      return _firestore
      .collection("chat_rooms")
      .doc(chatRoomID)
      .collection("messages")
      .orderBy("timestamp", descending: false)
      .snapshots();
    }
}