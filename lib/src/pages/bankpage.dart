import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/payinpage.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
class BankPage extends StatefulWidget {

  BankPage({Key key, this.mycontractno, this.myhp_overdueamt}) : super(key: key);

  final String mycontractno;
  final String myhp_overdueamt;

  @override
  _BankPageState createState() => _BankPageState(this.mycontractno, this.myhp_overdueamt);
}

class _BankPageState extends State<BankPage> {

  final String mycontractno;
  final String myhp_overdueamt;
  _BankPageState(this.mycontractno, this.myhp_overdueamt);

  Future<List<Bank>> _getBank() async {
    final strsql = "select bankname,logobank,bankcode from tblbank order by bankcode";

    final www = "http://shiftsoft-dev.net/Hi-Demo";
    var data = await http.get(
        '$www/executeapp.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Bank> result = [];
    for (var rs in jsonData) {
      Bank bank = Bank(rs["bankname"],rs["logobank"],rs["bankcode"]);
      result.add(bank);
    }

    return result;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'ธนาคาร',
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
          future: _getBank(),
          builder: (BuildContext context, AsyncSnapshot rs) {
            // print(rs.data);
            if (rs.data == null) {
              return Container(child: Center(child: Text("Loading...")));
            } else {
              return ListView.builder(
                itemCount: rs.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: <Widget>[
                      ListTile(
                        title: InkWell(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PayinPage(p_contractno:
                                    mycontractno,
                                        p_hp_overdueamt: myhp_overdueamt,
                                        p_bankcode: rs.data[index].bankcode,
                                        p_bankname: rs.data[index].bankname)));

//
//
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => OtherPage()));
                          },
                          child: Row(
                            children: <Widget>[
                              Image.network(
                                rs.data[index].logobank,
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                rs.data[index].bankname,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        height: 0.0,
                        indent: 10.0,
                        endIndent: 10.0,
                        thickness: 2.0,
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
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

class Bank {
  final String bankname;
  final String logobank;
  final String bankcode;
  Bank(this.bankname,this.logobank,this.bankcode);
}
