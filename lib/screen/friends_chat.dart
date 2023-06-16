import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FriendsChat extends StatefulWidget {
  const FriendsChat({super.key});

  @override
  State<FriendsChat> createState() => _FriendsChatState();
}

class _FriendsChatState extends State<FriendsChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chat'),
      ),
      body: Placeholder(),
    );
  }
}
