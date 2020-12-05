import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API {
  final String _url = 'http://nvuti.uz/api/';
  var token;

  _getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    token = localStorage.getString('token');
  }

  post(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http
        .post(fullUrl, body: data, headers: _setHeaders())
        .timeout(Duration(seconds: 5), onTimeout: () {
      return null;
    });
  }

  put(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http
        .put(fullUrl, body: data, headers: _setHeaders())
        .timeout(Duration(seconds: 5), onTimeout: () {
      return null;
    });
  }

  delete(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    return await http
        .delete(fullUrl, headers: _setHeaders())
        .timeout(Duration(seconds: 5), onTimeout: () {
      return null;
    });
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    await _getToken();
    final res = await http
        .get(fullUrl, headers: _setHeaders())
        .timeout(Duration(seconds: 5), onTimeout: () {
      return null;
    });
    return res;
  }

  _setHeaders() =>
      {'Accept': 'application/json', 'Authorization': 'Bearer $token'};
}
