import 'package:diploma_16_10/google_sheets_api.dart';
import 'package:diploma_16_10/pages/auth_page.dart';
import 'package:diploma_16_10/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:diploma_16_10/theme/theme.dart';



void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   GoogleSheetsApi.init();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform);
  
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: const MainApp(),
    )
  );
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthPage(),
        theme: Provider.of<ThemeProvider>(context).themeData,
      );
  }
  
}
