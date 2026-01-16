import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/dialog_widget.dart';

class TopPage extends StatefulWidget implements PreferredSizeWidget {
  const TopPage({super.key});

  @override
  State<TopPage> createState() => _TopPageState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopPageState extends State<TopPage> {
  String _currentDate = "";
  String _currentTime = "";

  void _updateDateAndTime(DateTime now) {
    Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        _currentTime = DateFormat.Hm().format(now);
        _currentDate = DateFormat('yy-MM-dd').format(now);
      });
    });
  }

  @override
  void initState() {
    var currentDate = DateTime.now();
    _currentDate = DateFormat('yy-MM-dd').format(currentDate);
    _currentTime = DateFormat.Hm().format(currentDate);
    _updateDateAndTime(currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.teal,
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          spacing: 500,
          children: [
            CircleAvatar(
              radius: 26,
              backgroundImage: AssetImage('assets/icon.png'),
            ),
            Column(children: [Text(_currentDate), Text(_currentTime)]),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            DialogWidget().dialog(context);
          },
          icon: const Icon(Icons.add_circle_outlined),
        ),
      ],
    );
  }
}
