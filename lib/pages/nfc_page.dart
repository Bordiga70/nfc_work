import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/data/user_data.dart';

import '../data/constants.dart';
import '../widgets/dialog_widget.dart';

class NfcPage extends StatefulWidget {
  final UserData data;

  const NfcPage({super.key, required this.data});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  static const String _url = "${UrlCostant.url}:${UrlCostant.port}";

  // Future<void> _readNFCTag() async {
  //   try {
  //     NFCTag tag = await FlutterNfcKit.poll();
  //     print('NFC Tag Found: ${tag.id}');
  //   } catch (e) {
  //     print('Error reading NFC tag: $e');
  //   }
  // }

  Future<http.Response?> _sendData() async {
    try {
      final response = await http
          .post(
            Uri.http(_url, '/verify'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({
              'id': widget.data.id,
              'codice_fiscale': widget.data.codiceFiscale,
              'nome': widget.data.nome,
              'cognome': widget.data.cognome,
            }),
          )
          .timeout(const Duration(seconds: 5));

      return response;
    } on SocketException {
      debugPrint('No Internet or server unreachable');
      return null;
    } on TimeoutException {
      debugPrint('Connection timeout');
      return null;
    } catch (e) {
      debugPrint('Unexpected error: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text('${widget.data.nome} ${widget.data.cognome}'),
              Text(widget.data.codiceFiscale),
            ],
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    var response = await _sendData();
                    //await _readNFCTag();
                    if (response != null) {
                      if (response.statusCode == 201) {
                        if (context.mounted) {
                          DialogWidget.dialog(
                            context,
                            'Attenzione',
                            'Verifica effettuata correttamente',
                          );
                        }
                      } else if (context.mounted) {
                        DialogWidget.dialog(
                          context,
                          'Errore',
                          'Impossibile effettuare la verifica',
                        );
                      }
                    } else if (context.mounted) {
                      DialogWidget.dialog(
                        context,
                        'Errore',
                        'Impossibile connettersi al server',
                      );
                    }
                  },
                  child: Text('Connect'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
