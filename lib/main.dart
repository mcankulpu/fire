import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);



class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Fire'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var username;
  var userimg;
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
    } catch (e) {}
  }

  Future signInWithGoogle() async {
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
      username = _googleSignIn.currentUser!.displayName;
      userimg = _googleSignIn.currentUser!.photoUrl;
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    setState(() {
      username = "";
      userimg = "";
    });
  }


  @override
  void initState() {
    initializeFlutterFire();
    super.initState();

      _googleSignIn.onCurrentUserChanged.listen((account) 
{
 
       setState(() {
      username = _googleSignIn.currentUser?.displayName;
      userimg = _googleSignIn.currentUser?.photoUrl;
    });
  
  
});
_googleSignIn.signInSilently();
 
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
        children: [
          MaterialButton(
            onPressed: signInWithGoogle,
            child: Text("Google ile Giriş Yap"),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userimg == null
                    ? SizedBox()
                    : CircleAvatar(
                        backgroundImage: NetworkImage(userimg),backgroundColor: Colors.transparent,
                      ),
                      SizedBox(width: 10,),
                username == null ? SizedBox() : Text(username)
              ],
            ),
          ),
          Divider(),
          MaterialButton(
            onPressed: _signOut,
            child: Text("Çıkış Yap"),
          ),
        ],
      )),
    );
  }
}
