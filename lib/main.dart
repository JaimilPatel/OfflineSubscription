import 'dart:async';
import 'package:flutter/material.dart';
import 'package:offline_subscription/presentation/subscription/screen/subscription_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    return _wholeAppUi();
  }

  MaterialApp _wholeAppUi() => MaterialApp(
        home: const SubscriptionPage(),
        routes: {
          SubscriptionPage.tag: (context) => const SubscriptionPage(),
        },
      );
}
