import 'dart:convert';
import 'package:http/http.dart' as http;

class JournalService {
  static const String url = "http://10.10.2.173:3000/";
  static const String resource = "learnhttp/";

  String getUrl() {
    return "$url$resource";
  }

  void register(String content){
    print("deu certo");
    http.post(Uri.parse(getUrl()), body: json.encode({"content": content}));
  }

  Future<String> get() async{
    http.Response response = await http.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
