import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

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
      appBar: AppBar(title: Center(child: Text('Request'))),
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
                    var response = await http.get(new Uri.http(url, '/login'));
                    print(response.statusCode);
                    if (response.body == 'foo') {
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
