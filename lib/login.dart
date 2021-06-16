import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fire/mainlogged.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  singOut() => createState()._signOut();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var username;
  var userimg;
  var loading = false;

  Future signInWithGoogle() async {
    setState(() {
       loading = true;
    });
   
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    setState(() {
      loading = false;
    });

    
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MainLogged(user: _googleSignIn.currentUser),
        ));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/img/back.jpg"), fit: BoxFit.cover)),
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "Fire",
              style: GoogleFonts.lemon(
                  color: Colors.white,
                  fontSize: 64,
                  shadows: <Shadow>[
                    Shadow(offset: Offset(1, 1), blurRadius: 2)
                  ]),
            ),
          ),
          MaterialButton(
            height: 60,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 1,
            color: Colors.blue[600],
            onPressed: signInWithGoogle,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  loading ? SizedBox(width: 32,height: 32, child: CircularProgressIndicator(color: Colors.white,)) :
                  Image.asset(
                    "assets/img/google.png",
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Google ile Giriş Yap",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
