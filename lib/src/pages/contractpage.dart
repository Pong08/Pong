import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/contractdetail.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContractPage extends StatelessWidget {
  Future<List<Hpcontract>> _getContract() async {
    final strsql =
        "select contractno,contractdate,(select meaning from tblproductcode where productcode = (select productcode from tblstockitem where chassisno = h.chassisno)) as productname,hp_overdueamt from tblhpcontract h where customercode = '3570500257078' order by contractdate,contractno";

    final www = "http://203.154.100.207/SINTHANEE123";
    var data = await http.get(
        '$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Hpcontract> tblhpcontract = [];

    for (var u in jsonData) {
      Hpcontract hpcontract = Hpcontract(u["contractno"], u["contractdate"],
          u["productname"], u["hp_overdueamt"]);

      tblhpcontract.add(hpcontract);
    }

    // print(tblhpcontract.length);

    return tblhpcontract;
  }
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'ธุรกรรม',
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
                  return Container(
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    height: 120,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: BorderSide(color: Colors.black45, width: 1),
                      ),
                      elevation: 3,

                      // color: Colors.white60,
                      child: Padding(
                        padding: new EdgeInsets.symmetric(horizontal: 15,),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => ContractDetailPage(mycontractno: rs.data[index].contractno)));


                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(Icons.content_paste),
                                  ),
                                  Text(
                                    "สัญญาเลขที่ : ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                  Text(
                                    rs.data[index].contractno,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueAccent),
                                  ),
                                ],
                              ),
                              Divider(height: 5,indent: 0,endIndent: 0,
                              thickness: 1,),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "สินค้า : ",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 13, color: Colors.black87),
                                  ),
                                  Text(
                                    rs.data[index].productname,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    "ยอดรวมหนี้คงค้าง",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.black87),
                                  ),
                                  Text(
                                    rs.data[index].hp_overdueamt,
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1,)
                            ],
                          ),
                        ),
                      ),
                    ),
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

class Hpcontract {
  final String contractno;
  final String contractdate;
  final String productname;
  final String hp_overdueamt;
  Hpcontract(
      this.contractno, this.contractdate, this.productname, this.hp_overdueamt);
}
