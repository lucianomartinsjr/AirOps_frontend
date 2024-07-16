import 'package:airops_frontend/screens/auth/register/register_screen.dart';
import 'package:airops_frontend/screens/profile_page/change_password.dart';
import 'package:airops_frontend/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/profile_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth/login/login_screen.dart';
import 'screens/auth/login/splash_screen.dart';
import 'screens/auth/forgot_password/forgot_password_screen.dart';
import 'screens/games_screen.dart';
import 'screens/profile_page/profile_screen.dart';
import 'services/airsoft_service.dart';
import 'widgets/bottom_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AirsoftService()),
        ChangeNotifierProvider(create: (_) => ApiService()),
        ChangeNotifierProxyProvider<ApiService, ProfileProvider>(
          create: (_) => ProfileProvider(),
          update: (_, apiService, profileProvider) =>
              profileProvider!..initialize(apiService),
        ),
      ],
      child: MaterialApp(
        title: 'AirOps',
        theme: ThemeData(
          primaryColor: const Color(0xFF222222),
          scaffoldBackgroundColor: const Color(0xFF222222),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF222222),
            foregroundColor: Colors.white,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFF222222),
            selectedItemColor: Colors.red,
            unselectedItemColor: Colors.grey,
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white24,
            hintStyle: const TextStyle(color: Colors.white54),
            prefixIconColor: Colors.white54,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/home-screen': (context) => const MainScreen(),
          '/change-password': (context) => const ChangePasswordScreen(),
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ProfileScreen(),
    HomeScreen(),
    GamesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
