import 'dart:convert';

import 'package:flutter/material.dart';
import '../auth/auth.dart';
import 'package:http/http.dart' as http;

class CustomNavigationBar extends StatefulWidget {
  final String image;
  final int stock;
  final String harga;
  final int id;

  const CustomNavigationBar({
    Key? key,
    this.image = "",
    this.harga = "",
    this.stock = 0,
    this.id = 0,
  }) : super(key: key);

  @override
  _CustomNavigationBarState createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  final AuthController authController = AuthController();

  TextEditingController nilai = TextEditingController(text: '1');

   Future order() async {
    dynamic accessToken = await authController.getAccessToken();
    dynamic id = await authController.getUserId();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    final response = await http.post(
      Uri.parse("http://192.168.0.103:8000/api/order/${widget.id}"),
      headers: headers,
      body: jsonEncode({
        'id': id,
        'total_barang' : int.tryParse(nilai.text) ?? 1,
      }),
    );

    return json.decode(response.body);
  }
  
  Future keranjang() async {
    dynamic accessToken = await authController.getAccessToken();
    dynamic id = await authController.getUserId();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    final respon = await http.post(
      
      Uri.parse('http://192.168.0.103:8000/api/keranjang/${widget.id}'),
      body: jsonEncode({
        'id': id,
        'total_barang': int.tryParse(nilai.text) ?? 1,
      }),
      headers: headers,
    );
    print(respon.body);
      
    return json.decode(respon.body) ;
  }

  void tambahNilai() {
    int a = int.tryParse(nilai.text) ?? 1;
    if (a < widget.stock) {
    setState(() {
      int currentValue = int.tryParse(nilai.text) ?? 1;
      nilai.text = (currentValue + 1).toString();
    });
    }
   
  }

  void kurangiNilai() {
    setState(() {
      int currentValue = int.tryParse(nilai.text) ?? 1;
      if (currentValue > 1) {
        nilai.text = (currentValue - 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 30),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 250,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          height: 100,
                          child: Row(
                            children: [
                              Image.network('${widget.image}'),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('Rp ${widget.harga}'), 
                                  ),
                                 
                                  SizedBox(height: 20),
                                  Text('Stock ${widget.stock}'),
                                ],
                              ),
                              SizedBox(width: 80),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start, 
                                children: [
                                  IconButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.cancel_outlined))
                                ]),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jumlah"),
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: tambahNilai,
                                      child: Icon(Icons.add, color: Colors.black),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(0.0),
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (Set<MaterialState> states) {
                                            return BorderSide(
                                              color: Colors.black,
                                              width: 0,
                                            );
                                          },
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: nilai,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: kurangiNilai,
                                      child: Icon(Icons.remove, color: Colors.black),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(0.0),
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (Set<MaterialState> states) {
                                            return BorderSide(
                                              color: Colors.black,
                                              width: 0,
                                            );
                                          },
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 50,
                          width: 393,
                          child: ElevatedButton(
                            onPressed: () {
                              int a = int.tryParse(nilai.text) ?? 1;
                             
                              if(nilai.text.isNotEmpty && a < widget.stock) {
                                 order().then((value) {
                                if (value.containsKey("success")) {
                                  Navigator.pop(context);
                                  String succes = value['success'];
                                
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${succes}'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              });
                              }else {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Jumlah Barang Melebihi stock"),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                              }
                             
                            },  
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(150, 20),
                              ),
                            ),
                            child: Text(
                              "Beli Sekarang",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text(
                "Beli Langsung",
                style: TextStyle(color: Colors.deepOrange),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                side: MaterialStateProperty.resolveWith<BorderSide>(
                  (Set<MaterialState> states) {
                    return BorderSide(
                      color: Colors.deepOrange,
                      width: 2.0,
                    );
                  },
                ),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(150, 20),
                ),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 30),
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Container(
                    height: 250,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.white,
                          height: 100,
                          child: Row(
                            children: [

                              Image.network('${widget.image}'),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                   Padding(
                                    padding: EdgeInsets.only(left: 15),
                                    child: Text('Rp ${widget.harga}'), 
                                  ),
                                 
                                  SizedBox(height: 20),
                                  Text('Stock ${widget.stock}'),

                                  
                                ]
                              ),
                              SizedBox(width: 80),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start, 
                                children: [
                                  IconButton(onPressed: () {
                                    Navigator.pop(context);
                                  }, icon: Icon(Icons.cancel_outlined))
                                ]),
                              ),
                          
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Jumlah"),
                            SizedBox(
                              width: 100,
                              height: 30,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: tambahNilai,
                                      child: Icon(Icons.add, color: Colors.black),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(0.0),
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (Set<MaterialState> states) {
                                            return BorderSide(
                                              color: Colors.black,
                                              width: 0,
                                            );
                                          },
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextField(
                                      controller: nilai,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: kurangiNilai,
                                      child: Icon(Icons.remove, color: Colors.black),
                                      style: ButtonStyle(
                                        elevation: MaterialStateProperty.all<double>(0.0),
                                        padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                                        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                        side: MaterialStateProperty.resolveWith<BorderSide>(
                                          (Set<MaterialState> states) {
                                            return BorderSide(
                                              color: Colors.black,
                                              width: 0,
                                            );
                                          },
                                        ),
                                        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(0),
                                          ),
                                        ),
                                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Container(
                          height: 50,
                          width: 393,
                          child: ElevatedButton(
                            onPressed:  () {
                              int a = int.tryParse(nilai.text) ?? 1;
                              if(nilai.text.isNotEmpty && a < widget.stock) {
                                keranjang().then((value) {
                                if (value.containsKey("success")) {
                                  Navigator.pop(context);
                                  String succes = value['success'];
                                
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${succes}'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              });
                              }else{ 
                                  Navigator.pop(context);
                                   ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Jumlah Barang Melebih Stock"),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                              }
                                
                            } ,
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              fixedSize: MaterialStateProperty.all<Size>(
                                Size(150, 20),
                              ),
                            ),
                            child: Text(
                              "Tambah Keranjang",
                              style: TextStyle(color: Colors.white,fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: Text(
                "Keranjang",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(150, 20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
