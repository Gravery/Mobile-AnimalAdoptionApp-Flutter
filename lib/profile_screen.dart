import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:adoption_app/main.dart';

class ProfileScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
              child: Text('Sair'),
            ),
            SizedBox(height: 20),
            Text(
              'Perfil',
              style: TextStyle(fontSize: 50),
            ),
            SizedBox(height: 20),
            Text(
              user?.email ?? 'Usuário não logado',
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
