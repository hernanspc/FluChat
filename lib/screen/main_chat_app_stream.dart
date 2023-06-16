import 'package:fluchat/screen/home_chat.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class MainChatAppStream extends StatefulWidget {
  const MainChatAppStream({super.key});

  @override
  State<MainChatAppStream> createState() => _MainChatAppStreamState();
}

class _MainChatAppStreamState extends State<MainChatAppStream> {
  late StreamChatClient _client;

  @override
  void initState() {
    _client = StreamChatClient(
      '6tcm7ns4yn35',
      logLevel: Level.INFO,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      builder: (context, child) {
        return StreamChat(
          client: _client,
          child: child,
        );
      },
      debugShowCheckedModeBanner: false,
      home: const HomeChat(),
    );
  }
}
