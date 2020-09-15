import 'package:flutter/material.dart';
import 'package:hava_durumu/shared_prefs.dart';
import 'home_page.dart';
import 'instant_location.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefs.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Google Places Demo',
        theme: ThemeData(
          primaryColor: Color.fromARGB(255, 251, 203, 4),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: InstantLocation());
  }
}
