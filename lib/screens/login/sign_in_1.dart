import 'package:arnet_helper/screens/login/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:arnet_helper/services/firebase_auth_methods.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../util/utils.dart';
class SignInOne extends StatelessWidget {
  const SignInOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //logo section

                Text(
                  "ARNET Helper",
              style: const TextStyle(
              fontSize: 30.0,
              color: Colors.black,fontWeight: FontWeight.bold,
            )
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                //sign in with google & apple
                // signInGoogleButton(size),

            SignInOneSocialButton(
            iconPath: 'images/google_logo.svg',
            text: 'Sign in with Google',
            size: size,
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                }
          ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                // signInAppleButton(size),
                SizedBox(
                  height: size.height * 0.03,
                ),
            SignInOneSocialButton(
              iconPath: 'images/fb.svg',
              text: 'Sign in with Facebook',
              size: size,
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInWithFacebook(context);
                }
            ),SizedBox(
                  height: size.height * 0.02,
                ),
              //sign up text here
              Center(
              child: footerText(),
        ),

                SizedBox(
                  height: size.height * 0.1,
                ),
                logo(size.height / 16, size.height / 16)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return InkWell(
      child: SvgPicture.asset(
        'images/logo.svg',
        height: height_,
        width: width_,
      ),
      onTap: ()=>{ launchUrl(Uri.parse("https://zumy.app/mil/arnet"))},
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 3,
          height: 1.03,
        ),
        children: const [
          TextSpan(
            text: 'LOGIN ',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'PAGES \nUI ',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: 'KIT',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
  }

  //sign up text here
  Widget footerText() {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12.0,
          color: const Color(0xFF3B4C68),
        ),
        children: const [
          TextSpan(
            text: 'Built with ❤ in Wood Ridge, NJ',
          ),
          TextSpan(
            text: ' ',
            style: TextStyle(
              color: Color(0xFF21899C),
            ),
          ),

        ],
      ),
    );

}
