import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';
import '../auth/auth.dart';
import '../auth/harga.dart';
import '../component/keranjang_component.dart';
import '../component/navigationbarkeranjang.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class Keranjang_ extends StatefulWidget {
 

  Keranjang_({Key? key}) : super(key: key);

  @override
  _KeranjangState createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang_> {
   final AuthController authController = AuthController();
  Future order(int id_pesan, int id_menu) async {
    dynamic accessToken = await authController.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    final response = await http.post(
      Uri.parse("http://192.168.0.103:8000/api/order"),
      headers: headers,
      body: jsonEncode({
        'order': id_pesan,
        'id': id_menu,
      }),
    );
    print(response.body);
    return json.decode(response.body);
  }

  Future delete(int id) async {
    dynamic accessToken = await authController.getAccessToken();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
      final response = await http.delete(
        Uri.parse("http://192.168.0.103:8000/api/keranjang/delete/$id"),
        headers: headers,
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

  
      final response = await http.get(
        Uri.parse("http://192.168.0.103:8000/api/keranjang/show/$id"),
        headers: headers,
      );
      
      return  jsonDecode(response.body);
     
    
  }
  

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.deepOrange,
            ),
            onPressed: () {
           
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Market",
            style: TextStyle(
              color: Colors.deepOrange,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          backgroundColor: Colors.white,
        ),
        body: FutureBuilder(
          future: keranjang(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
                final keranjangList = snapshot.data['keranjang'] as List<dynamic>;
              return ListView.builder(
                itemCount: keranjangList.length,
                itemBuilder: (context, index) => 
              
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    height: 100,
                            
                   child : 
                    Row(
                     
                      children: [
                        Container(
                        
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            image :DecorationImage (
                              image:  NetworkImage('http://192.168.0.103:8000/storage/${snapshot.data['keranjang'][index]['menu']['image']}'),
                               fit: BoxFit.cover,
                            ) 
                           
                          ),
                        ),
                       
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              
                              Text('${snapshot.data['keranjang'][index]['menu']['nama_makanan']}',style: 
                              TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              )),
                              SizedBox(height: 10),
                              Text('${snapshot.data['keranjang'][index]['total_barang']}'),
                               SizedBox(height: 10),
                              Text('${snapshot.data['keranjang'][index]['total_harga']}',style: TextStyle(
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.w800
                                ,
                                fontSize: 13
                              ),),
                            ],
                          ),
                        ),  
                     
                        Container(
                          
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               IconButton(onPressed: () {
                                 order(snapshot.data['keranjang'][index]['id'], snapshot.data['keranjang'][index]['menu_id']).then((value) {
                                   if(value.containsKey("succes")) {
                                 
                                     String succes = value['succes'];
                                     setState((){});
                                    ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${succes}'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                   }
                                 });

                              }, icon: Icon(Icons.payments_sharp),color: Colors.amber,),
                            IconButton(onPressed: () {
                                  delete(snapshot.data['keranjang'][index]['id']).then((value) {
                                   if(value.containsKey("succes")) {
                                     
                                     String succes = value['succes'];
                                     setState(() {});
                                       
                                    
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${succes}'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                   }
                                 }
                                 
                                 );
                              }, icon: Icon(Icons.delete),color: Colors.red,)
                            ]
                            ),
                        )
                      ],
                    )
                  ),
                ),
                );
            };
          },
        ),
   

    );
  }
}
