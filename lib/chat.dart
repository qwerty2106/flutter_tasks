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
  //Выборка всех записей
  static Future<dynamic> getData() {
    return Supabase.instance.client.from('messages').select();
  }

  //Добавление записи
  static Future<dynamic> createData(message) {
    return Supabase.instance.client.from('messages').insert({
      'message': message,
    });
  }

  //Регистрация
  static Future<dynamic> signUp(login, password) {
    return Supabase.instance.client.from('users').insert({
      login: login,
      password: password,
    });
  }

  //Аутентификация
  static Future<dynamic> signIn(login, password) {
    return Supabase.instance.client.from('users').select().eq(login, password);
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

//LOGIN PAGE
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => __LoginPageState();
}

class __LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String login = "";
  String password = "";

  void _signIn() async {
    if (login.trim() == "" || password.trim() == "") return;
    await Api.signIn(login, password);
    setState(() {});
  }

  void _signUp() async {
    if (login.trim() == "" || password.trim() == "") return;
    await Api.signUp(login, password);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Login'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Type your login'),
                  onChanged: (value) {
                    login = value;
                  },
                ),

                TextField(
                  decoration: InputDecoration(labelText: 'Type your password'),
                  onChanged: (value) {
                    password = value;
                  },
                ),

                Row(
                  children: [
                    TextButton(onPressed: _signIn, child: Text('Sign In')),
                    TextButton(onPressed: _signUp, child: Text('Sign Up')),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
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
                  //Кнопка авторизации
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text('Login'),
                  ),

                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Text(data[index]['message']);
                      },
                    ),
                  ),

                  Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Type smth...',
                            ),
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
