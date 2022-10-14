import 'package:arnet_helper/screens/login_email_password_screen.dart';
import 'package:arnet_helper/screens/login_screen.dart';
import 'package:arnet_helper/screens/phone_screen.dart';
import 'package:arnet_helper/screens/signup_email_password_screen.dart';
import 'package:arnet_helper/services/firebase_auth_methods.dart';
import 'package:arnet_helper/util/db.dart';
import 'package:arnet_helper/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'screens/requirement_edit.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Firebase Auth Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Dashboard(),
        // home: ReqEditForm(map: {}),
        // home: const AuthWrapper(),
        routes: {
          EmailPasswordSignup.routeName: (context) =>
          const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
      ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const Dashboard();
    }
    return const LoginScreen();
  }
}




