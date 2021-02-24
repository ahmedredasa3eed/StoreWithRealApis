import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movies/models/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserHelper  {
  Future<void> register(String mobile, String name, String password, String cityId) async {
    final url =
        "http://tufahatin.com/mobile/global/signup?mobile=$mobile&name=$name&token=123456&city_id=$cityId&password=$password";
    try {
      final response = await http.post(url,
          headers: {"Content-Type": "application/x-www-form-urlencoded"},
          body: json.encode({
            'mobile': mobile,
            'name': name,
            'city_id': cityId,
            'password': password,
          }));

      final decodedResponse = json.decode(response.body);

      if (decodedResponse['status'] == false) {
        throw FetchDataException(decodedResponse['message']);
      }

      final token = decodedResponse['user']['token'];
      final device = decodedResponse['user']['device'];
      final role = decodedResponse['user']['role'];

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('token', token);
      preferences.setString('device', device);
      preferences.setString('role', role);
    } on FetchDataException catch (error) {
      throw FetchDataException(error.toString());
    }catch (error){
      throw error;
    }
  }

  Future<void> login(String mobile, String password, String token) async {
    var url = "http://tufahatin.com/mobile/global/login?mobile=$mobile&token=$token&password=$password";
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = json.decode(data);

        if (jsonData['activated'] == false) {
          throw FetchDataException(jsonData["message"]);

        } else if (jsonData['status'] == false) {
          throw FetchDataException(jsonData["message"]);
        }

        final token = jsonData['user']['token'];
        final id = jsonData['user']['id'];
        final mobile = jsonData['user']['mobile'];
        final device = jsonData['user']['device'];
        final role = jsonData['user']['role'];


        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('token', token);
        preferences.setString('userId', id);
        preferences.setString('mobile', mobile);
        preferences.setString('device', device);
        preferences.setString('role', role);
      } else {
        print("Status Code : ${response.statusCode}");
      }
    } on FetchDataException catch (error) {
      throw FetchDataException(error.toString());
    } catch (error) {
      print(error);
    }
  }
}
