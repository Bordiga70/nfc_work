import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled/data/user_data.dart';

class NfcPage extends StatefulWidget {
  final UserData data;

  const NfcPage({super.key, required this.data});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  bool success = false;
  static const String url = '127.0.0.1:3000';

  // Future<void> readNFCTag() async {
  //   try {
  //     NFCTag tag = await FlutterNfcKit.poll();
  //     print('NFC Tag Found: ${tag.id}');
  //   } catch (e) {
  //     print('Error reading NFC tag: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              Text('Connesso come: ${widget.data.nome} ${widget.data.cognome}'),
              Text('${widget.data.codice_fiscale}'),
            ],
          ),
        ),
      ),
      body: Center(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(success ? 'successo' : 'errore'),
              SizedBox(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    var response = await http.get(new Uri.http(url, '/verify'));
                    print(response.statusCode);
                    if (response.statusCode == 201) {
                      setState(() {
                        success = !success;
                      });
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
