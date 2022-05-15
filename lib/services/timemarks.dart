import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class TimeMarksAPIs {
  static const baseURL = 'https://timemarks.in/admin-panel-v2/webservices';

  static Future<dynamic> getStudentProfileData(userID) async {
    String url = baseURL + '/app2_user_profile.php';
    var response = await http.post(
      url,
      body: {
        "user_id": userID,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var jsonResponse = convert.jsonDecode(response.body);
      // print(jsonResponse);
      return jsonResponse;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return null;
    }
  }
}
