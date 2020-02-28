import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import './src/pages/homepage.dart';
import './src/pages/contractpage.dart';
import './src/pages/contractus.dart';
import './src/pages/otherpage.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
     MyAppState();

}

class MyAppState extends State<MyApp> {
  int selectedPage = 0;
  final _pageOptions = [
    HomePage(),
    ContractPage(),
    ContractusPage(),
    OtherPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,  // Add global cupertino localiztions.
      ],
      locale: Locale('en', 'US'),  // Current locale
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('th', 'TH'), // Thai
      ],
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{ //app routes
        '/home': (BuildContext context) => new MyApp(),
      },
      home: Scaffold(
        body: _pageOptions[selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.black,
          currentIndex: selectedPage,
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blueAccent,
          onTap: (int index) {
            setState(() {
              selectedPage = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('หน้าหลัก')),
            BottomNavigationBarItem(
                icon: Icon(Icons.payment), title: Text('ธุรกรรม')),
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on), title: Text('ติดต่อ')),
            BottomNavigationBarItem(
                icon: Icon(Icons.scatter_plot), title: Text('อื่นๆ'))
          ],
        ),
      ),
    );
  }
}
