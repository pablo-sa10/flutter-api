import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/screens/add_journal_screen/add_jorunal_screen.dart';
import 'package:flutter_webapi_first_course/screens/login_screen/login.dart';
//import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen/home_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  bool isLogged = await verifyToken();
  runApp(MyApp(isLogged: isLogged,));
  //JournalService service = JournalService();
  //service.register(Journal.empty());
  //service.getAll();
}

Future<bool> verifyToken() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? token = preferences.getString("accessToken");
  if(token != null){
    return true;
  }
  return false;
}

class MyApp extends StatelessWidget {
  final bool isLogged;
  const MyApp({Key? key, required this.isLogged }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.green,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.white),
              elevation: 0,
              backgroundColor: Colors.black,
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              actionsIconTheme: IconThemeData(color: Colors.white)
          ),
          textTheme: GoogleFonts.bitterTextTheme()),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      initialRoute: (isLogged)? "home" : "login",
      routes: {
        "home": (context) => const HomeScreen(),
        "login": (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == "add-journal") {
          Map<String, dynamic> map = settings.arguments as Map<String, dynamic>;
          final Journal journal = map["journal"] as Journal;
          final bool isEditing = map["is_editing"];
          return MaterialPageRoute(builder: (context) {
            return AddJournalScreen(journal: journal, isEditing: isEditing,);
          });
        }
        return null;
      },
    );
  }
}
