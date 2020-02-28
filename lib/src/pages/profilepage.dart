import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/homepage.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, //แก้เอาคำว่า  debug  ออก
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {

  TextStyle _style(){
    return TextStyle(
      fontWeight: FontWeight.bold,fontSize: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'ข้อมูลส่วนบุคคล',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  child: Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 60,
                      child: Icon(
                        Icons.people,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'มุ่งมั่น สร้างสรรค์ชีวิต',
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(
                  height: 1.0,
                  indent: 15.0,
                  endIndent: 15.0,
                  thickness: 1.0,
                ),
                SizedBox(height: 0),
                Container(
                  margin: EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text('ชื่อ - นามสกุล :'),
                        subtitle: Text('มุ่งมั่น สร้างสรรค์',style: _style(),),
                        leading: Icon(Icons.account_circle,size: 30,),

                      ),
                      ListTile(
                        title: Text('วัน เดือน ปี เกิด :'),
                        subtitle: Text('1 มกราคม 2528',style: _style(),),
                        leading: Icon(Icons.cake,size: 30,),
                      ),                    ListTile(
                        title: Text('เบอร์โทรศัพท์ :'),
                        subtitle: Text('087-5665111',style: _style(),),
                        leading: Icon(Icons.phone,size: 30,),
                      ) ,                   ListTile(
                        title: Text('สถานะบัตร :'),
                        subtitle: Text('Plus',style: _style(),),
                        leading: Icon(Icons.card_travel,size: 30,),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 0.0,),
                Container(

                  padding: EdgeInsets.all(5.0),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20),
                      width: double.infinity,
                      child: RaisedButton(
                        elevation: 4.0,
                        onPressed: (){
                          Navigator.pushReplacementNamed(context, '/home');

                        },
                        color: Colors.blueAccent,

                        padding: EdgeInsets.all(10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          'เข้าสู่หน้าหลัก',
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
            )
          ],
        ),
      ),
    );
  }
}