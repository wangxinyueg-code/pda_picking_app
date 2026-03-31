import 'package:flutter/material.dart';
import 'pda_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDA拣货系统',
      debugShowCheckedModeBanner: false,
      // 
      theme: ThemeData(
        useMaterial3: true,
        platform: TargetPlatform.fuchsia,
        visualDensity: VisualDensity.standard,
      ),
      // 
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
            boldText: false,
          ),
          child: child!,
        );
      },
      home: const PdaHomePage(),
    );
  }
}