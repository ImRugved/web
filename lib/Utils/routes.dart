import 'package:get/get.dart';
import 'package:web_app/Screens/Entry_Screen/Binding/entry_binding.dart';
import 'package:web_app/Screens/Entry_Screen/View/home.dart';
import 'package:web_app/Screens/Exit_Screen/Bindings/exit_binding.dart';
import 'package:web_app/Screens/Exit_Screen/View/exit_screen.dart';
import 'package:web_app/Screens/Home_Screen/View/homeScreen.dart';
import 'package:web_app/Screens/Login_Screen/Binding/login_binding.dart';
import 'package:web_app/Screens/Login_Screen/View/login_screen.dart';
import 'package:web_app/Screens/Splash_Screen/splash.dart';

class Routes {
  static final pages = [
    //Splash screen
    GetPage(name: '/splash_screen', page: () => const SplashScreen()),

    //Home page screen
    GetPage(
        name: '/entry_screen',
        page: () => const EntryScreen(),
        binding: EntryBinding()),
    GetPage(
      name: '/home_screen',
      page: () => const HomeScreen(),
    ),

    //Login page Screen
    GetPage(
        name: '/login_screen',
        page: () => const LoginForm(),
        binding: LoginBinding()),

    // //Exit page screen
    GetPage(
        name: '/exit_screen',
        page: () => const ExitScreen(),
        binding: ExitBinding()),
  ];
}
