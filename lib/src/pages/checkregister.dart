import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
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
//        prefs.setString(USERNAME_PREF, user.customercode);
//        prefs.setBool(IS_LOGIN_PREF, true);
      return true;
    } else {
      return false;
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(IS_LOGIN_PREF);
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
