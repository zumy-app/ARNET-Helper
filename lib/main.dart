import 'package:arnet_helper/screens/login/sign_in_1.dart';
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
final dbRef = DB();

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
        debugShowCheckedModeBanner: false,
        title: 'ARNET Helper',
        theme: ThemeData(
            primarySwatch: Colors.green,
            appBarTheme: const AppBarTheme(
              titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20, fontWeight: FontWeight.bold),
            ),
            fontFamily: 'OpenSans',
            textTheme: ThemeData.light().textTheme.copyWith(
              titleLarge: const TextStyle(fontFamily: 'OpenSans', fontSize: 20, fontWeight: FontWeight.bold),
              titleMedium: const TextStyle(fontFamily: 'OpenSans', fontSize: 18, fontWeight: FontWeight.bold),
              titleSmall: const TextStyle(fontFamily: 'OpenSans', fontSize: 16, fontWeight: FontWeight.w400),
            )
        ),
        // home: Dashboard(),
        // home: ReqEditForm(map: {}),
        home: const AuthWrapper(),
        routes: {
          EmailPasswordSignup.routeName: (context) =>
          const EmailPasswordSignup()
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
      return  Dashboard(user:firebaseUser);
    }
    return const SignInOne();
  }
}




