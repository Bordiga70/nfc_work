import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/pages/nfc_page.dart';
import 'package:untitled/widgets/dialog_widget.dart';

import '../data/user_data.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _pswController = TextEditingController();
  static const String _url = '127.0.0.1:3000';
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  Future<http.Response?> _sendLogin() async {
    try {
      final response = await http
          .post(
            Uri.http(_url, '/login'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
              'username': _userController.text,
              'password': _pswController.text,
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

  Future<void> _saveLogin(String username, String password) async {
    if (_isChecked) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('username', username);
      prefs.setString('password', password);
    }
  }

  Future<void> _loadSavedLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _userController.text = prefs.getString('username')!;
    _pswController.text = prefs.getString('password')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Login')),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                textAlign: TextAlign.center,
                controller: _userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'nome utente',
                ),
              ),
              SizedBox(height: 50),
              TextField(
                textAlign: TextAlign.center,
                controller: _pswController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        var response = await _sendLogin();

                        String username = _userController.text;
                        String password = _pswController.text;

                        if (response != null) {
                          if (username.isNotEmpty &&
                              password.isNotEmpty &&
                              response.statusCode == 201) {
                            _saveLogin(username, password);
                            final userMap =
                                jsonDecode(response.body)
                                    as Map<String, dynamic>;
                            final userData = UserData.fromJson(userMap);
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return NfcPage(data: userData);
                                  },
                                ),
                              );
                            }
                          } else if (context.mounted) {
                            DialogWidget.dialog(
                              context,
                              'Errore',
                              'Credenziali errate',
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
                      child: Text('Login'),
                    ),
                  ),
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = !_isChecked;
                      });
                    },
                  ),
                  const Text('Salvare le credenziali'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
