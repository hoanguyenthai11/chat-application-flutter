import 'dart:async';

import 'package:chat_app_flutter/app.dart';
import 'package:chat_app_flutter/widgets/display_error_message.dart';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:chat_app_flutter/widgets/glowing_action_button.dart';
import 'package:chat_app_flutter/widgets/icon_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../helpers.dart';
import '../theme.dart';

class ChatScreen extends StatefulWidget {
  static Route routeWithChannel(Channel channel) => MaterialPageRoute(
        builder: (context) => StreamChannel(
          channel: channel,
          child: const ChatScreen(),
        ),
      );
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late StreamSubscription<int> unreadCountSubcription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    unreadCountSubcription = StreamChannel.of(context)
        .channel
        .state!
        .unreadCountStream
        .listen(_unreadCountHandler);
  }

  Future<void> _unreadCountHandler(int count) async {
    if (count > 0) {
      await StreamChannel.of(context).channel.markRead();
    }
  }

  @override
  void dispose() {
    unreadCountSubcription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 54,
        leading: Align(
          alignment: Alignment.centerRight,
          child: IconBackground(
              icon: CupertinoIcons.back,
              onTap: () {
                Navigator.of(context).pop();
              }),
        ),
        title: _AppBarTitle(),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: IconBorder(
                  icon: CupertinoIcons.video_camera_solid, onTap: () {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Center(
              child: IconBorder(icon: CupertinoIcons.phone_solid, onTap: () {}),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MessageListCore(
              loadingBuilder: (context) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              },
              emptyBuilder: ((context) => const SizedBox.shrink()),
              messageListBuilder: (context, messages) =>
                  _MessageList(messages: messages),
              errorBuilder: ((context, error) => DisplayErrorMessage(
                    error: error,
                  )),
            ),
          ),
          const _ActionBar(),
        ],
      ),
    );
  }
}

