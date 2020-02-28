import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckcontractPage extends StatelessWidget {
  final String mycontractno;
  final String myproductname;
  final String myhp_overdueamt;

  num hploannet = 0;
  String output = "0";
  num sumbalance = 0;
  CheckcontractPage(
      {Key key, this.mycontractno, this.myproductname, this.myhp_overdueamt})
      : super(key: key);

  Future<List<Hpcontract>> _getContract() async {
    final strsql =
        "select p.paiddate,p.receiveno,p.hpamt,p.period,p.duedate,p.amount,p.paidamt, " +
            "p.hpbalance,h.hploannet " +
            "from tblhpcontract h,tblhppaidlate p " +
            "where h.contractno = p.contractno and h.contractno = '$mycontractno'  " +
            "and functioncode='402' " +
            "order by p.duedate,p.paiddate,p.seqno";

    final www = "http://203.154.100.207/SINTHANEE123";
    var data = await http.get(
        '$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Hpcontract> tblhpcontract = [];

    for (var u in jsonData) {
      Hpcontract hpcontract = Hpcontract(
          u["paiddate"],
          u["receiveno"],
          u["hpamt"],
          u["period"],
          u["duedate"],
          u["amount"],
          u["paidamt"],
          u["hpbalance"],
          u["hploannet"]);

      tblhpcontract.add(hpcontract);
    }
    //print(tblhpcontract.length);
    return tblhpcontract;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'ตรวจสอบสัญญาl',
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
              height: 100,
              child: Card(
                color: Colors.blue[50],
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
                      SizedBox(height: 1,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "สัญญาเลขที่ : ",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 18,                                             fontWeight: FontWeight.bold,
                                    color: Colors.black87),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "สินค้า",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          Text(
                            myproductname,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "ยอดรวมหนี้คงค้าง",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 13, color: Colors.black87),
                          ),
                          Text(
                            myhp_overdueamt,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 1,
                      )
                    ],
                  ),
                ),
              ),
            ),
            HeadColumn(),
            Container(
              height: MediaQuery.of(context).size.height - 250,
              //height: MediaQuery.of(context).size.height * 0.60,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Colors.black45, width: 1),
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
                          hploannet = double.parse(rs.data[index].hploannet);
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 1, horizontal: 1),
                            child: Padding(
                              padding: new EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    // mainAxisAlignment:
                                    // MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        rs.data[index].paiddate,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      Spacer(),
                                      Text(
                                        rs.data[index].receiveno,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                      Spacer(),
                                      Text(
                                        rs.data[index].paidamt,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        rs.data[index].period +
                                            " - " +
                                            rs.data[index].duedate,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hpamt,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].paidamt,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        rs.data[index].hpbalance,
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black87),
                                      ),
                                      Text(
                                        _getbalance(
                                            double.parse(rs.data[index].hpamt)),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],

          //children: <Widget>[

          //],
        ),
      ),
    );
  }

  _getbalance(double balance) {
    sumbalance = sumbalance + balance;
    return output = (hploannet - sumbalance).toString();
  }
}

class Hpcontract {
  final String paiddate;
  final String receiveno;
  final String hpamt;
  final String period;
  final String duedate;
  final String amount;
  final String paidamt;
  final String hpbalance;
  final String hploannet;
  Hpcontract(this.paiddate, this.receiveno, this.hpamt, this.period,
      this.duedate, this.amount, this.paidamt, this.hpbalance, this.hploannet);
}

class HeadColumn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5, horizontal: 0.5),
      height: 60,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "วันที่ชำระ",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14,                                            fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Text(
                    "เลขที่ใบเสร็จ",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14,                                            fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  Text(
                    "ยอดจ่ายชำระ",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 14,                                             fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "งวดที่-วันครบกำหนด",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                  Text(
                    "ค่างวด",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                  Text(
                    "ตัดชำระ",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                  Text(
                    "ค่างวดคงค้าง",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                  Text(
                    "คงเหลือ",
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
