import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:party_planner/controller/auth/login_screen_controller.dart';
import 'package:party_planner/view/auth/login/login.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_storage/get_storage.dart';
import 'package:party_planner/view/navigation_menu.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GetStorage _storage = GetStorage();
  bool _animationCompleted = false;
  bool _screenReady = false;
  Widget? _targetScreen;

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> determineNextScreen() async {
    bool hasInternet = await checkInternetConnection();
    if (!hasInternet) {
      _targetScreen = LoginScreen();
    } else {
      bool isLoggedIn = await Get.put(LoginScreenController(), permanent: true).autoLogin();
      _targetScreen = isLoggedIn ? NavigationMenu() : LoginScreen();
    }

    if (_animationCompleted) {
      Get.offAll(() => _targetScreen!);
    } else {
      setState(() => _screenReady = true);
    }
  }

  void initializeApp() {
    determineNextScreen(); // استدعاء الدالة دون انتظارها

    Future.delayed(const Duration(milliseconds: 5500), () {
      if (_screenReady && _targetScreen != null) {
        Get.offAll(() => _targetScreen!);
      } else {
        setState(() => _animationCompleted = true);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initializeApp(); // استدعاء الدالة داخل initState() بدون async/await
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    double splashSize =
        screenWidth < screenHeight ? screenWidth * 0.7 : screenHeight * 0.7;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: _animationCompleted && !_screenReady
            ? const CircularProgressIndicator()
            : Lottie.asset(
                'assets/splash/splash_screen.json',
                fit: BoxFit.contain,
                width: splashSize,
              ),
      ),
    );
  }
}
