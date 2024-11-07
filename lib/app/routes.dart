import 'package:flutter/material.dart';
import '../views/home_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/register_view.dart';
import '../views/loading_view.dart';
import '../views/products_view.dart';
import '../views/profile_view.dart'; // Asegúrate de importar profile_view

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String loading = '/loading';
  static const String products = '/products';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case login:
        return MaterialPageRoute(builder: (_) => LoginView());
      case register:
        return MaterialPageRoute(builder: (_) => RegisterView());
      case loading:
        return MaterialPageRoute(builder: (_) => LoadingView());
      case products:
        return MaterialPageRoute(builder: (_) => ProductsView());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfileView()); // Ruta de perfil
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
