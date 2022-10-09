import 'package:chat_app_flutter/app.dart';
import 'package:chat_app_flutter/screens/select_user_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import '../widgets/avatar.dart';

class ProfileScreen extends StatelessWidget {
  static Route get route =>
      MaterialPageRoute(builder: ((context) => const ProfileScreen()));
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Hero(
              tag: 'hero-profile-picture',
              child: Avatar.large(
                url: user?.image,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(user?.name ?? 'No name'),
            ),
            const Divider(),
            const _SigOutButton(),
          ],
        ),
      ),
    );
  }
}

class _SigOutButton extends StatefulWidget {
  const _SigOutButton();

  @override
  State<_SigOutButton> createState() => __SigOutButtonState();
}

class __SigOutButtonState extends State<_SigOutButton> {
  bool _isLoading = false;

  void _sigOut() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await StreamChatCore.of(context).client.disconnectUser();

      Navigator.of(context).push(SelectUserScreen.route);
    } on Exception catch (e, st) {
      logger.e('Could not sign out', e, st);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CupertinoActivityIndicator()
        : TextButton(
            onPressed: _sigOut,
            child: const Text('Sign out'),
          );
  }
}
