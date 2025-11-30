import 'package:flutter/material.dart';

class MainMapScreen extends StatelessWidget {
  const MainMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      body: Center(
        child: Text(
          'MAPA TU',
          style: TextStyle(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
