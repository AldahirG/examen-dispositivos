import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: const Center(
        child: Text(
          'Bienvenido a la aplicación',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
