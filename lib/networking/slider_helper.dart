import 'dart:convert';
import 'package:http/http.dart' as http;

class SliderHelper {

  Future<List> fetchSliders() async {
    try {
      final url = "http://tufahatin.com/mobile/main/get_home_sliders";

      final response = await http.get(url);

      if (response.statusCode == 200) {
        String data = response.body;
        var jsonData = json.decode(data);
        List sliders = jsonData['sliders'];
        return sliders;
      }
      else{
        print("Status Code = ${response.statusCode}");
      }

    } catch (error) {
      print(error);
    }
  }

}
