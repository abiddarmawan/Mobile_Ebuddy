import 'dart:async';
import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http; 
class Registrasi extends StatefulWidget {
  @override
  State<Registrasi> createState() => _RegistrasiState();
}

class _RegistrasiState extends State<Registrasi> {
    final _formKey = GlobalKey<FormState>();

    TextEditingController name = TextEditingController();

    TextEditingController email = TextEditingController();

    TextEditingController password = TextEditingController();

   Future daftar() async  {
       final  respon = await  http.post(Uri.parse("http://192.168.0.103:8000/api/register"),body: {
         'name' : name.text,
         'email' : email.text,
         'password' : password.text
       });
         
      return  json.decode(respon.body) ;
      
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
          "Register",
          style: TextStyle(
            color: Colors.deepOrange,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 100),
           Container(
            padding: EdgeInsets.all(20),
            height: 500,
            width: 500,
            
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 20),
                  TextFormField(
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                    },
                    controller: name,
                    decoration: InputDecoration(
                      labelText: 'Name',
                       contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      prefixIcon: Icon(Icons.person),
                      ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: email,
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                    },
                      autocorrect: false,
                      
                      keyboardType: TextInputType.emailAddress,  
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                        labelText: "email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.email),
                      )
                ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: password,
                    validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                    },
                      autocorrect: false,
                      obscureText: true,
                      keyboardType: TextInputType.text,  
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                        labelText: "Passoword",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        ),
                        prefixIcon: Icon(Icons.lock),
                      )
                   ),
                   SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        daftar().then((value) {
                          if (value.containsKey("errors")) {
                            Map<String, dynamic> errors = value["errors"];
                            errors.forEach((key, value) {
                              List<dynamic> errorList = value;
                              errorList.forEach((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("$key: $error"),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              });
                             
                            });
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Berhasi membuat akun, silahkan login"),
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                          setState(() {
                               name.clear();
                               password.clear();
                               email.clear();
                             });
                        });
                      }
                    },
                    child: Text('Registrasi'),
                  ),

                   SizedBox(height: 20),
                   GestureDetector(
                        onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                              context, '/login', (route) => true);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Sudah Punya Akun?"),
                            Text("Login",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)
                              ),
                          ]
                          ),
                      ),
                  ]
                ),
           ),
           )
        ],
      )
    );
  }
}