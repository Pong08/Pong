import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;

class ContractusPage extends StatelessWidget {
  Future<List<Cmpcode>> _getCmpcode() async {
    final strsql =
        "select cmpcode,cmpname,addressi,addressii,addressiii,phoneno,opendaily, openholiday from hlp_branchno order by cmpcode" ;

    final www = "http://203.154.100.207/SINTHANEE123";

    var data = await http.get(
        "$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql");

    var jsonData = json.decode(data.body);

    List<Cmpcode> tblcmpcode = [];

    for (var u in jsonData) {
      Cmpcode cmpcode = Cmpcode(
          u["cmpcode"],
          u["cmpname"],
          u["addressi"],
          u["addressii"],
          u["addressiii"],
          u["phoneno"],
          u["opendaily"],
          u["openholiday"]);

      tblcmpcode.add(cmpcode);
    }

    print(tblcmpcode.length);

    return tblcmpcode;
  }

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'ติดต่อเรา',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        //padding: EdgeInsets.all(6.00),
        decoration: BoxDecoration(
            gradient: BackgroundAppTheme.backgroundPrimary
        ),
        child: FutureBuilder(
          future: _getCmpcode(),
          builder: (BuildContext context, AsyncSnapshot rs) {
            // print(rs.data);
            if (rs.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                itemCount: rs.data.length,
                itemBuilder: (BuildContext context, int index)
                {
                  return Column(
                    children: <Widget>[
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black45, width: 1),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(height: 5,),
                            ListTile(
                              title: Text(
                                rs.data[index].cmpcode +
                                    " " +
                                    rs.data[index].cmpname,
                                style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(rs.data[index].addressi +
                                  " " +
                                  rs.data[index].addressii +
                                  " " +
                                  rs.data[index].addressiii),
                            ),
                            SizedBox(height: 10.0,),
                            Divider(height: 0.0,
                              indent: 10.0,
                              endIndent: 10.0,
                              thickness: 0.0,),
                            ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 0.0, horizontal: 10.0),
                              dense: false,
                              isThreeLine: true,
                              leading: Icon(
                                Icons.phone,
                                size: 25,
                              ),
                              title: Text(rs.data[index].phoneno),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(rs.data[index].opendaily),
                               //   Text(rs.data[index].openholiday),
                                ],
                              ),
                              trailing: Icon(
                                Icons.map,color: Colors.blue,
                              ),
                            ),

                          ],
                        ),


                      ),
                      SizedBox(height: 10.0,),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class Cmpcode {
  final String cmpcode;
  final String cmpname;
  final String addressi;
  final String addressii;
  final String addressiii;
  final String phoneno;
  final String opendaily;
  final String openholiday;

  Cmpcode(this.cmpcode, this.cmpname, this.addressi, this.addressii,
      this.addressiii, this.phoneno, this.opendaily, this.openholiday);
}