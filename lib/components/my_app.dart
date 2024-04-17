import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:robot_control_app/screens/about_screen.dart';
import 'package:robot_control_app/theme_model/theme_model.dart';
import '../screens/sensor_data_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, themeModel, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Robot Control App',
            theme: themeModel.themeData,
            home: const SensorDataScreen(),
            routes: {
              '/about': (context) => const AboutScreen(),
            },
          );
        },
      ),
    );
  }
}
