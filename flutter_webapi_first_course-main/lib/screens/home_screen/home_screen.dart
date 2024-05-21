import 'package:flutter/material.dart';
import 'package:flutter_webapi_first_course/screens/home_screen/widgets/home_screen_list.dart';
import 'package:flutter_webapi_first_course/services/journal_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/journal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // O último dia apresentado na lista
  DateTime currentDay = DateTime.now();

  // Tamanho da lista
  int windowPage = 10;

  // A base de dados mostrada na lista
  Map<String, Journal> database = {};

  final ScrollController _listScrollController = ScrollController();
  final JournalService service = JournalService();
  int? userId;
  String? userToken;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Título basado no dia atual
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
              onPressed: () {
                refresh();
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () {
                Logout();
              },
              title: const Text("sair"),
              leading: const Icon(Icons.logout),
            )
          ],
        ),
      ),
      body: (userId != null && userToken != null)
          ? ListView(
              controller: _listScrollController,
              children: generateListJournalCards(
                token: userToken!,
                userId: userId!,
                refreshFunction: refresh,
                windowPage: windowPage,
                currentDay: currentDay,
                database: database,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  void refresh() async {
    SharedPreferences.getInstance().then((preferences) {
      String? token = preferences.getString("accessToken");
      String? email = preferences.getString("email");
      int? id = preferences.getInt("id");

      if (token != null && email != null && id != null) {
        setState(() {
          userId = id;
          userToken = token;
        });
        service
            .getAll(id: id.toString(), token: token)
            .then((List<Journal> listJournal) {
          setState(() {
            database = {};
            for (Journal journal in listJournal) {
              database[journal.id] = journal;
            }
          });
        });
      } else {
        Navigator.pushReplacementNamed(context, "login");
      }
    });
  }

  Logout() {
    SharedPreferences.getInstance().then((prefs){
      prefs.clear();
      Navigator.pushReplacementNamed(context, "login");
    });
  }
}
