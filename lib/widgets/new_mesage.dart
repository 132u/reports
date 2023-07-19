import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});
  @override
  State<NewMessage> createState() {
    return NewMessageState();
  }
}

class NewMessageState extends State<NewMessage> {
  var _messagesController = TextEditingController();
  @override
  void dispose() {
    _messagesController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messagesController.text;

    if(enteredMessage.trim().isEmpty){
      return;
    }
    
    FocusScope.of(context).unfocus();
    _messagesController.clear();

    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat').add({
      'text':enteredMessage,
      'createdAt':Timestamp.now(),
      'userId':user.uid,
      'userName':userData.data()!['userName'],
      'userImage':userData.data()!['image_url'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messagesController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: _submitMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
