import 'package:fluchat/data/data_utils.dart';
import 'package:fluchat/screen/friends_chat.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat/stream_chat.dart';

class HomeChat extends StatefulWidget {
  const HomeChat({super.key});

  @override
  State<HomeChat> createState() => _HomeChatState();
}

class _HomeChatState extends State<HomeChat> {
  final _usernameController = TextEditingController();
  String _usernameError = '';
  bool _loading = false;

  Future<void> _onGoPressed() async {
    final username = _usernameController.text;
    if (username.isNotEmpty) {
      setState(() {
        _usernameError = '';
        _loading = true;
      });
      final client = StreamChat.of(context).client;
      final logToken = client.devToken(username);

      await client.connectUser(
        User(
          id: username,
          extraData: {
            'image': DataUtils.getUserImage(username),
            'name': username,
          },
        ),
        client.devToken(username).rawValue,
      );
      setState(() {
        _loading = false;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => FriendsChat(
            client: client,
          ),
        ),
      );
    } else {
      setState(() {
        _usernameError = 'Username is not valid';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Streaming Chat'),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Card(
                elevation: 11,
                margin: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Welcome to the Streaming Chat App!'),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          errorText: _usernameError,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _onGoPressed,
                        child: Text('Go'),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
