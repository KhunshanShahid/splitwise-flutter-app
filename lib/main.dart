import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splitwise/AppConstants/constants.dart';
import 'package:splitwise/CustomWidget/Policy.dart';
import 'package:splitwise/Provider/LoginProvider.dart';
import 'package:splitwise/Screen/Friends.dart';
import 'package:splitwise/Screen/HomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splitwise/Screen/Login.dart';
import 'package:splitwise/Screen/NewExpense.dart';
import 'package:splitwise/Screen/SignUp.dart';
import 'package:splitwise/Screen/SplitExpense.dart';
import 'package:splitwise/Themes/DarkTheme.dart';
import 'package:splitwise/Themes/LightTheme.dart';
import 'package:splitwise/config/routes/RouteGuard.dart';
import 'package:splitwise/config/routes/Routes.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('login') ?? false;

    if (isLoggedIn) {
      LoginProvider().loginUser();
      setState(() {});
    } else {
      LoginProvider().logoutUser();
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LoginProvider()),
      ],
      child: MaterialApp(
        title: 'BillBuddy',
        theme: darkTheme,
        darkTheme: lightTheme,
        initialRoute: AppRoutes.home,
        onGenerateRoute: (settings) =>
            RouteGuard.onGenerateRoute(context, settings),
        routes: {
          AppRoutes.home: (context) => const HomeScreen(),
          AppRoutes.friends: (context) => const Friends(),
          AppRoutes.signup: (context) => SignUpPage(),
          AppRoutes.login: (context) => LoginPage(),
          AppRoutes.terms: (context) => Policy(
              heading: "Terms & Condition",
              termstitle: AppConstant().termsTitle),
          AppRoutes.privacy: (context) => Policy(
              heading: "Privacy", termstitle: AppConstant().privacyTitle),
          AppRoutes.equalExpense: (context) => const SplitExpense(),
          AppRoutes.newExpense: (context) => NewExpense(),
        },
      ),
    );
  }
}
