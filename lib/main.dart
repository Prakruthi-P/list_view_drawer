import 'package:flutter/material.dart';
import 'package:list_view_drawer/screens/ListView.dart';
import 'package:list_view_drawer/screens/page1.dart';
import 'package:list_view_drawer/screens/page2.dart';
import 'package:list_view_drawer/screens/page3.dart';
import 'package:list_view_drawer/screens/page4.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ListViewPage(),
        routes: { '/page1': (context) => Page1(),
          '/page2': (context) => Page2(),
          '/page3': (context) => Page3(),
          '/page4': (context) => Page4(),},

    );
  }
}

