import 'package:aplikasi_fluter/auth/auth.dart';
import '../auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import library untuk inisialisasi locale data
import 'package:http/http.dart' as http;
import 'dart:convert';

class TampilanIMB extends StatefulWidget {
  const TampilanIMB({Key? key}) : super(key: key);

  @override
  _TampilanIMBState createState() => _TampilanIMBState();
}

class _TampilanIMBState extends State<TampilanIMB> {
  final AuthController authController = AuthController();
  Future delete(int id) async {
    dynamic accessToken = await authController.getAccessToken();
  

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    try {
      final response = await http.delete(Uri.parse("http://192.168.0.103:8000/api/imb/delete/$id"), headers: headers);
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (e) {
      print("Terjadi kesalahan");
    }
  }
  Future imb() async {
    dynamic accessToken = await authController.getAccessToken();
    dynamic id = await authController.getUserId();

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    try {
      final response = await http.get(Uri.parse("http://192.168.0.103:8000/api/imb/show/$id"), headers: headers);
      print(jsonDecode(response.body));
      return jsonDecode(response.body);
    } catch (e) {
      print("Terjadi kesalahan");
    }
  }

  @override
  void initState() {
    super.initState();
    
    initializeDateFormatting('id_ID', null);
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
          "BMI",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: imb(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }else if (!snapshot.hasData || snapshot.data['user'].isEmpty){ 
           return  Center(
              child: Text("Kamu Belum menghitung BMI"),
            );
          }else {
            final user = snapshot.data['user'] as List<dynamic>;

            return ListView.builder(
              itemCount: user.length,
              itemBuilder: (context, index) {
                String date = snapshot.data['user'][index]['created_at'];
                DateTime dateTime = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ").parse(date);
                String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(dateTime);

                return Padding(
                  padding: EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: (){
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            height: 50,
                            color : Colors.white,
                            child:  IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  delete(snapshot.data['user'][index]['id']).then((value) {
                                    if(value.containsKey('succes')) {
                                      
                                      String succes = value['succes'];
                                      setState(() {});
                                      ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('${succes}'),
                                        duration: Duration(seconds: 3),
                                      ),
                                    );  
                                    }
                                  });
                                  Navigator.pop(context); 
                                },
                              ),
                          )
                        );
                    },
                    child: Container(
                      height: 270,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.black, width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "CARD BMI",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Berat Badan"),
                                      Text('${snapshot.data['user'][index]['berat_badan']}'),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tinggi Badan"),
                                      Text('${snapshot.data['user'][index]['tinggi_badan']}'),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("BMI"),
                                      Text('${snapshot.data['user'][index]['total']}'),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Status"),
                                      Text('${snapshot.data['user'][index]['status']}'),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Tanggal"),
                                      Text('${formattedDate}'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
