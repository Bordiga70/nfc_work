import 'package:flutter/material.dart';
import 'package:untitled/data/ip_handler.dart';

class DialogWidget {
  final TextEditingController _controller = TextEditingController();

  Future<String?> dialog(dynamic context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Change IP'),
        content: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: 'address:port'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              IpHandler().format(_controller.text);
              Navigator.pop(context, 'Ok');
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
