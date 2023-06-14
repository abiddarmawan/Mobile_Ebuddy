import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'dart:async';
import '../auth/auth.dart';
import 'imb.dart';
class Imb extends StatelessWidget {
   Imb({ Key? key }) : super(key: key);
    final _formKey = GlobalKey<FormState>();
  TextEditingController berat = TextEditingController();
  TextEditingController tinggi = TextEditingController();
  final AuthController authController = AuthController();

  Future kalkulator () async {
    dynamic accessToken = await authController.getAccessToken();
    dynamic id = await authController.getUserId();
    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

  final response = await http.post(
      Uri.parse("http://192.168.0.103:8000/api/imb"),
      headers: headers,
      body: jsonEncode({
        'id': id,
        'tinggi_badan' : int.tryParse(tinggi.text) ?? 1,
        'berat_badan' : int.tryParse(berat.text) ?? 1,
      }),
    );

    print(response.body);

    return json.decode(response.body);
    
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
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Container(
                height: 150,
                width: 500,
               decoration: BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('images/bg2.jpg'),
                  fit: BoxFit.cover
                   ),
                  
               ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child:  Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: berat,
                        validator: (value) {
                          if(value == null || value.isEmpty) { 
                            return "Masukan Berat";
                          }
                          return null;
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          labelText: "Berat",
                          labelStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(
                            Icons.scale,
                            color: Colors.deepOrange,
                          ),
                        
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),

                      SizedBox(height: 30),
                     TextFormField(
                        controller: tinggi,
                        validator: (value) {
                          if(value == null || value.isEmpty) { 
                            return "Masukan tinggi";
                          }
                          return null;
                        },
                        autocorrect: false,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                          labelText: "Tinggi",
                          labelStyle: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.bold,
                          ),
                          prefixIcon: Icon(
                            Icons.height,
                            color: Colors.deepOrange,
                          ),
                        
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                              width: 2.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.deepOrange,
                              width: 2.0,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                        ),
                      ),

                      SizedBox(height: 30),
                      Container(
                        height: 50,
                        width: 500,
                        child:   ElevatedButton(
                        onPressed: (){
                          if(_formKey.currentState!.validate()) {
                            kalkulator().then((value) {
                              if(value.containsKey("succes")) {
                                berat.clear();
                                tinggi.clear();
                                 Navigator.push(context,MaterialPageRoute(
                                    builder: (context) => TampilanIMB(),
                                  ),
                                  );
                                String succes = value['succes'];
                                 ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${succes}'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                              }
                            });
                          }
                        },
                        child: Text("Hitung",style: TextStyle(color: Colors.white)),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.deepOrange),
                          
                        ),
                        ),
                      )
                    
                    ])
                  ),
             
              )
              
           
             
            ]
          ),
        )
    );
  }
}