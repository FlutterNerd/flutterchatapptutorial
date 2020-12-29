import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userNameKey = "USERNAMEKEY";
  static String userLoggedInKey = "USERISLOGGEDIN";
  static String userEmailKey = "USEREMAILKEY";

  // save data
  Future<bool> saveIsLoggedIn(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool(userLoggedInKey, isLoggedIn);
  }

  Future<bool> saveUserName(String getUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, getUsername);
  }

  Future<bool> saveUserEmail(String getUseremail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userEmailKey, getUseremail);
  }

  // get data

  Future<bool> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userLoggedInKey);
  }

  Future<String> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userEmailKey);
  }
}
