import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sfs/providers/auth_provider.dart';
import 'package:sfs/providers/course_provider.dart';
import 'package:sfs/providers/recommendation_provider.dart';
import 'package:sfs/repositories/course_repository.dart';
import 'package:sfs/repositories/user_repository.dart';
import 'package:sfs/services/auth_service.dart';
import 'package:sfs/screens/auth/login_screen.dart';
import 'package:sfs/screens/home/home_screen.dart';
import 'package:sfs/screens/account/account_screen.dart';
import 'package:sfs/services/course_service.dart';
import 'package:sfs/widgets/bottom_navbar.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(create: (_) => UserRepository()),
        Provider<AuthService>(
          create: (context) => AuthService(
            Provider.of<UserRepository>(context, listen: false),
          ),
        ),
        Provider<CourseRepository>(create: (_) => CourseRepository()),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(
            Provider.of<AuthService>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider(create: (_) => BottomNavBarProvider()),
        Provider<CourseService>(
          create: (context) => CourseService(
            Provider.of<CourseRepository>(context, listen: false),
          ),
        ),
        ChangeNotifierProvider<CourseProvider>(
          create: (context) => CourseProvider(
            Provider.of<CourseService>(context, listen: false),
          ),
        ),
        ChangeNotifierProxyProvider<AuthProvider, RecommendationProvider>(
          create: (_) => RecommendationProvider(null),
          update: (context, auth, previous) => RecommendationProvider(auth),
        ),
      ],
      child: MaterialApp(
        title: 'SISTER for Student',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            appBarTheme: AppBarTheme(
              color: const Color(0xFF1E90FF),
              iconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
        debugShowCheckedModeBanner: false,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading && authProvider.user == null) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFF1E90FF)),
                ),
              );
            }
            if (authProvider.user != null) {
              return const MainScreenWrapper();
            } else {
              return const LoginScreen();
            }
          },
        ),
      ),
    );
  }
}

class MainScreenWrapper extends StatelessWidget {
  const MainScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomNavBarProvider = Provider.of<BottomNavBarProvider>(context);

    final List<Widget> _pages = [
      const HomeScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: bottomNavBarProvider.currentIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
