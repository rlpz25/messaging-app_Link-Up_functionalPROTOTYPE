import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{

  static String userIsLoggedKey = 'ISUSERLOGGEDIN';
  static String userNombreKey = 'USERNOMBREKEY';
  static String userDistintivoKey = 'USERDISTINTIVOKEY';
  static String userCorreoKey = 'USERCORREOKEY';

  static Future<bool> saveUserSP(bool isUserLogged) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(userIsLoggedKey, isUserLogged);
  }

  static Future<bool> limpiarPreferencias() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.clear();
  }

  static Future<bool> saveNombre(String nombre) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userNombreKey, nombre);
  }

  static Future<bool> saveDistintivoSP(String distintivo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userDistintivoKey, distintivo);
  }

  static Future<bool> saveCorreo(String correo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(userCorreoKey, correo);
  }

  static Future<bool> getUserSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(userIsLoggedKey);
  }

  static Future<String> getNombreSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNombreKey);
  }

  static Future<String> getDistintivoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userDistintivoKey);
  }

  static Future<String> getCorreoSP() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userCorreoKey);
  }

}