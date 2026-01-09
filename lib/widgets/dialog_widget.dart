import 'package:flutter/material.dart';

class DialogWidget {
  Future<String?> dialog(context) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Errore'),
        content: const Text('Credenziali Errate'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
