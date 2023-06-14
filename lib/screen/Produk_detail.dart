import 'dart:convert';

import 'package:flutter/material.dart';
import '../auth/auth.dart';
import '../component/navigationbar.dart';
import 'HomePage1.dart';
import 'HomePage.dart';
import 'package:http/http.dart' as http;

class Produk_detail extends StatefulWidget {
  final int data;
  final String image;
  final int stock;
  final String harga;

  const Produk_detail({Key ?key, @required this.data = 0, this.image ="", this.stock = 0, this.harga =""}) : super(key: key);

  @override
  _Produk_detailState createState() => _Produk_detailState();
}

class _Produk_detailState extends State<Produk_detail> {
  
  

  final AuthController authController = AuthController();
  TextEditingController nilai = TextEditingController(text: '1');
  
  String image = '';

  @override
  void initState() {
   
   
    super.initState();
  }

  Future<Map<String, dynamic>> menu() async {
    dynamic accessToken = await authController.getAccessToken();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    try {
      final response = await http.get(
        Uri.parse("http://192.168.0.103:8000/api/market/${widget.data}"),
        headers: headers,
      );
      print(jsonDecode(response.body));
      Map<String, dynamic> responseData = jsonDecode(response.body) as Map<String, dynamic>;
      image = responseData['menu']['image'];
  
      return responseData;
    } catch (e) {
      print("Terjadi kesalahan");
      throw e;
    }
  }

 
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
         leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.deepOrange, 
          ),
          onPressed: () {
            Navigator.pushReplacement(context,MaterialPageRoute(
            builder: (context) => HomePage(                     
            ),
            ),
            );
            
          },
        ),
        title: Text(
          "E-buddy",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: 
      FutureBuilder(
        future: menu(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final responseData = snapshot.data!;
            
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 3),
                  Center(
                    child: Container(
                      
                      height: 200,
                      width: 450,
                      
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('http://192.168.0.103:8000/storage/${responseData['menu']['image']}'),
                            fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 70,
                    width: 400,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0), 
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                
                          Text('Rp.${responseData['menu']['harga']}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          )),
                          SizedBox(height: 10),
                          Text(responseData['menu']['nama_makanan'],
                          style: TextStyle(
                            fontWeight: FontWeight.w400
                          )),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                    thickness: 0.4,
                  ),
                  SizedBox(height: 2),
                  Container(
                    height: 500,
                    width: 400,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Detail Produk",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text("Kondisi"),
                              SizedBox(width: 96),
                              Text("Segar"),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.2,
                          ),
                          Row(
                            children: [
                              Text("Min.Pemesanan"),
                              SizedBox(width: 40),
                              Text("1 Buah"),
                            ],
                          ),
                          Divider(
                            color: Colors.black,
                            thickness: 0.2,
                          ),
                          SizedBox(height: 20),
                          Text("Deskripsi Produk",style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),
                          SizedBox(height: 20),
                          Text(responseData['menu']['deskripsi']),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Terjadi kesalahan"),
            );
          } else {
            return Center(
              child: Text("Tidak ada data"),
            );
          }
        },
      ),
      bottomNavigationBar: CustomNavigationBar(image: widget.image,harga : widget.harga, stock : widget.stock, id : widget.data),
    );
  }

  
}
