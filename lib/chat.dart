import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

//Запуск приложения
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://frvexfoezbscdbcvuxas.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZydmV4Zm9lemJzY2RiY3Z1eGFzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk3NDY4ODgsImV4cCI6MjA3NTMyMjg4OH0.XDr9MFxBMX0P42a4MwjstxtZeh_Caqdyrfpfr7d9ec8',
  );
  runApp(const MyApp());
}

//Статический класс для запросов
class Api {
  static var dbName = 'messages';
  //Выборка всех записей
  static Future<dynamic> getData() {
    return Supabase.instance.client.from(dbName).select();
  }

  //Добавление записи
  static Future<dynamic> createData(message) {
    return Supabase.instance.client.from(dbName).insert({'message': message});
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey = GlobalKey<FormState>();
  String message = "";
  void _submit() async {
    if (message.trim() == "") return;
    await Api.createData(message);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api.getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error} occured'));
          } else if (snapshot.hasData) {
            final data = snapshot.data;

            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                title: Text('Chat'),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...List.generate(data.length, (i) {
                            return Text(data[i]['message']);
                          }),
                        ],
                      ),
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100.0,
                          child: TextField(
                            decoration: InputDecoration(labelText: 'message'),
                            onChanged: (value) {
                              message = value;
                            },
                          ),
                        ),

                        TextButton(onPressed: _submit, child: Icon(Icons.send)),
                      ],
                    ),
                  ),
                ],
              ),

              floatingActionButton: FloatingActionButton(
                heroTag: 'btnReload',
                child: const Icon(Icons.replay_outlined),
                onPressed: () {
                  setState(() {});
                },
              ),
            );
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
