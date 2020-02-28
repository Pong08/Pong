import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Fourth extends StatelessWidget {
  Future<List<Cmpcode>> _getCmpcode() async {
    final strsql =
        "select cmpcode,cmpname,addressi,addressii,addressiii,phoneno,opendaily, openholiday from hlp_branchno order by cmpcode ";

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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      //width: 180,
      width: MediaQuery.of(context).size.width,

      child: CustomScrollView(
        slivers: <Widget>[
          FutureBuilder(
            future: _getCmpcode(),
            builder: (BuildContext context, AsyncSnapshot rs) {
              //print(rs.data.length.toString());
              var childCount = 0;
              childCount = 20;
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                ),
                delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                    if (rs.data == null) {
                      return Container(
                          child: Center(child: Text("Loading...")));
                    } else {
                      //print();

                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            height: MediaQuery.of(context).size.height,
                            //width: 180,
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  side: BorderSide(
                                      color: Colors.blueAccent, width: 1),
                                ),
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                'https://i.pinimg.com/originals/30/be/04/30be04ee501d2ff5f73751f75ca702e5.jpg'),
                                            fit: BoxFit.cover,
                                          )),
                                      child: Container(
                                          color: Colors.white,
                                          margin: EdgeInsets.only(top: 115),
                                          child: Center(child: Text(rs.data[index].cmpcode,style: TextStyle(fontWeight: FontWeight.bold),)))),
                                )),
                          ),
                        ],
                      );
                    }
                  },
                  childCount: childCount,
                ),
              );
            },
          ),
        ],
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
