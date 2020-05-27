import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/checkregister.dart';
import 'package:flutter_app/src/pages/otppage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //แก้เอาคำว่า  debug  ออก
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  Image image;
  var _customercodeField = TextEditingController();
  var _mobilenoField = TextEditingController();
  var _arnameField = TextEditingController();

  File _image;

  Future getImage() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.camera);
    if (_image != null) {
      setState(() {
        image = Image.file(
          _image,
          fit: BoxFit.cover,
        );
      });
      ImageSharedPrefs.saveImageToPrefs(
          ImageSharedPrefs.base64String(_image.readAsBytesSync()));
    } else {
      print('เกิดข้อผิดพลาด!');
    }
  }

  Future chooseImage() async {
    var _image = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (_image != null) {
      setState(() {
        image = Image.file(
          _image,
          fit: BoxFit.cover,
        );
      });
      ImageSharedPrefs.saveImageToPrefs(
          ImageSharedPrefs.base64String(_image.readAsBytesSync()));
    } else {
      print('เกิดข้อผิดพลาด!');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
          title: Text(
            'การลงทะเบียน',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(
                height: 15.0,
              ),
              Stack(
                alignment: const Alignment(0.6, 0.6),
                children: [
                  ClipOval(
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: _image == null
                          ? CircleAvatar(
                              backgroundColor: Colors.grey[100],
                              child: Icon(
                                Icons.account_circle,
                                size: 150,
                                color: Colors.white,
                              ),
                            )
                          : Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  IconButton(
                    color: Colors.black87,
                    icon: Icon(Icons.camera_alt),
                    onPressed: getImage,
                  ),
                  SizedBox(
                    width: 75,
                  ),
                  IconButton(
                    color: Colors.black87,
                    icon: Icon(Icons.photo_library),
                    onPressed: chooseImage,
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.credit_card),
                  hintText: 'เลขประจำตัวประชาชน',
                  contentPadding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                controller: _customercodeField,
              ),
              SizedBox(
                height: 20.0,
              ),
              TextField(
                autofocus: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone),
                  hintText: 'เบอร์โทรศัพท์',
                  contentPadding: EdgeInsets.fromLTRB(1.0, 1.0, 1.0, 1.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
                controller: _mobilenoField,
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 4.0,
                      onPressed: () async {
                        final customercode = _customercodeField.text;
                        final mobileno = _mobilenoField.text;

                        final result =
                            await AuthService().login(customercode, mobileno);

                        if (result == true) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      RegisterOTP(p_customercode: customercode)));
                        } else {
                          showDialog<void>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                content: Text('กรุณากรอกข้อมูลให้ถูกต้อง'),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(dialogContext)
                                          .pop(); // Dismiss alert dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      color: Colors.blueAccent,
                      padding: EdgeInsets.all(12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'ลงทะเบียน',
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1.5,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
const IMAGE_KEY = 'IMAGE_KEY';

class ImageSharedPrefs {
  static Future<bool> saveImageToPrefs(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setString(IMAGE_KEY, value);
  }

  static Future<bool> emptyPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.clear();
  }

  static Future<String> loadImageFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(IMAGE_KEY);
  }

  // encodes bytes list as string
  static String base64String(Uint8List data) {
    return base64Encode(data);
  }

  // decode bytes from a string
  static imageFrom64BaseString(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }
}