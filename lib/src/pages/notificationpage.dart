import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/contractpage.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'checkregister.dart';

class NotificationPage extends StatelessWidget {
  Future<List<AlertCustomer>> _getContract() async {
    final strsql =
        "select customercode, alerttype, alerthead, alertdetail,whenupdate,timeupdate as show_time from tblalertmessage where customercode = '3570500257078' order by whenupdate desc,timeupdate desc";

    final www = "http://203.154.100.207/SINTHANEE123";
    var data = await http.get(
        '$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<AlertCustomer> tblhpcontract = [];


    final checklogin = await AuthService().isLogin();

    if (checklogin == true) {
      for (var u in jsonData) {
        AlertCustomer alertcustomer = AlertCustomer(u["customercode"], u["alerttype"],
            u["alerthead"], u["alertdetail"], u["whenupdate"], u["show_time"]);
        tblhpcontract.add(alertcustomer);
      }
    }else{
        AlertCustomer alertcustomer = AlertCustomer("NOTLOGIN", "",
            "", "", "", "");
        tblhpcontract.add(alertcustomer);
    }

    return tblhpcontract;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'แจ้งเตือน',
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
        decoration:
        BoxDecoration(gradient: BackgroundAppTheme.backgroundPrimary),
        child: FutureBuilder(
          future: _getContract(),
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


                  if (rs.data[index].customercode == "NOTLOGIN"){
    return GotoRegister();
                  }else {
                    return Container(
                      decoration: BoxDecoration(),
                      padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                      height: 140,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black45, width: 1),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: new EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(
                                    rs.data[index].whenupdate +
                                        " - " +
                                        rs.data[index].show_time,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: _geticon(rs.data[index].alerttype)
                                    //  Icon(Icons.person_pin),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                  ),
                                  Text(
                                    rs.data[index].alerthead,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              Divider(
                                height: 5,
                                indent: 0,
                                endIndent: 0,
                                thickness: 1.5,
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      rs.data[index].alertdetail,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black87,
                                          letterSpacing: 0.25),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
}

_geticon(alerttype) {

  if (alerttype == "1"){
    return Icon(Icons.person_pin);
  }else if (alerttype == "2"){
    return Icon(Icons.monetization_on);
  }else{
    return Icon(Icons.event);
  }

}

class AlertCustomer {
  final String customercode;
  final String alerttype;
  final String alerthead;
  final String alertdetail;
  final String whenupdate;
  final String show_time;
  AlertCustomer(this.customercode, this.alerttype, this.alerthead,
      this.alertdetail, this.whenupdate, this.show_time);
}


