import 'package:http/http.dart' as http;

Future Getdata(url) async {
  print("hi");
  http.Response Response = await http.get(url);
  print("returning");
  return Response.body;
}
