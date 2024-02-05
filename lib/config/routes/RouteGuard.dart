import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:splitwise/Components/NavDrawer.dart';
import 'package:splitwise/Provider/LoginProvider.dart';
import 'package:splitwise/Screen/Friends.dart';
import 'package:splitwise/Screen/Login.dart';

class RouteGuard {
  static Route<dynamic>? onGenerateRoute(BuildContext context, RouteSettings settings) {
    final isAuthenticated = Provider.of<LoginProvider>(context, listen: false).isUser;

    switch (settings.name) {
      case '/friends':
        if (isAuthenticated) {
          return MaterialPageRoute(builder: (_) => Friends());
        }
        // Redirect to login if not authenticated
        return MaterialPageRoute(builder: (_) => LoginPage());
      // Add more cases for other protected routes

      default:
        // Handle unknown routes or fallback to a default page
        return MaterialPageRoute(builder: (_) => NotFoundPage());
    }
  }
}

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Page Not Found'),
      ),
      body: Center(
        child: Text('Oops! The page you are looking for does not exist.'),
      ),
    );
  }
}
