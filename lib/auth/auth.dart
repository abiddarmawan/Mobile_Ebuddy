import 'package:shared_preferences/shared_preferences.dart';

class AuthController {

  Future<void> saveAccessToken(String accessToken,int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', accessToken);
    prefs.setInt('user_id', id);
  }

  Future<String?> getAccessToken() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs.getString('access_token');
  }
  Future<int?> getUserId() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getInt('user_id');
  }
  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('user_id');
    prefs.remove('access_token');
   
  }
}
