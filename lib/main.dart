import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_subscription/dependencyinjection/injection_container.dart'
    as ic;
import 'package:offline_subscription/dependencyinjection/injection_container.dart';
import 'package:offline_subscription/presentation/subscription/bloc/subscription_bloc.dart';
import 'package:offline_subscription/presentation/subscription/screen/subscription_page.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ic.init();
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
    return MultiProvider(providers: [
      BlocProvider<SubscriptionBloc>(
        create: (_) => serviceLocator<SubscriptionBloc>(),
      ),
    ], child: _wholeAppUi());
  }

  MaterialApp _wholeAppUi() => MaterialApp(
        home: const SubscriptionPage(),
        routes: {
          SubscriptionPage.tag: (context) => const SubscriptionPage(),
        },
      );
}
