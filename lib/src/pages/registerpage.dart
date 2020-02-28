import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/otppage.dart';
import 'package:image_picker/image_picker.dart';

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
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
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
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: const Alignment(0.6, 0.6),
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 180, left: 180),
                          child: IconButton(
                            color: Colors.black87,
                            icon: Icon(Icons.camera_alt),
                            onPressed: getImage,
                          ),
                        ),
                        ClipOval(
                          child: SizedBox(
                            width: 200,
                            height: 200,
                            child: _image == null
                                ? CircleAvatar(
                              backgroundColor: Colors.grey[100],
                                    child: Icon(
                                      Icons.account_circle,
                                      size: 200,
                                      color: Colors.white,
                                    ),
                                  )
                                : Image.file(_image,fit: BoxFit.cover,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.account_circle),
                        hintText: 'ชื่อ - นามสกุล',
                        contentPadding:
                            EdgeInsets.fromLTRB(1.0, 1.0, 1.0,1.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.credit_card),
                        hintText: 'เลขประจำตัวประชาชน',
                        contentPadding:
                            EdgeInsets.fromLTRB(1.0, 1.0, 1.0,1.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'เบอร์โทรศัพท์',
                        contentPadding:
                            EdgeInsets.fromLTRB(1.0, 1.0, 1.0,1.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                    ),
                    SizedBox(
                      height: 0.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 20.0),
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 4.0,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RegisterOTP()));
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
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
