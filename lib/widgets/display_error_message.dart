import 'package:flutter/material.dart';

class DisplayErrorMessage extends StatelessWidget {
  final Object? error;
  const DisplayErrorMessage({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Oh no, some thing went wrong. $error'),
    );
  }
}
