import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'app_navigator.dart';
import 'home_screen.dart';
import 'announcement_screen.dart';
import 'management_screen.dart';
import 'profile_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption App',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('pt'),
      ],
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => MainScreen(initialTab: AppTab.home),
      },
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
            return MainScreen(initialTab: AppTab.home);
          }
        }

        return Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  final AppTab initialTab;

  MainScreen({required this.initialTab, Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialTab.index);
    _currentIndex = widget.initialTab.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          AnnouncementScreen(),
          ManagementScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavyBarItem(
            icon: Icon(Icons.home),
            title: Text(AppLocalizations.of(context)!.home),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context)!.announce),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.notifications),
            title: Text(AppLocalizations.of(context)!.manage),
          ),
          BottomNavyBarItem(
            icon: Icon(Icons.person),
            title: Text(AppLocalizations.of(context)!.profile),
          ),
        ],
      ),
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
