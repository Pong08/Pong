import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class MyPayIn extends StatefulWidget {
  MyPayIn({Key key, this.mycontractno, this.myhp_overdueamt}) : super(key: key);

  final String mycontractno;
  final String myhp_overdueamt;

  @override
  _MyPayInState createState() =>
      _MyPayInState(this.mycontractno, this.myhp_overdueamt);
}

class _MyPayInState extends State<MyPayIn> {
  File _image;
  final String mycontractno;
  final String myhp_overdueamt;

  _MyPayInState(this.mycontractno, this.myhp_overdueamt);

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showRoundedDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        locale: Locale("th", "TH"),
        era: EraMode.BUDDHIST_YEAR,
        borderRadius: 18);
    if (picked != null && picked != null) {
      print('${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked =
        await showRoundedTimePicker(context: context, initialTime: _time);
    if (picked != null && picked != null) {
      print('${_time.toString()}');
      setState(() {
        _time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String _formatted = DateFormat.yMMMd("th_TH").format(_date);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
          title: Text(
            'หลักฐานการชำระเงิน',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 0,
                ),
                Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.blue[50],
                              width: double.infinity,
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'สัญญาเลขที่ : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    mycontractno,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              color: Colors.white70,
                              width: double.infinity,
                              height: 40,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    'ยอดที่ต้องชำระ : ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    myhp_overdueamt,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.black87),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                      child: _image == null
                          ? Text('ไม่มีรูปภาพ')
                          : Image.file(_image)),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                    FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'เลือกรูปภาพ',
                      child: Icon(Icons.add_a_photo),
                    ),
                    FloatingActionButton(
                      onPressed: getImage,
                      tooltip: 'เลือกรูปภาพ',
                      child: Icon(Icons.insert_photo),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      icon: Icon(Icons.date_range),
                      border: OutlineInputBorder(),
                      hintText: '--/--/----',
                      labelText: 'วันที่โอนเงิน',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      icon: Icon(Icons.access_time),
                      border: OutlineInputBorder(),
                      hintText: '00:00',
                      labelText: 'เวลาที่โอน',
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.location_city),
                      border: OutlineInputBorder(),
                      hintText: '',
                      labelText: 'เลือกธนาคารที่โอน',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
