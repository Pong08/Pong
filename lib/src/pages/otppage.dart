import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/src/pages/pincodepage.dart';

class RegisterOTP extends StatefulWidget {
  final String p_customercode;

  RegisterOTP({Key key, this.p_customercode}) : super(key: key);

  @override
  _RegisterOTPState createState() => _RegisterOTPState();
}

class _RegisterOTPState extends State<RegisterOTP> {
  int _number = 0;
  // ignore: non_constant_identifier_names
  void GenerateRandomNumber() {
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);
    setState(() {
      _number = next(100000, 999999);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          "การลงทะเบียนใหม่",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'กรุณาใส่รหัสผ่านที่ได้รับผ่านโทรศัพท์มือถือภายในระยะเวลา 5 นาที หากท่านไม่ได้รับข้อความภายใน 1 นาที โปรดกดปุ่ม "ขอ OTP อีกครั้ง"',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                height: 50,
                width: 120,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(
                          color: Colors.blueAccent,
                          width: 3.0,
                          style: BorderStyle.solid),
                    ),
                    color: Colors.white,
                    textColor: Colors.blueAccent,
                    child: const Text(
                      "รหัส OTP",
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    padding: EdgeInsets.all(10),
//                onPressed: () {
//                  int min = 100000; //min and max values act as your 6 digit range
//                  int max = 999999;
//                  var randomizer = new Random();
//                  var rNum = min + randomizer.nextInt(max - min);
//
//                  _total = rNum.toString();
//
//                },
                    onPressed: GenerateRandomNumber),
              ),
//              Padding(
//                padding: EdgeInsets.only(top: 40.0),
//              ),

              Column(
                children: <Widget>[
                  Text(
                    '$_number',
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  Divider(
                    height: 0,
                    indent: 85,
                    endIndent: 85,
                    thickness: 2,
                  ),
                ],
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    width: double.infinity,
                    child: RaisedButton(
                      elevation: 4.0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PincodePage(
                                    otpcode: '$_number',
                                    p_customercode: widget.p_customercode)));
                      },
                      color: Colors.blueAccent,
                      padding: EdgeInsets.all(10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'ยืนยัน',
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
        ),
      ),
    );
  }
}
