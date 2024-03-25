import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/chat_bubble.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/services/auth/auth_services.dart';
import 'package:uridachi/services/chat/chat_service.dart';

class ChatViewPage extends StatelessWidget {
  final String receiverEmail;
  final String receiverID;
  final String receiverUsername;


  ChatViewPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
    required this.receiverUsername,
    
    });

  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(receiverID, _messageController.text);

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receiverUsername),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
      
      ),

      
      body: Column(
        children: [
          //display the bad boy
          Expanded(
            child: _buildMessageList(),
          ),
          
          //user input
          _buildUserInput(),

        ],
      ),
    );
  }


  Widget _buildMessageList () {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(receiverID, senderID), 
      builder: ((context, snapshot) {
        if (snapshot.hasError) {
          return const Text("Error");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading..");
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
          );
        
      })
    );
}



  Widget _buildMessageItem (DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String,dynamic>;


    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          ChatBubble(
            message: data["message"], 
            isCurrentUser: isCurrentUser
          ),

        ],
      ),

    
    
    );

  }

  
  Widget _buildUserInput () {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: "Type a message",
              obscureText: false,
              height: 30,
            ),
            
          ),
      
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle, 
            ),
            margin: EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage, 
              icon: const Icon(Icons.arrow_upward, color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }


}