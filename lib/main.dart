import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'view/login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Menghilangkan tulisan debug
  ErrorWidget.builder = (FlutterErrorDetails details) => Container();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter GetX Login',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
