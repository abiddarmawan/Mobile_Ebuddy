import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth/harga.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Harga {
    final Totalharga hargapasti = Totalharga();

    String totalhargac = "";
    void totalharga() async {
      double? totalHarga = await hargapasti.getharga();
      if(totalhargac == null) {
            totalhargac = "Rp";
      }
          
      var format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
      String hasil = format.format(totalHarga);
      totalhargac = hasil;
      
        
    }

    String? getharga() {
      return totalhargac;
    }
}