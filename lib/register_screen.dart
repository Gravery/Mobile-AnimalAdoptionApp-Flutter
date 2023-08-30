import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  Future<void> firebaseSignup() async {
    try {
      final String email = usernameController.text.trim();
      final String password = passwordController.text.trim();
      final String confirmPassword = confirmPasswordController.text.trim();

      if (email.isNotEmpty &&
          password.isNotEmpty &&
          confirmPassword.isNotEmpty) {
        if (password == confirmPassword) {
          UserCredential userCredential =
              await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );

          print('User registered: ${userCredential.user?.email}');
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.password_not_match),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.error_credentials),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String registerText = AppLocalizations.of(context)!.register;
    final String usernameLabel = AppLocalizations.of(context)!.username;
    final String passwordLabel = AppLocalizations.of(context)!.password;
    final String confirmPasswordLabel =
        AppLocalizations.of(context)!.confirm_password;
    final String registerButtonText = AppLocalizations.of(context)!.register;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 150),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  registerText,
                  style: TextStyle(fontSize: 50),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: usernameLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: passwordLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: confirmPasswordLabel,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 36),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        firebaseSignup();
                      },
                      child: Text(registerButtonText),
                    ),
                    const SizedBox(width: 20),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
