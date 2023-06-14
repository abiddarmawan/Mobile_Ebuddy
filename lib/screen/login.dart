import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../auth/auth.dart';
import 'package:http/http.dart' as http; 
class Login extends StatelessWidget {
  
  final _formKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final AuthController authController = AuthController();
  Future login() async  {
       final  respon = await  http.post(Uri.parse("http://192.168.0.103:8000/api/login"),
       body: {
         'email' : email.text,
         'password' : password.text
       });
        
      return  respon;
      
    }
    void clear() async  {
       await authController.clearData();
      
    }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            "Welcome Back,",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              
            ),
            ),
            SizedBox(height: 10),
            Text(
              "Log In now to continue",
              style: TextStyle(
                fontWeight: FontWeight.w300
              ),
            ),
           SizedBox(height: 10),
          Image(
           image : AssetImage("images/login.jpg"),
           height: 300,
           
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                        labelText: "Email",
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
                          return "Please enter password";
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
                      
                       if (_formKey.currentState!.validate()){
                        
                        login().then((value) {
                              if (value.statusCode == 200) {
                                Map<String, dynamic> data = json.decode(value.body) as Map<String, dynamic>;  
                                String token = data['token']['token'];
                                int id = data['user'];
                                clear();
                                authController.saveAccessToken(token,id); 
                      
                                   Navigator.pushNamedAndRemoveUntil(
                                     context, '/home', (route) => true);     
                              }else{
                                Map<String, dynamic> data = json.decode(value.body) as Map<String, dynamic>; 
                                String error = data['error'];
                                 ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error)),
                                );
                              }
                        });
                       
                }
                    },
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(350, 10), 
                        padding: EdgeInsets.all(20), 
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    child: Text('Login'),
                  ),

                   SizedBox(height: 20),
                   GestureDetector(
                        onTap: () {
                              Navigator.pushNamedAndRemoveUntil(
                                     context, '/registrasi', (route) => true);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Belum punya akun?"),
                            Text("Registrasi",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.blue)
                              ),
                          ]
                          ),
                      ),
              ]
            ),
          )
        ],  
      )
      ),
    );
       
    
    }
}