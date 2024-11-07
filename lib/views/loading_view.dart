import 'package:flutter/material.dart';
import 'dart:async';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  @override
  void initState() {
    super.initState();
    _navigateToProducts();
  }

  // Función para redirigir a la vista de productos después de un tiempo
  void _navigateToProducts() {
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/products'); // Cambia '/products' por la ruta de tu vista de productos
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(), // Indicador de carga
      ),
    );
  }
}
