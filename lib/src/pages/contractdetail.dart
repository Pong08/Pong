import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/checkcontract.dart';
import 'package:flutter_app/src/pages/payinpage.dart';
import 'package:flutter_app/src/pages/paymentpage.dart';
import 'package:flutter_app/src/pages/scanpayin.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ContractDetailPage extends StatelessWidget {
  final String mycontractno;
  ContractDetailPage({Key key, this.mycontractno}) : super(key: key);

  Future<List<Hpcontract>> _getContract() async {
    final strsql = "select h.contractno,h.contractdate,h.hp_overdueamt," +
        "(select meaning from tblproductcode where productcode = s.productcode) as productname," +
        "h.amtperperiod,s.brandname,h.hp_intbalamount,h.hp_maxperiod,h.hp_maxduedate, " +
        "h.totalperiod,h.hp_paidperiod,h.totalperiod-h.hp_paidperiod as balanceperiod," +
        "h.hp_lastpaiddate " +
        "from tblhpcontract h,tblstockitem s " +
        "where h.contractno = '$mycontractno' and h.chassisno = s.chassisno " +
        "order by h.contractdate,h.contractno limit 1";

    final www = "http://shiftsoft-dev.net/Hi-Demo";
    var data = await http.get(
        '$www/executeapp.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

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
          'การผ่อนชำระ',
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
                          height: MediaQuery.of(context).size.height * 0.66,
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
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "สัญญาเลขที่ : ",
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
                                            fontSize: 17,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hp_overdueamt,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 17,
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
                                      Text(
                                        "สินค้า   ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
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
                                        "ยี่ห้อ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].brandname,
                                        textAlign: TextAlign.left,
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
                                        "ค่างวด",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].amtperperiod,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "ค่าธรรมเนียมล่าช้า",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hp_intbalamount,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "วันที่ครบกำหนดชำระ",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hp_maxduedate,
                                        textAlign: TextAlign.left,
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
                                        "จำนวนงวดในสัญญาทั้งหมด  " +
                                            rs.data[index].totalperiod +
                                            "  งวด",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "จำนวนที่ชำระ  " +
                                            rs.data[index].hp_paidperiod +
                                            "  งวด  คงเหลือ  " +
                                            rs.data[index].balanceperiod +
                                            "  งวด",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "ชำระครั้งสุดท้าย",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hp_lastpaiddate,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.496,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PayinPage(
                                              p_contractno:
                                              rs.data[index].contractno,
                                              p_hp_overdueamt: rs
                                                  .data[index].hp_overdueamt,
                                              p_bankcode: '',p_bankname: '')));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors.black45, width: 1),
                                  ),
                                  elevation: 3,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.content_copy),
                                        Text(
                                          "แจ้งการชำระ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.496,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CheckcontractPage(
                                                  p_contractno:
                                                  rs.data[index].contractno,
                                                  p_productname: rs
                                                      .data[index].productname,
                                                  p_hp_overdueamt: rs
                                                      .data[index]
                                                      .hp_overdueamt)));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors.black45, width: 1),
                                  ),
                                  elevation: 3,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.border_color),
                                        Text(
                                          "ตรวจสอบการชำระ",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PaymentPage(
                                            mycontractno:
                                            rs.data[index].contractno)));
                              },
                              child: Container(
                                height:
                                MediaQuery.of(context).size.height * 0.1,
                                width:
                                MediaQuery.of(context).size.width * 0.496,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors.black45, width: 1),
                                  ),
                                  elevation: 3,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.swap_horizontal_circle),
                                        Text(
                                          "โอนเงินค่างวด",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScanPayinPage(
                                            mycontractno:
                                            rs.data[index].contractno)));

                              },
                              child: Container(
                                height: MediaQuery.of(context).size.height * 0.1,
                                width: MediaQuery.of(context).size.width * 0.496,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    side: BorderSide(
                                        color: Colors.black45, width: 1),
                                  ),
                                  elevation: 3,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.center_focus_weak),
                                        Text(
                                          "สแกนชำระค่างวด",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
