import 'dart:convert';
import 'package:aplikasi_fluter/screen/Keranjang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'Produk_detail.dart';
import 'imb.dart';
import 'Form_imb.dart';
import 'Keranjang.dart';
import 'login.dart';

import '../auth/auth.dart';

import 'Market.dart';

class Home extends StatefulWidget {
   const Home({ Key? key }) : super(key: key);

 
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
    final AuthController authController = AuthController();
   @override
  void initState() {
 
    super.initState();
  }
  Future menu() async {
      
    dynamic accessToken = await authController.getAccessToken();
    
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    
    try {
      final response = await http.get(Uri.parse("http://192.168.0.103:8000/api/market"), headers: headers);
      print(jsonDecode(response.body));
      return  jsonDecode(response.body) ;
    } catch (e) {
      print("Terjadi kesalahan");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: menu(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else{
          return SingleChildScrollView( 
          child: Column(
            children: [
              SizedBox(height: 2),
              Container(
                padding: EdgeInsets.all(20),
                height: 200,
                width: 450,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/background1.jpg'),
                    fit: BoxFit.cover,
                  ),
               
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                 
                  children: [
                    Text(
                      "Halo Selamat Datang Di E-buddy",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Hai Apakah kamu siap menjalani hari ini ?",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              Container(
                color : Colors.white,
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(
                              builder: (context) => Market(
                                
                              ),
                            ),
                            );
                          },
                         icon: Icon(Icons.store_mall_directory,
                             color: Colors.deepOrange),
                        ),
                        Text(
                          "Market",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                              Navigator.push(context,MaterialPageRoute(
                              builder: (context) => Keranjang_(),
                            ),
                            );
                          },
                           icon: Icon(Icons.shopping_basket_sharp,color: Colors.deepOrange)
                        ),
                        Text(
                          "Keranjang",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                             Navigator.push(context,MaterialPageRoute(
                              builder: (context) => Imb(
                                
                              ),
                            ),
                            );
                          },
                           icon: Icon(Icons.calculate_outlined, color : Colors.deepOrange)
                        ),
                        Text("Menghitung",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("IMB",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                              Navigator.push(context,MaterialPageRoute(
                              builder: (context) => TampilanIMB(),
                            ),
                            );
                          },
                           icon: Icon(Icons.note_alt_outlined, color : Colors.deepOrange)
                        ),
                        Text("Catatan",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text("IMB",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 3),
              GridView.builder(
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(), 
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data['menu'].length,
                itemBuilder: ((context, index) => 
                Padding(
                  padding: EdgeInsets.all(1.5),
                  child: GestureDetector(
                    onTap : ()  {
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Produk_detail(
                            data: snapshot.data['menu'][index]['id'],
                            image: "http://192.168.0.103:8000/storage/${snapshot.data['menu'][index]['image']}",
                            stock: snapshot.data['menu'][index]['jumlah_barang'],
                            harga: snapshot.data['menu'][index]['harga'],
                           
                          ),
                        ),
                      );

                    },
                  child : Container(
                    color: Colors.white,
                      
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 2,
                            child: FadeInImage.assetNetwork(
                                placeholder: 'images/placeholder_image.png',
                                image: snapshot.connectionState == ConnectionState.done
                                  ? 'http://192.168.0.103:8000/storage/${snapshot.data['menu'][index]['image']}'
                                  : '',
                                 fit: BoxFit.cover,
                                
                              ),
                          ),
                        ),
                          SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child:   Text(snapshot.data['menu'][index]['nama_makanan']),
                          ),
                         SizedBox(height: 5),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child:   Text('Rp.${snapshot.data['menu'][index]['harga']}',
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold

                            ),),

                          ),
                          SizedBox(height: 4)
                         

                        ]
                        ),
                    ),
                )
                  )
                ),
              ),
            ],
          ),
      );
        }    
      },
    );
  }
}
