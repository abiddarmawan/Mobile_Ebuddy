import 'package:aplikasi_fluter/auth/auth.dart';
import 'package:aplikasi_fluter/screen/login.dart';
import 'package:flutter/material.dart';
import '/screen/HomePage1.dart';
import '/screen/nyoba.dart';
import '/screen/order.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class  HomePage extends StatefulWidget {
   const HomePage({ Key? key }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController authController = AuthController();
  late int index;
  List<Widget> ShowScreen = [
    Home(),  
    order() 
    
  ];

   Future delete() async {
    dynamic accessToken = await authController.getAccessToken();
  

    final headers = {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };

    try {
      final response = await http.post(Uri.parse("http://192.168.0.103:8000/api/logout"), headers: headers);
    
      return jsonDecode(response.body);
    } catch (e) {
      print("Terjadi kesalahan");
    }
  }
   void clear() async  {
       await authController.clearData();
    
      
    }
 @override
  void initState() {
    index = 0;
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        
        elevation: 0,
        title: Text(
           "E-buddy",
           style: TextStyle(
             color: Colors.deepOrange,
             fontSize: 22,
             fontWeight: FontWeight.w700
           ),
         ),
         backgroundColor: Colors.white,
            actions: [
            PopupMenuButton<String>(
              color: Colors.deepOrange,
              
              onSelected: (value) {
                if (value == 'logout') {
                  delete().then((value){
                    if(value.containsKey('message')) {
                      clear();
                      Navigator.pushAndRemoveUntil(
                             context,
                            MaterialPageRoute(builder: (context) => Login()),
                                  (_) => false,
                      );

                    }
                  });
                  
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
      ),
      body : ShowScreen[index], 
      backgroundColor: Colors.grey,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: Colors.black,
        selectedItemColor: Colors.deepOrange,
        currentIndex: index,
        onTap: (value) {
          print(value);
          setState(() {
            index = value;

          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "home"),
          BottomNavigationBarItem(icon: Icon(Icons.history),label: "history")
        ]
        ),
    );
  }
}