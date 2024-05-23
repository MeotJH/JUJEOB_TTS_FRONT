import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jujeob_tts/jujeob_page.dart';
import 'package:jujeob_tts/tts_server_page.dart';
import 'package:url_strategy/url_strategy.dart';

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const TTSServerPage();
      },
    ),
    GoRoute(
      path: '/jujeob',
      builder: (BuildContext context, GoRouterState state) {
        return const JujeobPage();
      },
    ),
  ],
);

void main() {
  setPathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Jujeob TTS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
