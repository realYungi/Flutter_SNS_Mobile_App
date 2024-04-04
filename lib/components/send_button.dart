// Simplified SendButton that only requires postCreatorEmail
import 'package:flutter/material.dart';
import 'package:uridachi/pages/chat_view_page.dart';
import 'package:uridachi/services/auth/auth_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SendButton extends StatelessWidget {
  final String postCreatorEmail;

  const SendButton({
    Key? key,
    required this.postCreatorEmail,
  }) : super(key: key);

Future<Map<String, dynamic>?> fetchUserDetailsByEmail(String userEmail) async {
  var usersCollection = FirebaseFirestore.instance.collection('Users');
  var querySnapshot = await usersCollection.where('email', isEqualTo: userEmail).limit(1).get();
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.first.data() as Map<String, dynamic>;
  }
  return null; // User not found or error
}

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return IconButton(
      icon: Icon(Icons.send_rounded),
      onPressed: () async {
        final currentUserEmail = _authService.getCurrentUser()?.email;
        if (currentUserEmail == null || currentUserEmail == postCreatorEmail) {
          // User is trying to send a message to themselves
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Oops!"),
              content: Text("You cannot chat with yourself."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("OK"),
                ),
              ],
            ),
          );
          return;
        }

        // Fetching receiver's details from Firestore based on email
        var userDetails = await fetchUserDetailsByEmail(postCreatorEmail);
        if (userDetails != null) {
          String receiverUsername = userDetails['username'] ?? 'Unknown';
          String receiverID = userDetails['uid'] ?? 'Unknown';

          // Navigate to ChatViewPage with these details
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatViewPage(
                receiverEmail: postCreatorEmail,
                receiverUsername: receiverUsername,
                receiverID: receiverID,
              ),
            ),
          );
        } else {
          // Handle user not found or error fetching details
          print("Error fetching user details for chat.");
        }
      },
    );
  }
}
