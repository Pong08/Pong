import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:http/http.dart' as http;

class DetailProductPage extends StatefulWidget {
  DetailProductPage({Key key, this.p_submodel}) : super(key: key);
  @override
  final String p_submodel;
  _DetailProductPageState createState() =>
      _DetailProductPageState(this.p_submodel);
}

class _DetailProductPageState extends State<DetailProductPage>
    with SingleTickerProviderStateMixin {
  final String p_submodel;
  _DetailProductPageState(this.p_submodel);

  Future<List<Submodel>> _getSubmodel() async {
    final strsql =
        "select submodel,meaning,pricea,properties,'http://shiftsoft-dev.net/Hi-Demo/Uploadfile/submodel/'||submodel||'.jpg' as pathpicture from tblsubmodel where submodel = '${widget.p_submodel}' ";

    final www = "http://shiftsoft-dev.net/Hi-Demo";
    var data = await http.get(
        '$www/executeapp.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Submodel> tblsubmodel = [];
    for (var u in jsonData) {
      Submodel submodel = Submodel(u["submodel"], u["meaning"], u["pricea"],
          u["properties"], u["pathpicture"]);
      tblsubmodel.add(submodel);
    }
    print(p_submodel);
    return tblsubmodel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'รายละเอียดสินค้า',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder(
          future: _getSubmodel(),
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
                      decoration: BoxDecoration(
                          gradient: BackgroundAppTheme.backgroundPrimary),
                      child: Card(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height > 750
                              ? MediaQuery.of(context).size.height
                              : 750,
                          child: Column(
                            children: <Widget>[
                              //ImageCarouselDetail(),

                              Column(

                                children: <Widget>[
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.star_border,
                                          size: 25,
                                        ),
                                        onPressed: () {
                                          _ackAlert(context);
                                        },
                                      )),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.all(5.0),
                                      height: 230,
                                      child: Container(
                                        child: Image.network(
                                          rs.data[index].pathpicture,
                                           //height: 230,
                                          // width: double.infinity,
                                          fit: BoxFit.cover, //เต็มจอ
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),

//                              Center(
//                                child: Stack(
//                                  children: <Widget>[
//                                    Image.network(
//                                      rs.data[index].pathpicture,
//                                      height: 250,
//                                     // width: double.infinity,
//                                      fit: BoxFit.cover, //เต็มจอ
//                                    ),
//
//                                    Align(
//                                        alignment: Alignment.topRight,
//                                        child: IconButton(
//                                          icon: Icon(Icons.star_border,size: 30,),
//                                          onPressed: () {
//                                            _ackAlert(context);
//                                          },
//                                        ))
//                                  ],
//
//
//                                ),
//                              ),

                              ListTile(
                                title: Text(
                                  rs.data[index].meaning,
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                subtitle: Text(
                                  rs.data[index].submodel,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          RatingBar.readOnly(
                                            maxRating: 5,
                                            initialRating: 3.5,
                                            isHalfAllowed: true,
                                            filledIcon: Icons.star,
                                            emptyIcon: Icons.star_border,
                                            halfFilledIcon: Icons.star_half,
                                            emptyColor: Colors.grey,
                                            filledColor:
                                                Colors.deepOrangeAccent,
                                            halfFilledColor:
                                                Colors.deepOrangeAccent,
                                            size: 20,
                                          ),
                                          Text('(40)')
                                        ],
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        rs.data[index].pricea,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Divider(
                                thickness: 1,
                                indent: 15,
                                endIndent: 15,
                                height: 10,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'รายละเอียด :',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.black),
                                    ),
                                    SizedBox(height: 8.0),
                                    Text(rs.data[index].properties),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            }
          }),
    );
  }
}

class ImageCarouselDetail extends StatelessWidget {
  final carousel = Carousel(
    boxFit: BoxFit.cover,
    images: [
      Image.network(
          'https://www.topvalue.com/media/wysiwyg/01_description/041/58974/SJ-C19E-WMS_3_1_.jpg',
          fit: BoxFit.contain)
    ],
    showIndicator: true,
    animationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 2000),
    dotBgColor: Colors.white24,
    dotSize: 6.0,
    dotSpacing: 25.0,
    autoplay: false,
  );
  @override
  Widget build(BuildContext context) {
    var _showRatingDialog;
    return Center(
      child: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5.0),
            height: 270,
            child: Container(
              child: carousel,
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(
                  Icons.star_border,
                  size: 30,
                ),
                onPressed: () {
                  _ackAlert(context);
                },
              ))
        ],
      ),
    );
  }
}

Future<void> _ackAlert(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return RatingDialog(
        icon: Icon(Icons.notifications), // set your own image/icon widget
        title: "ระดับความพึงพอใจสินค้า",
        description: "กดดาวเพื่อให้คะแนน",
        submitButton: "ให้คะแนน",
        alternativeButton: "ติดต่อเรา?", // optional
        positiveComment: "ขอบคุณสำหรับการให้คะแนน", // optional
        negativeComment: "", // optional
        accentColor: Colors.deepOrangeAccent, // optional
        onSubmitPressed: (int rating) {
          print("ความพึงพอใจ = $rating");
          // TODO: open the app's page on Google Play / Apple App Store
        },
        onAlternativePressed: () {
          print("onAlternativePressed: do something");
          // TODO: maybe you want the user to contact you instead of rating a bad review
        },
      );
    },
  );
}

class Submodel {
  final String submodel;
  final String meaning;
  final String pricea;
  final String properties;
  final String pathpicture;
  Submodel(this.submodel, this.meaning, this.pricea, this.properties,
      this.pathpicture);
}
