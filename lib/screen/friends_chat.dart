import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FriendsChat extends StatefulWidget {
  // const FriendsChat({super.key,});

  const FriendsChat({
    Key? key,
    required this.client,
  }) : super(key: key);
  final StreamChatClient client;

  @override
  State<FriendsChat> createState() => _FriendsChatState();
}

class _FriendsChatState extends State<FriendsChat> {
  late final _controller = StreamChannelListController(
    client: widget.client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    channelStateSort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chat'),
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refresh,
        child: StreamChannelListView(
          controller: _controller,
          onChannelTap: (channel) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StreamChannel(
                channel: channel,
                child: const ChannelName(),
              ),
            ),
          ),
          itemBuilder: (context, channels, index, defaultTile) {
            return ListTile(
              tileColor: Colors.amberAccent,
              title: Center(
                child: StreamChannelName(channel: channels[index]),
              ),
            );
          },
        ),
      ),
    );
  }
}
