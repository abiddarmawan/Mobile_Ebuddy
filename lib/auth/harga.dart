import 'package:shared_preferences/shared_preferences.dart';

class Totalharga {

  Future<void> saveharga(double harga) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('total_harga', harga);
  
  }

    Future<double?> getharga() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        return prefs.getDouble('total_harga');
    }

  Future<void> clearData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('total_harga');
   
  }
   
}

