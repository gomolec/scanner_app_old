import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scanner_app/models/product_model.dart';
import 'cubit/history_cubit/history_cubit.dart';
import 'cubit/history_cubit/history_listener.dart';
import 'cubit/product_list_cubit/product_list_cubit.dart';
import 'cubit/product_list_cubit/products_list_listener.dart';
import 'models/history_action_model.dart';
import 'models/session_model.dart';
import 'screens/info_screen/info_screen.dart';
import 'screens/sessions_history_screen/sessions_history_screen.dart';
import 'screens/settings_screen/settings_screen.dart';
import 'screens/welcome_screen/welcome_screen.dart';
import 'cubit/session_cubit/session_cubit.dart';
import 'cubit/session_cubit/session_listener.dart';
import 'screens/home_screen/home_screen.dart';
import 'screens/product_screen/product_screen.dart';
import 'screens/scanner_screen/scanner_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter(ProductAdapter());
  Hive.registerAdapter(HistoryActionAdapter());
  Hive.registerAdapter(SessionAdapter());

  await Hive.openBox<Session>("saved_sessions");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SessionCubit(),
        ),
        BlocProvider(
          create: (context) => ProductListCubit(),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: SessionListener(
        child: ProductListListener(
          child: HistoryListener(
            child: MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: '/welcome',
              routes: {
                '/': (context) => const HomeScreen(),
                '/product': (context) => const ProductScreen(),
                '/welcome': (context) => const WelcomeScreen(),
                '/scanner': (context) => ScannerScreen(),
                '/sessions_history': (context) => const SessionsHistoryScreen(),
                '/settings': (context) => const SettingsScreen(),
                '/info': (context) => const InfoScreen(),
              },
            ),
          ),
        ),
      ),
    );
  }
}
