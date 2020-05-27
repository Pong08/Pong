import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  static const String IS_LOGINCONTRACT_PREF = "is_logincontract";
  static const String IS_LOGIN_PREF = "is_login";
  static const String USERNAME_PREF = "username";

  Future<bool> login(String customercode, String mobileno) async {
    final strsql = "select customercode,mobileno " +
        "from tblcustomer " +
        "where customercode = '$customercode' and mobileno = '$mobileno' " +
        "order by customercode";

    final www = "http://203.154.100.207/SINTHANEE123";
    var data = await http.get(
        '$www/executedemo.php?p_dbmsname=X&p_username=sa&p_password=&p_type=select&p_sql=$strsql');

    var jsonData = json.decode(data.body);

    List<Customer> tblcustomer = [];

    for (var u in jsonData) {
      Customer hpcontract = Customer(u["customercode"], u["mobileno"]);

      tblcustomer.add(hpcontract);
    }
    print(customercode);
    if (tblcustomer.length > 0) {
      return true;
    } else {
      return false;
    }
  }
  Future<String> Pgconnect(String sqltype, String strsql) async {

    print("SS");

    final www = "https://shiftsoft-dev.net/Hi-Demo/pgexecute.php";
    var data =  http.post('$www', body: {
                "DBname":'MotorDemo',
                "DBusername":'sa',
                "DBpassword":'@ecdssa3679pgssc!',
                "DBtype": sqltype,
                "DBsql": strsql,
    }).then((result) {}).catchError((error) {});
    print(data);
    return data;

  }
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(IS_LOGIN_PREF);
    prefs.setBool(IS_LOGIN_PREF, false);
  }

  Future<void> logincontract() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(IS_LOGINCONTRACT_PREF, true);
  }

  Future<void> loginok(String customercode,String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('login', customercode);
    prefs.setString('password', password);
    prefs.setBool(IS_LOGIN_PREF, true);
  }

  Future<void> getlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var login = prefs.getString('login');
    return login;
  }

  Future<String> userlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('login');
    return username;
  }
  Future<String> passwordlogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var password = prefs.getString('password');
    return password;
  }
  Future<bool> isLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.get(IS_LOGIN_PREF) ?? false;
  }
}

class Customer {
  final String customercode;
  final String mobileno;
  Customer(this.customercode, this.mobileno);
}
