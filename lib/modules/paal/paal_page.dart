import 'package:flutter/material.dart';

class PaalPage extends StatelessWidget {
  const PaalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paal')),
      body: const Center(child: Text('Paal List')),
    );
  }
}
