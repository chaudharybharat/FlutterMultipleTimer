import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_timer_app/pages/timers_screen.dart';
import 'package:multi_timer_app/utils/app_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi Timer App',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
        primaryColor: AppColor.whiteColor,
        fontFamily: "Inter",
        useMaterial3: true,
      ),
      home: const TimersScreen(),
    );
  }
}
