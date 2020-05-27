import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rating_bar/rating_bar.dart';

import 'detailproductpage.dart';

class Fourth extends StatelessWidget {
  Future<List<FourSubmodel>> _getSubmodel() async {
    final strsql =
        "select submodel,meaning,pricea,'http://shiftsoft-dev.net/Hi-Demo/Uploadfile/submodel/'||submodel||'.jpg' as pathpicture from tblsubmodel "
        " where productcode = 'C' and cancel = 'N' and showapp = 'Y'"
        " order by submodel ";

    final www = "http://shiftsoft-dev.net/Hi-Demo";

    var data = await http.get(
        "$www/executeapp.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql");

    var jsonData = json.decode(data.body);

    List<FourSubmodel> tblsubmodel = [];

    for (var u in jsonData) {
      FourSubmodel submodel = FourSubmodel(
          u["submodel"],u["meaning"],u["pathpicture"],u["pricea"]);

      tblsubmodel.add(submodel);
    }
    return tblsubmodel;
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
            future: _getSubmodel(),
            builder: (BuildContext context, AsyncSnapshot rs) {
              //print(rs.data.length.toString());
              var childCount = 0;
              childCount = 10;
              return SliverGrid(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.9,
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
                                child: Container(
                                  padding: EdgeInsets.all(3),
                                  child: InkWell(
                                    onTap: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailProductPage(p_submodel:
                                                  rs.data[index].submodel)));

                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: <Widget>[
                                        Image.network(
                                          rs.data[index].pathpicture,
                                          fit: BoxFit.cover,
                                          width: 200,
                                          height: MediaQuery.of(context).size.height*0.1,
                                        ),
                                        Container(
                                          height: 33,
                                          margin: EdgeInsets.only(left: 5,bottom: 5),
                                          alignment: Alignment.topLeft,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Expanded(
                                                child: Text(
                                                  rs.data[index].meaning,
                                                  textAlign: TextAlign.left,
                                                  overflow: TextOverflow.clip,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black87),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 5),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            rs.data[index].pricea,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrangeAccent),
                                          ),
                                        ),
                                        Divider(
                                          thickness: 1,
                                          indent: 5,
                                          endIndent: 5,
                                        ),
                                        Row(
                                          children: <Widget>[
                                            RatingBar.readOnly(
                                              maxRating: 5,
                                              initialRating: 3.5,
                                              isHalfAllowed: true,
                                              filledIcon: Icons.star,
                                              emptyIcon: Icons.star_border,
                                              halfFilledIcon: Icons.star_half,
                                              emptyColor: Colors.grey,
                                              filledColor: Colors.deepOrangeAccent,
                                              halfFilledColor:
                                              Colors.deepOrangeAccent,
                                              size: 15,
                                            ),
                                            SizedBox(
                                              width: 1,
                                            ),
                                            Text("(100)")
                                          ],
                                        ),
                                        SizedBox(
                                          height: 1,
                                        )
                                      ],
                                    ),
                                  ),
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

class FourSubmodel {
  final String submodel;
  final String meaning;
  final String pathpicture;
  final String pricea;
  FourSubmodel(this.submodel,this.meaning,this.pathpicture,this.pricea);
}

