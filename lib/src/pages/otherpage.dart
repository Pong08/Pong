import 'package:flutter/material.dart';
import 'package:flutter_app/src/themes/background_app.dart';

class OtherPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: Text(
          'ศูนย์บริการ',
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
        child: Center(
          child: Column(

            children: <Widget>[

              Text("Hi"),
            ],
          ),
        ),
      ),
    );
  }
}
