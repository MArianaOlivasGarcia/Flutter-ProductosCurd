import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crud/screens/screens.dart';
import 'package:crud/providers/providers.dart';

void main() => runApp(AppState());


class AppState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MyApp(),
    );
  }

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'ckecking',
      routes: {
        'ckecking': (_) => CkeckAuthScreen(),
        'home': (_) => HomeScreen(),
        'login': (_) => LoginScreen(), 
        'register': (_) => RegisterScreen(), 
        'product': (_) => ProductScreen(),
      },
      scaffoldMessengerKey: NotificationsProvider.messagerKey,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          elevation: 0,
          color: Colors.indigo
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          elevation: 0,
          backgroundColor: Colors.indigo
        )
      )
    );
  }
}
