import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_scanner/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  bool _isLoading = false;
  signIn(String email, String pass)async
  {
    String url = "https://app.bateriaswillard.com:3001/login";
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map body = {
      "user" : email,
      "password": pass,
      "app" : "VISITAS"
    };
    //var jsonResponse;
    var res = await http.post(Uri.parse(url), body: body);
    if(res.statusCode == 200)
    {
      var jsonResponse = json.decode(res.body);
      String token = jsonResponse["data"]["access_token"];

      print(token);
      
      print("Response :  ${res.statusCode}");
      
      print("Response :  ${res.body}");

      if(jsonResponse != null)
      {
        setState(() {
          _isLoading = false;
        });
        sharedPreferences.setString("token", token);

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => HomePage()),
            (Route<dynamic> route) => false);
      }else{
        setState(() {
          _isLoading = false;
        });
        print("Response :  ${res.body}");
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column
              (
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('QR_WILLARD', style: TextStyle(fontSize: 42), 
                ),
                SizedBox(
                  height:60
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                              hintText: 'User')
                              ),
                        ),
                         Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                          controller: _passController,
                          obscureText: true,
                          decoration: InputDecoration(
                          hintText: 'Password')
                          ),
                    ),
                     SizedBox(
                          height:20
                        ),
                      ],
                    ),
                    
                  ),
                ),
                SizedBox(
                          height:20
                        ),
                SizedBox(
                  height:40,
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton(
                    color:Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Text('Iniciar Sesion', 
                    style: TextStyle(fontSize: 22, color: Colors.white),),
                    onPressed: _emailController.text == "" || _passController == "" ? 
                    null:()
                    {
                      setState(() {
                        _isLoading = true;
                      });
                      signIn(_emailController.text, _passController.text);
                    } ,),
                ),
                SizedBox(
                          height:20
                        ),
                        FlatButton(onPressed: () {}, child: Text('¿Olvido su contraseña?'))
                ],
              ),
        ),
      ),
    );
  }
}