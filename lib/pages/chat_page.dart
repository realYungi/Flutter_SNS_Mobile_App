import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/drawer.dart';
import 'package:uridachi/components/user_tile.dart';
import 'package:uridachi/pages/chat_view_page.dart';
import 'package:uridachi/pages/home_page.dart';
import 'package:uridachi/pages/profile_page.dart';
import 'package:uridachi/services/auth/auth_services.dart';
import 'package:uridachi/services/chat/chat_service.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Page"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
        stream: _chatService.getUsersStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading..");
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>((userData) => _buildUserListItem(userData, context))
                .toList(),
          );
        });
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    
    
    if (userData["email"] != _authService.getCurrentUser()!.email) {
      return UserTile(
      text: userData['email'],
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatViewPage(
                receiverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ));
      },
    );
    } else {
      return Container(

      );
    }
  }
}
