import 'package:flutter/material.dart';
import 'challenge_page.dart';
import 'result_page.dart';
import 'fail_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // API 키 로딩 확인
  final apiKey = dotenv.env['GEMINI_API_KEY'];
  //print('API 키 로딩 상태: ${apiKey != null ? "성공" : "실패"}');
  if (apiKey != null) {
    //print('API 키 첫 5자: ${apiKey.substring(0, 5)}...');
  }

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/challenge': (context) => const ChallengePage(),
        '/result': (context) => const ResultPage(),
        '/fail': (context) => const FailPage(),
      },
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 72,
            top: 390,
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/challenge'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5AA450),
                minimumSize: const Size(258, 95),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
