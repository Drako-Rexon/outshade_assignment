import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:outshade_assign/pages/homepage.dart';

import 'dart:async';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Box box = await Hive.openBox('dataBox');

  // Hive.registerAdapter(DetailsAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outshade',
      theme: ThemeData(primarySwatch: Colors.purple),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
