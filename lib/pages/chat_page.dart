import 'package:flutter/material.dart';
import 'package:uridachi/components/user_tile.dart';
import 'package:uridachi/mainpage.dart';
import 'package:uridachi/pages/chat_view_page.dart';
import 'package:uridachi/pages/home_page.dart';
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
        
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
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

  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
  // Check if the current user is not the one being rendered
  if (userData["email"] != _authService.getCurrentUser()!.email) {
    // Use the username instead of email for display
    return UserTile(
      text: userData['username'], // Use 'username' here
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatViewPage(
                receiverEmail: userData["email"], // Keep using email for internal identification
                receiverUsername: userData["username"], // Optionally pass username for display in ChatViewPage
                receiverID: userData["uid"],
              ),
            ));
      },
    );
  } else {
    return Container(); // Empty container for the current user
  }
}

}
