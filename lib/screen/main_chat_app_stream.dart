import 'package:fluchat/constants/environment.dart';
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

  final api_key = Environment.theStreamApiKey;
  @override
  void initState() {
    print('api_key:: $api_key');
    _client = StreamChatClient(
      api_key,
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
