import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mobile/common/AlertError.dart';
import 'package:mobile/pages/HomePage.dart';
import 'package:mobile/pages/LoginPage.dart';
import 'package:mobile/pages/SingUpPage.dart';

Future<void> main() async {
  await dotenv.load(fileName: "assets/.env");
  runApp(MyApp());
}

final GoRouter _router = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: '/login',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MyHomePage();
      },
    ),
    GoRoute(
      path: '/login',
      builder: ( context,  state){
        return const MyLoginPage();
      }
    ),
    GoRoute(
        path:'/sign-up',
      builder: (context, state){
          return const MySignUpPage();
      }
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
    );
  }
}
