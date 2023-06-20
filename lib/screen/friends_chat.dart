import 'package:fluchat/data/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FriendsChat extends StatefulWidget {
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

  Future<List<String>> _listActiveUsers() async {
    final response = await widget.client.queryUsers(
      filter: Filter.and(
        [
          Filter.notEqual('id', StreamChat.of(context).currentUser!.id),
        ],
      ),
    );
    final List<String> userNames =
        response.users.map((user) => user.name).toList();
    return userNames;
  }

  Future<void> _onCreateChannel() async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          final channelController = TextEditingController();

          return AlertDialog(
            title: Text('Create Channel'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Welcome to the Streaming Chat App!'),
                TextField(
                  controller: channelController,
                  decoration: InputDecoration(
                    hintText: 'Channel Name',
                  ),
                ),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.of(context).pop(channelController.text),
                  child: Text('Save'),
                )
              ],
            ),
          );
        });

    if (result != null) {
      final client = StreamChat.of(context).client;
      final channel = client.channel(
        'messaging',
        id: result,
        extraData: {
          'image': DataUtils.getChannelImage(),
        },
      );

      await channel.create();
      await channel.watch();

      final currentUser = StreamChat.of(context).currentUser;

      await channel.queryMembers(); // Consultar los miembros del canal

      // Escuchar eventos de actualización del canal
      channel.on();

      // Agregar el usuario actual al canal
      await channel.addMembers([currentUser!.id]);

      setState(() {
        _controller.refresh(); // Actualizar la lista de canales
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: _onCreateChannel, label: Text('Create Channel')),
      appBar: AppBar(
        title: const Text('Public Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () {
              _listActiveUsers().then((userNames) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Active Users'),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: userNames.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              title: Text(userNames[index]),
                            );
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              });
            },
          ),
        ],
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
        ),
      ),
    );
  }
}
