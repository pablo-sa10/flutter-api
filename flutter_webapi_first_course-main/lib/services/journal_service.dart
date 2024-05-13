import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'http_interceptors.dart';

class JournalService {
  static const String url = "http://10.10.2.173:3000/";
  static const String resource = "learnhttp/";

  http.Client client = InterceptedClient.build(interceptors: [LoggingInterceptor()]);

  String getUrl() {
    return "$url$resource";
  }

  void register(String content){
    print("deu certo");
    client.post(Uri.parse(getUrl()), body: json.encode({"content": content}));
  }

  Future<String> get() async{
    http.Response response = await client.get(Uri.parse(getUrl()));
    print(response.body);
    return response.body;
  }
}
