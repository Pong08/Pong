import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/src/pages/contractpage.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:image_picker/image_picker.dart';

class MyPayIn extends StatefulWidget {
  MyPayIn({Key key, this.mycontractno, this.myhp_overdueamt}) : super(key: key);

  final String mycontractno;
  final String myhp_overdueamt;

  @override
  _MyPayInState createState() =>
      _MyPayInState(this.mycontractno, this.myhp_overdueamt);
}

class _MyPayInState extends State<MyPayIn> {
  final String mycontractno;
  final String myhp_overdueamt;
  _MyPayInState(this.mycontractno, this.myhp_overdueamt);

  var _currencies = [
    'ธนาคารกรุงเทพ',
    'ธนาคารกสิรกรไทย',
    'ธนาคารกรุงไทย',
    'ธนาคารไทยพาณิชย์',
    'ธนาคารทหารไทย',
    'ธนาคารกรุงศรีอยุธยา',
    'ธนาคารออมสิน',
    'ธนาคารธนชาต',
  ];
  var _currentItemSelected = 'ธนาคารกรุงเทพ';
  String _date = "";
  String _time = "";

  @override
  void initState() {
    super.initState();
  }

  final String uploadEndPoint =
      'http://localhost/flutter_test/upload_image.php';
  Future<File> file;
  String status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error Uploading Image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(source: ImageSource.camera);
    });
    setStatus('');
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(fileName);
  }

  upload(String fileName) {
    http.post(uploadEndPoint, body: {
      "image": base64Image,
      "name": fileName,
    }).then((result) {
      setStatus(result.statusCode == 200 ? result.body : errMessage);
    }).catchError((error) {
      setStatus(error);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Image.file(
            snapshot.data,
            fit: BoxFit.fill,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'หลักฐานการชำระเงิน',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height > 750
              ? MediaQuery.of(context).size.height
              : MediaQuery.of(context).size.height * 0.9,
          decoration:
          BoxDecoration(gradient: BackgroundAppTheme.backgroundPrimary),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.grey[200],
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'สัญญาเลขที่ : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              mycontractno,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.white,
                        width: double.infinity,
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'ยอดที่ต้องชำระ : ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              myhp_overdueamt,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Center(child: showImage()),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 160, left: 200),
                    child: Center(
                      child: IconButton(
                        onPressed: chooseImage,
                        icon: Icon(Icons.camera_alt),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showDatePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true,
                              minTime: DateTime(2563, 1, 1),
                              maxTime: DateTime(2568, 12, 31),
                              onConfirm: (date) {
                                print('confirm $date');
                                _date = '${date.day}/${date.month}/${date.year}';
                                setState(() {});
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.th);
                        },
                        child: Container(
                          height: 50.0,
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.date_range,
                                        size: 25.0,
                                        color: Colors.black,
                                      ),
                                      Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 5),
                                      ),
                                      Text(
                                        "วันที่โอน",
                                        style: TextStyle(
                                          color: Colors.black,
                                          //  fontWeight: FontWeight.bold,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  " $_date",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        elevation: 4.0,
                        onPressed: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                                print('confirm $time');
                                _time = '${time.hour} : ${time.minute}';
                                setState(() {});
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.access_time,
                                      size: 25.0,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                    ),
                                    Text(
                                      "เวลาที่โอน",
                                      style: TextStyle(
                                        color: Colors.black,
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80),
                              ),
                              Text(
                                " $_time",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16.0),
                              ),
                            ],
                          ),
                        ),
                        color: Colors.white,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 0),
                              blurRadius: 6,
                              spreadRadius: 10,
                              color: Color.fromARGB(20, 0, 0, 0),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.domain,
                                      size: 25.0,
                                      color: Colors.black,
                                    ),
                                    Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                    ),
                                    Text(
                                      "เลือกธนาคาร",
                                      style: TextStyle(
                                        color: Colors.black,
                                        //  fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButton<String>(
                                items: _currencies
                                    .map((String dropDownStringItem) {
                                  return DropdownMenuItem<String>(
                                    value: dropDownStringItem,
                                    child: Text(dropDownStringItem,
                                        textAlign: TextAlign.center),
                                  );
                                }).toList(),
                                onChanged: (String newValueSelected) {
                                  _onDropDownItemSelected(newValueSelected);
                                },
                                value: _currentItemSelected,
                                hint: Text('เลือกธนาคาร'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 6,
                                spreadRadius: 10,
                                color: Color.fromARGB(20, 0, 0, 0),
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:
                                  'โอนผ่านเคาน์เตอร์ธนาคาร กรอก "9999"',
                                  labelText:
                                  'โอนเงินจากบัญชีธนาคารเลขที่ (4 หลักสุดท้าย)'),
                            ),
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 0),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: double.infinity,
                          child: RaisedButton(
                            elevation: 4.0,
                            onPressed: startUpload,
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.blueAccent, width: 1),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Text(
                              'ส่ง',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDropDownItemSelected(String newValueSelected) {
    setState(() {
      this._currentItemSelected = newValueSelected;
    });
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;
  CustomDialog({
    this.title,
    this.description,
    this.buttonText,
    this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  dialogContent(BuildContext context) {
    const double padding = 16.0;
    const double avatarRadius = 40.0;
    return Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.only(
            top: avatarRadius + padding,
            left: padding,
            right: padding,
          ),
          margin: EdgeInsets.only(top: avatarRadius),
          decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(padding),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                )
              ]),
          child:
          Column(mainAxisSize: MainAxisSize.min, // To make the card compact
              children: <Widget>[
                Text(
                  this.title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 16.0),
                Text(description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.0,
                    )),
                SizedBox(height: 24.0),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: RaisedButton(
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContractPage()));
                      },
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    )),
                SizedBox(height: 24.0),
              ])),
      Positioned(
          left: padding,
          right: padding,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            radius: avatarRadius,
            child: Center(
              child: Icon(
                Icons.done,
                size: 50,
                color: Colors.white,
              ),
            ),
          ))
    ]);
  }
}

class Hpcontract {
  final String contractno;
  final String hp_overdueamt;
  Hpcontract(
      this.contractno,
      this.hp_overdueamt,
      );
}
