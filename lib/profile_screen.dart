import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adoption_app/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.profile,
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 20),
            Text(
              user?.email ?? AppLocalizations.of(context)!.user_not_logged,
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (route) => false,
                  );
                } catch (e) {
                  print("Erro ao fazer logout: $e");
                }
              },
              child: Text(AppLocalizations.of(context)!.log_out),
            ),
          ],
        ),
      ),
    );
  }
}
