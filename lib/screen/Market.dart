import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'Produk_detail.dart';
import '../auth/auth.dart';


class Market extends StatelessWidget {
 

  final AuthController authController = AuthController();
 
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
    return Scaffold(
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
        actions: [
          IconButton(onPressed : () {}, icon: Icon(Icons.shopping_cart),color: Colors.deepOrange,)
        ],
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
      future: menu(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }else{
          return SingleChildScrollView( 
          child: Column(
            children: [
              SizedBox(height: 3),
              GridView.builder(
                shrinkWrap: true, 
                physics: NeverScrollableScrollPhysics(), 
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: snapshot.data['menu'].length,
                itemBuilder: ((context, index) => Padding(
                  padding: EdgeInsets.all(1.5),
                  child: GestureDetector(
                    onTap : ()  {
                      
                      Navigator.push(
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
    ),
    );
  }
}