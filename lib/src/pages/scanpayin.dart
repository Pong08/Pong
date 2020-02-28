import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScanPayinPage extends StatelessWidget {

  final String mycontractno;
  ScanPayinPage({Key key, this.mycontractno}) : super(key: key);

  Future<List<Hpcontract>> _getContract() async {
    final strsql = "select h.contractno,h.contractdate,h.hp_overdueamt," +
        "(select meaning from tblproductcode where productcode = s.productcode) as productname," +
        "h.amtperperiod,s.brandname,h.hp_intbalamount,h.hp_maxperiod,h.hp_maxduedate, " +
        "h.totalperiod,h.hp_paidperiod,h.totalperiod-h.hp_paidperiod as balanceperiod," +
        "h.hp_lastpaiddate " +
        "from tblhpcontract h,tblstockitem s " +
        "where h.contractno = '$mycontractno' and h.chassisno = s.chassisno " +
        "order by h.contractdate,h.contractno";

    final www = "http://203.154.100.207/SINTHANEE123";
    var data = await http.get(
        '$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Hpcontract> tblhpcontract = [];

    for (var u in jsonData) {
      Hpcontract hpcontract = Hpcontract(
          u["contractno"],
          u["contractdate"],
          u["productname"],
          u["hp_overdueamt"],
          u["brandname"],
          u["amtperperiod"],
          u["hp_intbalamount"],
          u["hp_maxperiod"],
          u["hp_maxduedate"],
          u["totalperiod"],
          u["hp_paidperiod"],
          u["balanceperiod"],
          u["hp_lastpaiddate"]);

      tblhpcontract.add(hpcontract);
    }

    // print(tblhpcontract.length);

    return tblhpcontract;
  }

  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.blueAccent,
      appBar: AppBar(

        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'สแกนชำระค่างวด',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
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
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    //height: 380,

                    child: Column(

                      children: <Widget>[
                        Container(

                          //   height: 360,
                          height: MediaQuery.of(context).size.height * 0.65,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side: BorderSide(color: Colors.black45, width: 1),
                            ),
                            elevation: 3,

                            // color: Colors.white60,
                            child: Padding(
                              padding: new EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "สัญญาเลขที่",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].contractno,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blueAccent),
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
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hp_overdueamt,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    height: 0,
                                    indent: 0,
                                    endIndent: 0,
                                    thickness: 1,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "กรุณาอัพโหลดรูปหลักฐานการชำระเงินภายในวันทางสินธานีจะตรวจสอบยอดเงินของคุณภายใน 24 ชั่วโมง",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),

                                  Image.network(
                                    "http://203.154.100.207/Pictures/qrcode/elect.png",
                                    height: 100,
                                    width: double.infinity,
                                    fit: BoxFit.cover, //เต็มจอ
                                  ),

                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "1. เก็บหลักฐานการโอนเงินและอัพโหลดภายในวัน",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Expanded(
                                        child: Text(
                                          "2. สินธานียืนยันการชำระเงินภายใน 48 ชม. หากไม่ได้รับการยืนยันภายในเวลาดังกล่าวกรุณาติดต่อ 053-153311 ต่อ 104",
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                      ],
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
  final String brandname;
  final String amtperperiod;
  final String hp_intbalamount;
  final String hp_maxperiod;
  final String hp_maxduedate;
  final String totalperiod;
  final String hp_paidperiod;
  final String balanceperiod;
  final String hp_lastpaiddate;
  Hpcontract(
      this.contractno,
      this.contractdate,
      this.productname,
      this.hp_overdueamt,
      this.brandname,
      this.amtperperiod,
      this.hp_intbalamount,
      this.hp_maxperiod,
      this.hp_maxduedate,
      this.totalperiod,
      this.hp_paidperiod,
      this.balanceperiod,
      this.hp_lastpaiddate);
}
