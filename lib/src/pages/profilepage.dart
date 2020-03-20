import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

class ProfilePage extends StatefulWidget {
  final String p_customercode;

  ProfilePage({Key key, this.p_customercode}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<List<Customer>> _getCustomer() async {
    final strsql =
        "select arname||' '||lname as arname,brithdate,mobileno,arstatus " +
            "from tblcustomer c " +
            "where c.customercode = '${widget.p_customercode}'  " +
            "order by c.customercode";

    final www = "http://203.154.100.207/SINTHANEE123";
    var data = await http.get(
        '$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Customer> tblcustomer = [];

    for (var u in jsonData) {
      Customer customer =
          Customer(u["arname"], u["brithdate"], u["mobileno"], u["arstatus"]);

      tblcustomer.add(customer);
    }
    print(tblcustomer.length);
    return tblcustomer;
  }

  TextStyle _style() {
    return TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
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
      body: FutureBuilder(
          future: _getCustomer(),
          builder: (BuildContext context, AsyncSnapshot rs) {
            // print(rs.data);
            if (rs.data == null) {
              return Container(
                child: Center(
                  child: Text("Loading..."),
                ),
              );
            } else {



              return ListView.builder(


                  itemCount: rs.data.length,
                  itemBuilder: (BuildContext context, int index) {

                    return Column(
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
                          rs.data[index].arname,
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
                        Container(
                          margin: EdgeInsets.all(0),
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text('ชื่อ - นามสกุล :'),
                                subtitle: Text(
                                  rs.data[index].arname,
                                  style: _style(),
                                ),
                                leading: Icon(
                                  Icons.account_circle,
                                  size: 30,
                                ),
                              ),
                              ListTile(
                                title: Text('วัน เดือน ปี เกิด :'),
                                subtitle: Text(
                                  rs.data[index].brithdate,
                                  style: _style(),
                                ),
                                leading: Icon(
                                  Icons.cake,
                                  size: 30,
                                ),
                              ),
                              ListTile(
                                title: Text('เบอร์โทรศัพท์ :'),
                                subtitle: Text(
                                  rs.data[index].mobileno,
                                  style: _style(),
                                ),
                                leading: Icon(
                                  Icons.phone,
                                  size: 30,
                                ),
                              ),
                              ListTile(
                                title: Text('สถานะบัตร :'),
                                subtitle: Text(
                                  'Plus',
                                  style: _style(),
                                ),
                                leading: Icon(
                                  Icons.card_travel,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5.0),
                          child: Center(
                            child: Container(
                              padding:
                              EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 4.0,
                                onPressed: () {
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
                    );


              }


              );

            }
          }),
    );
  }
}

class Customer {
  final String arname;
  final String brithdate;
  final String mobileno;
  final String arstatus;
  Customer(this.arname, this.brithdate, this.mobileno, this.arstatus);
}
