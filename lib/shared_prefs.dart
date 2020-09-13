import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  //Shared preferences nesnesi oluşmuşsa aynı nesneyi tekrar çağırıyoruz yoksa sıfırdan oluşturuyoruz
  static SharedPreferences _prefs;
  static initialize() async {
    if (_prefs != null) {
      return _prefs;
    } else {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  static Future<bool> saveCities(List<String> cities) async {
    return await _prefs.setStringList('cities', cities);
  }

  static Future<bool> saveCity(String city) async {
    return await _prefs.setString('city', city);
  }

  //Shared üzerinde kayıtlı olan bütün verileri siler
  static Future<void> sharedClear() async {
    return _prefs.clear();
  }

  static List<String> getCities() {
    return _prefs.getStringList('cities');
  }

  static String getCity() {
    return _prefs.getString('city');
  }
}
