import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../auth/harga.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigationbarkeranjang.dart';

class ComponentKeranjang extends StatefulWidget {
   double offsetX;
  final String namaMakanan;
   bool isChecked;
  final String harga;
  final String image;
  final Function(bool isChecked,int nilai) onCheckboxChanged;
 final ValueSetter<bool> penambahan;


  ComponentKeranjang({
    Key? key,
    this.offsetX = 0.0,
    this.namaMakanan = "",
    this.isChecked = false,
    this.harga = "",
    this.image = '',
    required this.onCheckboxChanged,
    required this.penambahan,
  }) : super(key: key);

  @override
  _ComponentKeranjangState createState() => _ComponentKeranjangState();
}

class _ComponentKeranjangState extends State<ComponentKeranjang> {
  final Totalharga hargapasti = Totalharga();
   TextEditingController nilai = TextEditingController(text: '1');
    int counter = 1;
  void updateTotal(bool isChecked)  {
      
    // int currentValue = int.tryParse(nilai.text) ?? 1;
    widget.onCheckboxChanged(isChecked,counter);
     // Panggil callback onCheckboxChanged
  }

   void tambahNilai() {
      setState(() {
          counter++;
          // int currentValue = int.tryParse(nilai.text) ?? 1;
          // nilai.text = (currentValue + 1).toString();
           if(widget.isChecked) {
              widget.penambahan(true);
            }
        });
  }

  void kurangiNilai() {
    setState(() {
      // int currentValue = int.tryParse(nilai.text) ?? 1;
      if (counter > 1) {
        counter--;
        // nilai.text = (currentValue - 1).toString();
         if(widget.isChecked) {
              widget.penambahan(false);
        }
      }
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          widget.offsetX+= details.delta.dx;
        });
      },
      child: Stack(
        children: [
          Transform.translate(
            offset: Offset(widget.offsetX < 0 ? widget.offsetX / 5 : 0, 0),
            child: Container(
              width: 500,
              height: 100,
              child: Row(
                children: [
                  Checkbox(
                    value: widget.isChecked,
                    onChanged: (bool? value) {
                      updateTotal(value ?? false);
                      setState(() {
                        widget.isChecked = value ?? false;
                      });
                    },
                  ),
                  Image.network(
                    'http://192.168.0.103:8000/storage/${widget.image}',
                    width: 100,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            '${widget.namaMakanan}',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Rp.${widget.harga}',
                          ),
                        ),
                      ),
                    ],
                  ),
                   Container(
                     
                      child: Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                                 IconButton(
                            icon: Icon(Icons.add,size: 15,),
                            onPressed: tambahNilai
                          ),
                          Text(
                            counter.toString(),
                            style: TextStyle(fontSize: 15),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove,size: 15,),
                            onPressed: kurangiNilai
                          ),
                                ],
                              ),
                      ),
                                 ),
                  
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: widget.offsetX < 0 ? 300 : double.infinity,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: Colors.red,
              child: Text(
                "Delete",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
