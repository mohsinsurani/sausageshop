import 'package:flutter/material.dart';
import 'package:sausage_shop/screens/cart/cart_list_screen.dart';

import 'utils/shared_preferences_util.dart';

Future<void> main() async {
  // required for testing
  WidgetsFlutterBinding.ensureInitialized();
  // required so that its instance is initialized on time only
  await SharedPreferencesService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cart List",
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          appBarTheme: const AppBarTheme(color: Colors.blue)),
      home: const CartListScreen(),
    );
  }
}
