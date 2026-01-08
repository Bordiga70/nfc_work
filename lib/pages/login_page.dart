import 'package:flutter/material.dart';
import 'package:untitled/pages/nfc_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userController = TextEditingController();
  TextEditingController pswController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Login'))),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.center,
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'nome utente',
                ),
              ),
              SizedBox(height: 50),
              TextField(
                textAlign: TextAlign.center,
                controller: pswController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 50,
                child: TextButton(
                  onPressed: () {
                    if (userController.text.isNotEmpty &&
                        pswController.text.isNotEmpty) {
                      print('Username: ${userController.text}');
                      print('Password: ${pswController.text}');
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return NfcPage();
                          },
                        ),
                      );
                    }
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
