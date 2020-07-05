import 'package:ecom/authentication/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecom/utils/globals.dart' as globals;
import 'package:google_sign_in/google_sign_in.dart';

class NavDrawer extends StatelessWidget {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 200,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 55.0,
                    height: 55.0,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.transparent,
                      image: DecorationImage(
                        image: NetworkImage(globals.user?.photoUrl ?? ""),
                        fit: BoxFit.fill,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  ),
                  Text(
                    '${globals.user?.displayName ?? globals.user?.phoneNumber ?? "User Name"}',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                  Text(
                    'ID : ${globals.user?.uid ?? ""}',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              googleSignIn.signOut();
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => LoginPage()), (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
    );
  }
}
