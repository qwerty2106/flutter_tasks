import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.mode_comment),
        onPressed: () => print('Button pressed!'),
      ),
      body: Column(
        children: [
          Container(width: double.infinity, height: 100, color: Colors.purple),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('text1'), Text('text2'), Text('text3')],
          ),
          Container(
            width: double.infinity,
            height: 200,
            color: Colors.purpleAccent,
          ),

          Padding(
            padding: EdgeInsets.all(10),
            child: Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://cdn-icons-png.flaticon.com/512/5302/5302210.png',
                    ),
                  ),
                  CircleAvatar(radius: 30, backgroundColor: Colors.pinkAccent),
                ],
              ),
            ),
          ),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < 20; i++)
                  Container(
                    margin: EdgeInsets.all(10),
                    width: 100,
                    height: 50,
                    color: Colors.pinkAccent,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
