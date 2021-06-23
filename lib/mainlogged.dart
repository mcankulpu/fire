import 'package:fire/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fire/login.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainLogged extends StatefulWidget {
  final user;
  MainLogged({Key? key, required this.user}) : super(key: key);

  @override
  _MainLoggedState createState() => _MainLoggedState();
}

class _MainLoggedState extends State<MainLogged> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
        (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Welcome, " + widget.user.displayName),
              duration: Duration(seconds: 3),
            )));
  }

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
                                shape: new RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                children: [
                                  Column(
                                    children: [
                                      ListTile(
                                        leading: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                    widget.user.photoUrl)),
                                          ),
                                        ),
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
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MyHomePage(
                                                          title: "Fire")),
                                              (Route<dynamic> route) => false);
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
                        radius: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(45),
                          child: CachedNetworkImage(
                              imageUrl: widget.user.photoUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator()),
                        ),
                        backgroundColor: Colors.transparent),
                  ),
                ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
          // <2> Pass `Future<QuerySnapshot>` to future
          future: FirebaseFirestore.instance.collection('data').get(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView(
                  children: documents
                      .map((doc) => Card(
                            child: ListTile(
                              title: Text(doc['name']),
                              subtitle: Text(doc['job']),
                            ),
                          ))
                      .toList());
            } else if (snapshot.hasError) {
              return Text("Error");
            }
            return const Center(child: CircularProgressIndicator());
            
          }),
    );
  }
}
