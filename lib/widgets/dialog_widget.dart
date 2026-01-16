import 'package:flutter/material.dart';

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
              print(_controller.text);
              Navigator.pop(context, 'Ok');
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
