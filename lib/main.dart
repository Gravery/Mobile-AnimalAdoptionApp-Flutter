import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import 'app_navigator.dart';
import 'home_screen.dart';
import 'announcement_screen.dart';
import 'management_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => AppNavigatorCubit(),
        child: AuthenticationWrapper(),
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;

          if (user == null) {
            return LoginScreen();
          } else {
            return MainScreen();
          }
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppNavigatorCubit, AppTab>(
      builder: (context, activeTab) {
        return Scaffold(
          body: _buildScreen(activeTab),
          bottomNavigationBar: BottomNavyBar(
            selectedIndex: activeTab.index,
            onItemSelected: (index) {
              final appNavigator = context.read<AppNavigatorCubit>();
              switch (index) {
                case 0:
                  appNavigator.showHome();
                  break;
                case 1:
                  appNavigator.showAnnounce();
                  break;
                case 2:
                  appNavigator.showManage();
                  break;
                case 3:
                  appNavigator.showProfile();
                  break;
              }
            },
            items: [
              BottomNavyBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.dashboard),
                title: Text('Anunciar'),
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.notifications),
                title: Text('Gerenciar'),
              ),
              BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Perfil'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScreen(AppTab activeTab) {
    switch (activeTab) {
      case AppTab.home:
        return HomeScreen();
      case AppTab.announce:
        return AnnouncementScreen();
      case AppTab.manage:
        return ManagementScreen();
      case AppTab.profile:
        return ProfileScreen();
    }
  }
}