class _MessageList extends StatelessWidget {
  final List<Message> messages;
  const _MessageList({required this.messages});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: messages.length + 1,
      reverse: true,
      separatorBuilder: (context, index) {
        if (index == messages.length - 1) {
          return _DateLabel(
            dateTime: messages[index].createdAt,
          );
        }
        if (messages.length == 1) {
          return const SizedBox.shrink();
        } else if (index >= messages.length) {
          final message = messages[index];
          final nextMessage = messages[index + 1];
          if (!Jiffy(message.createdAt.toLocal())
              .isSame(nextMessage.createdAt.toLocal(), Units.DAY)) {
            return _DateLabel(
              dateTime: messages[index].createdAt,
            );
          } else {
            return const SizedBox.shrink();
          }
        } else {
          return const SizedBox.shrink();
        }
      },
      itemBuilder: (context, index) {
        if (index < messages.length) {
          final message = messages[index];
          if (message.user?.id == context.currentUser?.id) {
            return _MessageOwnTile(message: message);
          } else {
            return _MessageTile(message: message);
          }
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class _ActionBar extends StatefulWidget {
  const _ActionBar();

  @override
  State<_ActionBar> createState() => _ActionBarState();
}

class _ActionBarState extends State<_ActionBar> {
  final TextEditingController textEditingController = TextEditingController();

  void _sendMessage() async {
    if (textEditingController.text.isNotEmpty) {
      StreamChannel.of(context)
          .channel
          .sendMessage(Message(text: textEditingController.text));
      textEditingController.clear();
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      top: false,
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  width: 2,
                  color: Theme.of(context).dividerColor,
                ),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Icon(
                CupertinoIcons.camera_fill,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: textEditingController,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                  hintText: 'Type something',
                  border: InputBorder.none,
                ),
                onChanged: ((value) {
                  StreamChannel.of(context).channel.keyStroke();
                }),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 24,
            ),
            child: GlowingActionButton(
                color: AppColors.accent,
                icon: Icons.send_rounded,
                onPressed: _sendMessage),
          ),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final Message message;

  static const _borderRadius = 26.0;
  const _MessageTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(_borderRadius),
                  topLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
                child: Text(
                  message.text ?? 'Empty message',
                  style: const TextStyle(
                    color: AppColors.textLigth,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: Text(
                Jiffy(message.createdAt.toLocal()).jm,
                style: const TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageOwnTile extends StatelessWidget {
  final Message message;

  static const _borderRadius = 26.0;
  const _MessageOwnTile({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_borderRadius),
                  bottomLeft: Radius.circular(_borderRadius),
                  bottomRight: Radius.circular(_borderRadius),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 20,
                ),
                child: Text(
                  message.text ?? '',
                  style: const TextStyle(
                    color: AppColors.textLigth,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8,
              ),
              child: Text(
                Jiffy(message.createdAt.toLocal()).jm,
                style: const TextStyle(
                  color: AppColors.textFaded,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateLabel extends StatefulWidget {
  final DateTime dateTime;
  const _DateLabel({required this.dateTime});

  @override
  State<_DateLabel> createState() => _DateLabelState();
}

class _DateLabelState extends State<_DateLabel> {
  late String dayInfo;

  @override
  void initState() {
    final createdAt = Jiffy(widget.dateTime);
    final now = DateTime.now();

    if (Jiffy(createdAt).isSame(now, Units.DAY)) {
      dayInfo = 'TODAY';
    } else if (Jiffy(createdAt)
        .isSame(now.subtract(const Duration(days: 1)), Units.DAY)) {
      dayInfo = 'YESTERDAY';
    } else if (Jiffy(createdAt)
        .isAfter(now.subtract(const Duration(days: 7)), Units.DAY)) {
      dayInfo = createdAt.EEEE;
    } else if (Jiffy(createdAt)
        .isAfter(Jiffy(now).subtract(years: 1), Units.DAY)) {
      dayInfo = createdAt.MMMd;
    } else {
      dayInfo = createdAt.MMMd;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 32,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 12,
            ),
            child: Text(
              dayInfo,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textFaded),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Row(
      children: [
        Avatar.small(
          url: Helpers.getChannelImage(channel, context.currentUser!),
        ),
        const SizedBox(
          width: 16,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Helpers.getChannelName(channel, context.currentUser!),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 2,
            ),
            BetterStreamBuilder<List<Member>>(
                stream: channel.state!.membersStream,
                builder: ((context, data) =>
                    ConnectionStatusBuilder(statusBuilder: ((context, status) {
                      switch (status) {
                        case ConnectionStatus.connected:
                          return _buildConnectedTitleState(context, data);
                        case ConnectionStatus.connecting:
                          return const Text(
                            'Connecting',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          );
                        case ConnectionStatus.disconnected:
                          return const Text(
                            'Offline',
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          );
                      }
                    }))))
          ],
        ),
      ],
    );
  }

  Widget _buildConnectedTitleState(
      BuildContext context, List<Member>? members) {
    Widget? alternativeWidget;
    final channel = StreamChannel.of(context).channel;
    final memberCount = channel.memberCount;

    if (memberCount != null && memberCount > 2) {
      var text = 'Member: $memberCount';

      final watcherCount = channel.state?.watcherCount ?? 0;

      if (watcherCount > 0) {
        text = 'watchers $watcherCount';
      }
      alternativeWidget = Text(text);
    } else {
      final userId = StreamChatCore.of(context).currentUser?.id;
      final otherMember = members?.firstWhereOrNull(
        (element) => element.userId != userId,
      );
      if (otherMember != null) {
        if (otherMember.user?.online == true) {
          alternativeWidget = const Text(
            'Online',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          );
        } else {
          alternativeWidget = Text(
            'Last online: '
            '${Jiffy(otherMember.user?.lastActive).fromNow()}',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          );
        }
      }
    }
    return TypingIndicator(alternativeWidget: alternativeWidget);
  }
}

class TypingIndicator extends StatelessWidget {
  final Widget? alternativeWidget;
  const TypingIndicator({super.key, required this.alternativeWidget});

  @override
  Widget build(BuildContext context) {
    final channelState = StreamChannel.of(context).channel.state!;
    final altWidget = alternativeWidget ?? const Offstage();
    return BetterStreamBuilder<Iterable<User>>(
      initialData: channelState.typingEvents.keys,
      stream: channelState.typingEventsStream
          .map((event) => event.entries.map((e) => e.key)),
      builder: (context, data) {
        return Align(
          alignment: Alignment.centerLeft,
          child: AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 300,
            ),
            child: data.isNotEmpty == true
                ? const Align(
                    alignment: Alignment.centerLeft,
                    key: ValueKey('typing-text'),
                    child: Text(
                      'Typing message',
                      maxLines: 1,
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    key: const ValueKey('altwidget'),
                    child: altWidget,
                  ),
          ),
        );
      },
    );
  }
}

class ConnectionStatusBuilder extends StatelessWidget {
  final Stream<ConnectionStatus>? connectionStatusStream;

  final WidgetBuilder? loadingBuilder;

  final Widget Function(BuildContext context, Object? error)? errorBuilder;

  final Widget Function(BuildContext context, ConnectionStatus status)
      statusBuilder;

  const ConnectionStatusBuilder(
      {required this.statusBuilder,
      this.connectionStatusStream,
      this.errorBuilder,
      this.loadingBuilder});

  @override
  Widget build(BuildContext context) {
    final stream = connectionStatusStream ??
        StreamChatCore.of(context).client.wsConnectionStatusStream;
    final client = StreamChatCore.of(context).client;
    return BetterStreamBuilder<ConnectionStatus>(
        initialData: client.wsConnectionStatus,
        stream: stream,
        errorBuilder: (context, error) {
          if (errorBuilder != null) {
            return errorBuilder!(context, error);
          }
          return const Offstage();
        },
        builder: statusBuilder);
  }
}
