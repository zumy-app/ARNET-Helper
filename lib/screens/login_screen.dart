import 'package:arnet_helper/screens/login_email_password_screen.dart';
import 'package:arnet_helper/screens/phone_screen.dart';
import 'package:arnet_helper/screens/signup_email_password_screen.dart';
import 'package:arnet_helper/services/firebase_auth_methods.dart';
import 'package:arnet_helper/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            CustomButton(
              onTap: () {
                context.read<FirebaseAuthMethods>().signInWithGoogle(context);
              },
              text: 'Google Sign In',
            ),
            CustomButton(
              onTap: () {
                context.read<FirebaseAuthMethods>().signInWithFacebook(context);
              },
              text: 'Facebook Sign In',
            ),
          ],
        ),
      ),
    );
  }
}
