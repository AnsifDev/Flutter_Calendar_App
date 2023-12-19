import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_test/color_schemes.dart';
import 'package:project_test/data_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter bindings are initialized.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(Home());
}

class Home extends StatefulWidget {
  final DataProvider dataProvider = DataProvider.instance;

  Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    widget.dataProvider.setHomeState = setState;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(colorScheme: lightColorScheme, useMaterial3: true),
      darkTheme: ThemeData(colorScheme: darkColorScheme, useMaterial3: true),
      themeMode: widget.dataProvider.themeMode,
      routes: {
        '/auth': (context) => const AuthPage(),
        '/home': (context) => HomePage(),
      },
      home: FirebaseAuth.instance.currentUser == null? const AuthPage(): HomePage()
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<StatefulWidget> createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/intro.png',width: 300,),
            FilledButton(onPressed: () {
              signInWithGoogle().then((value) {
                Navigator.pushReplacementNamed(context, '/home');
              }).onError((error, stackTrace) { log(stackTrace.toString()); });
            }, child: const Text("Sign In")),
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

String getFormattedTime(DateTime dateTime) {
  var halfNotation = dateTime.hour < 12 ? "AM" : "PM";
  var hour = dateTime.hour % 12;
  var minute = dateTime.minute;
  var formattedTime =
      "${hour < 10 && hour != 0 ? "0" : ""}${hour == 0 ? 12 : hour}:${minute < 10? "0":""}$minute $halfNotation";
  return formattedTime;
}