import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  String _currentDate = "";
  String _currentTime = "";

  void currentTime(now) {
    Timer.periodic(Duration(minutes: 1), (timer) {
      var currentDate = DateTime.now();
      setState(() {
        _currentTime = DateFormat.Hm().format(currentDate);
      });
    });
  }

  void currentDay(now) {
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(children: [Text(_currentTime), Text(_currentDate)]),
            ],
          ),
        ),
      ),
      body: Center(),
    );
  }
}
