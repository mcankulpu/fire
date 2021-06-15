import 'package:fire/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fire/login.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class MainLogged extends StatefulWidget {
  final user;
  MainLogged({Key? key, required this.user}) : super(key: key);

  @override
  _MainLoggedState createState() => _MainLoggedState();
}

class _MainLoggedState extends State<MainLogged> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        actions: [
          (widget.user.displayName == "")
              ? Icon(Icons.account_circle)
              : Container(
                  margin: EdgeInsets.only(right: 10),
                  width: 32,
                  height: 32,
                  child: GestureDetector(
                    onTap: () async {
                      await showDialog(
                          builder: (context) => SimpleDialog(
                                children: [
                                  Column(
                                    children: [
                                      ListTile(
                                        leading:
                                            Image.network(widget.user.photoUrl),
                                        title: Text(widget.user.displayName),
                                        subtitle: Text(widget.user.email),
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      MaterialButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        elevation: 1,
                                        color: Colors.blue[600],
                                        onPressed: () {
                                          Login().singOut();
                                          Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => MyHomePage(title: "Fire"),
    ));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.exit_to_app,
                                                color: Colors.white,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                "Çıkış Yap",
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
                                  )
                                ],
                              ),
                          context: context);
                    },
                    child: CircleAvatar(
                        child: Image.network(
                          widget.user.photoUrl,
                          fit: BoxFit.cover,
                        ),
                        backgroundColor: Colors.transparent),
                  ),
                ),
        ],
      ),
      body: Container(),
    );
  }
}