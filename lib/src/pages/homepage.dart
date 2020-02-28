import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_app/src/pages/notificationpage.dart';
import 'package:flutter_app/src/pages/registerpage.dart';
import 'package:flutter_app/src/themes/background_app.dart';
import 'package:http/http.dart' as http;
import './firstpage.dart' as first;
import './secondpage.dart' as second;
import './thirdpage.dart' as third;
import './fourthpage.dart' as fourth;
import './fifthpage.dart' as fifth;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.person_pin,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterPage()));
          },
        ),
        title: Text("SHIFTSOFT"),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationPage()));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.blueAccent,
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height > 750
              ? MediaQuery.of(context).size.height
              : 750,
          decoration:
              BoxDecoration(gradient: BackgroundAppTheme.backgroundPrimary),
          child: Column(
            children: <Widget>[
              ImageCarousel(),
              DefaultTabController(
                length: 5,
                child: TabBar(
                  controller: controller,
                  labelColor: Colors.blueAccent,
                  unselectedLabelColor: Colors.black26,
                  tabs: <Widget>[
                    Tab(
                      icon: Icon(
                        Icons.kitchen,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.directions_car,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.motorcycle,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.directions_bike,
                        size: 30,
                      ),
                    ),
                    Tab(
                      icon: Icon(
                        Icons.reorder,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.65,
                //width: 180,
                width: MediaQuery.of(context).size.width,
                child: TabBarView(
                  controller: controller,
                  children: <Widget>[
                    first.First(),
                    second.Second(),
                    third.Third(),
                    fourth.Fourth(),
                    fifth.Fifth(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ImageCarousel extends StatefulWidget {
  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final carousel = Carousel(
    boxFit: BoxFit.cover,
    images: [
      Image.network(
          'https://f.ptcdn.info/830/053/000/owv9n3mysOL9aJ9ekZ7-o.jpg',
          fit: BoxFit.cover),
      Image.network(
          'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__340.jpg',
          fit: BoxFit.cover),
      Image.network(
          'https://i0.wp.com/mobileocta.com/wp-content/uploads/2019/02/Mi-Full-Screen-102.jpg?fit=700%2C352',
          fit: BoxFit.cover)
    ],
    animationCurve: Curves.fastOutSlowIn,
    animationDuration: Duration(milliseconds: 2000),
    dotBgColor: Colors.transparent,
    dotSize: 6.0,
    dotSpacing: 25.0,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(10.0),
        height: 150,
        child: Container(
          decoration: new BoxDecoration(
            border: new Border.all(color: Colors.black45, width: 1),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
            shape: BoxShape.rectangle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: carousel,
          ),
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
