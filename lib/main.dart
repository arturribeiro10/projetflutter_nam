import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projetflutter_nam/screens/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //notifs
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'key2',
            channelName: 'Notifications échéances',
            channelDescription: "Recevez une notification quand votre todolist arrive à échéance",
          defaultColor: Color(0XFF9050DD),
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        ),
        NotificationChannel(
          channelKey: 'key3',
          channelName: 'Testing',
          channelDescription: "Testing",
          defaultColor: Color(0XFF9050DD),
          locked: true,
          ledColor: Colors.white,
          playSound: true,
          enableLights: true,
          enableVibration: true,
          importance: NotificationImportance.High,
          channelShowBadge: true,
        )
      ]
  );
  AwesomeNotifications().actionStream.listen((event) { });
  ;
  //firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCpy--HOlNdwSwhcXDphTZFtXCSmw4k48Y", //OK
        authDomain: "projetflutter-68f31.firebaseapp.com", //OK
        projectId: "projetflutter-68f31", //OK
        storageBucket: "projetflutter-68f31.appspot.com", //OK
        messagingSenderId: "979644075751", //OK
        appId: "1:979644075751:android:f664f22d8a3a4cbe3a5c42" //OK
    ),
  );
  runApp(MyApp());
  //mettre le notifier provider le plus proche possible du runApp
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return const MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('fr')
      ],
      home: Homepage(),
    );
  }
}


