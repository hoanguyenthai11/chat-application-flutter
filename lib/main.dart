import 'package:chat_app_flutter/app.dart';
import 'package:chat_app_flutter/screens/select_user_screen.dart';
import 'package:chat_app_flutter/theme.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  final client = StreamChatClient(streamKey);
  runApp(MyApp(
    client: client,
  ));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;
  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return StreamChatCore(client: client, child: child!);
      },
      home: const SelectUserScreen(),
    );
  }
}
