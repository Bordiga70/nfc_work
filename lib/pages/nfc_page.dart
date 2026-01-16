import 'package:flutter/material.dart';
import 'package:untitled/pages/top_page.dart';

class NfcPage extends StatefulWidget {
  const NfcPage({super.key});

  @override
  State<NfcPage> createState() => _NfcPageState();
}

class _NfcPageState extends State<NfcPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: TopPage(), body: Center());
  }
}
