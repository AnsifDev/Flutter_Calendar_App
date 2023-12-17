import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_test/event_edit_bottom_sheet.dart';
import 'package:project_test/channels_page.dart';
import 'package:project_test/color_schemes.dart';
import 'package:project_test/data_provider.dart';
import 'package:project_test/event.dart';
import 'package:project_test/schedules_page.dart';
import 'package:project_test/upcoming_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that the Flutter bindings are initialized.

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Home());
}

class Home extends StatefulWidget {
  final DataProvider dataProvider = DataProvider.getInstance();

  Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  void initState() {
    widget.dataProvider.setHomeState = setState;
    widget.dataProvider.onAppInit();

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
        child: FilledButton(onPressed: () {
          signInWithGoogle().then((value) {
            Navigator.pushReplacementNamed(context, '/home');
          }).onError((error, stackTrace) { print(stackTrace); });
        }, child: const Text("Sign In")),
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