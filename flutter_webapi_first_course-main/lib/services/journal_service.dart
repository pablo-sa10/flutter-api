import 'dart:convert';

//import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';
import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'http_interceptors.dart';

class JournalService {
  static const String url = "http://10.10.2.173:3000/";
  static const String resource = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());
    http.Response response = await client.post(
      Uri.parse(getUrl()),
      headers: {'ContentType': 'application/json'},
      body: jsonJournal,
    );
    if (response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<bool> edit(String id, Journal journal) async {
    String jsonJournal = json.encode(journal.toMap());

    http.Response response = await client.put(
      Uri.parse("${getUrl()}$id"),
      headers: {'ContentType': 'application/json'},
      body: jsonJournal,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode != 200) {
      //Se token estiver expirado ele volta para tela de login
      if(response.body.contains("jwt expired")){
        AuthService auth = AuthService();
        auth.deleteUserInfos();
      }
      throw Exception();
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }
    return list;
  }

  Future<bool> delete(String id) async {
    http.Response response = await http.delete(Uri.parse("${getUrl()}$id"));
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }
}
