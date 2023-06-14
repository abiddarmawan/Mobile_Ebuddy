import '../auth/harga.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NavigationBarKeranjang extends StatelessWidget {
  final ValueNotifier<double> totalHargaNotifier;

  NavigationBarKeranjang({Key? key, required this.totalHargaNotifier}) : super(key: key);

  String formatCurrency(double value) {
    var format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
    return format.format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      child: ValueListenableBuilder<double>(
        valueListenable: totalHargaNotifier,
        builder: (BuildContext context, double value, Widget? child) {
          String totalhargac = formatCurrency(value);
          return Row(
            children: [
              Text('$totalhargac'),
            ],
          );
        },
      ),
    );
  }
}
