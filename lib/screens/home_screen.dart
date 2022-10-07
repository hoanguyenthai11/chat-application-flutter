import 'package:chat_app_flutter/helpers.dart';
import 'package:chat_app_flutter/pages/calls_page.dart';
import 'package:chat_app_flutter/pages/contacts_page.dart';
import 'package:chat_app_flutter/pages/messages_page.dart';
import 'package:chat_app_flutter/pages/notification_page.dart';
import 'package:chat_app_flutter/theme.dart';
import 'package:chat_app_flutter/widgets/avatar.dart';
import 'package:chat_app_flutter/widgets/icon_buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> pageIndex = ValueNotifier(0); //Don't rebuild
  final ValueNotifier<String> title = ValueNotifier('Messages');
  final pages = [
    const MessagesPage(),
    const NotificationPage(),
    const CallsPage(),
    const ContactsPage(),
  ];
  final pageTitles = [
    'Messages',
    'Notifications',
    'Calls',
    'Contacts',
  ];

  void _onNavigationItemSelected(i) {
    title.value = pageTitles[i];
    pageIndex.value = i;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: title,
          builder: (context, value, _) {
            return Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            );
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 54,
        leading: Align(
            alignment: Alignment.centerRight,
            child: IconBackground(icon: Icons.search, onTap: () {})),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Avatar.small(
              url: Helpers.randomPictureUrl(),
            ),
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (context, value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: _BottomNavigationBar(
        onItemSelected: _onNavigationItemSelected,
      ),
    );
  }
}

class _BottomNavigationBar extends StatefulWidget {
  final Function(int i) onItemSelected;

  const _BottomNavigationBar({required this.onItemSelected});

  @override
  State<_BottomNavigationBar> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<_BottomNavigationBar> {
  int selectedIndex = 0;
  void handleItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
    widget.onItemSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: true,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavigationBarItem(
              index: 0,
              icon: CupertinoIcons.bubble_left_bubble_right_fill,
              label: 'Messages',
              onTap: handleItemSelected,
              isSelected: (selectedIndex == 0),
            ),
            _NavigationBarItem(
                index: 1,
                icon: CupertinoIcons.bell_solid,
                label: 'Notifications',
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 1)),
            _NavigationBarItem(
                index: 2,
                icon: CupertinoIcons.phone_fill,
                label: 'Calls',
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 2)),
            _NavigationBarItem(
                index: 3,
                icon: CupertinoIcons.person_2_fill,
                label: 'Contacts',
                onTap: handleItemSelected,
                isSelected: (selectedIndex == 3)),
          ],
        ),
      ),
    );
  }
}

class _NavigationBarItem extends StatelessWidget {
  final int index;
  final String label;
  final IconData icon;
  final Function(int i) onTap;
  final bool isSelected;

  const _NavigationBarItem(
      {required this.index,
      required this.icon,
      required this.label,
      this.isSelected = false,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onTap(index);
      },
      child: SizedBox(
        height: 70,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.secondary : null,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              label,
              style: isSelected
                  ? const TextStyle(
                      fontSize: 11,
                      color: AppColors.secondary,
                    )
                  : const TextStyle(
                      fontSize: 11,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
