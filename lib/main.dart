import 'package:flutter/material.dart';
import 'package:projetflutter_nam/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  //mettre le notifier provider le plus proche possible du runApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      home: Homepage(),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: Homepage(),
    );
  }
}
*/

//>>>>>>> a908dfc (containers de base et FAB)


