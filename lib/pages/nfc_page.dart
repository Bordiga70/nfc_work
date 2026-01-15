import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Options.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  String _currentDate = "";
  String _currentTime = "";

  void currentTime(DateTime now) {
    Timer.periodic(Duration(minutes: 1), (timer) {
      var currentDate = DateTime.now();
      setState(() {
        _currentTime = DateFormat.Hm().format(currentDate);
      });
    });
  }

  void currentDay(DateTime now) {
    Timer.periodic(Duration(hours: 1), (timer) {
      setState(() {
        _currentDate = DateFormat('yy-MM-dd').format(now);
        ;
      });
    });
  }

  @override
  void initState() {
    var currentDate = DateTime.now();
    _currentDate = DateFormat('yy-MM-dd').format(currentDate);
    _currentTime = DateFormat.Hm().format(currentDate);
    currentTime(currentDate);
    currentDay(currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage('assets/icon.png'),
              ),
              Column(children: [Text(_currentDate), Text(_currentTime)]),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return Options();
                  },
                ),
              );
            },
            icon: const Icon(Icons.add_circle_outlined),
          ),
        ],
      ),
      body: Center(),
    );
  }
}
