import 'package:chat_app_flutter/models/demo_users.dart';
import 'package:chat_app_flutter/screens/home_screen.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../app.dart';

class SelectUserScreen extends StatefulWidget {
  static Route get route =>
      MaterialPageRoute(builder: (context) => const SelectUserScreen());
  const SelectUserScreen({super.key});

  @override
  State<SelectUserScreen> createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {
  bool _isLoading = false;

  Future<void> onUserSelected(DemoUser user) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final client = StreamChatCore.of(context).client;

      await client.connectUser(
          User(
            id: user.id,
            extraData: {
              'name': user.name,
              'image': user.image,
            },
          ),
          client.devToken(user.id).rawValue);

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()));
    } on Exception catch (e, st) {
      logger.e('Could not connect user', e, st);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: (_isLoading)
            ? const CupertinoActivityIndicator()
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text(
                        'Select a user',
                        style: TextStyle(
                          fontSize: 24,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: users.length,
                        itemBuilder: ((context, index) {
                          return SelectUserButton(
                            user: users[index],
                            onPressed: onUserSelected,
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class SelectUserButton extends StatelessWidget {
  final DemoUser user;
  final Function(DemoUser user) onPressed;
  const SelectUserButton(
      {super.key, required this.user, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: InkWell(
        onTap: () => onPressed(user),
        child: Row(
          children: [
            Avatar.large(
              url: user.image,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                user.name,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
