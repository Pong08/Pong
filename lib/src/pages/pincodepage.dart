import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/src/pages/checkregister.dart';
import 'package:flutter_app/src/pages/profilepage.dart';

class PincodePage extends StatefulWidget {
  final String otpcode;
  final String p_customercode;
  PincodePage({Key key,  this.otpcode, this.p_customercode}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _PincodePageState();


}

class _PincodePageState extends State<PincodePage> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  bool isAuthenticated = false;

  @override
  Widget build(BuildContext context) {
    print(widget.p_customercode);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'กำหนดรหัสผ่าน',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            Text(
              'ผู้ใช้งาน : ${isAuthenticated ? '' : 'ยังไม่ได้'} ยืนยันตัวตน',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(
              height: 30,
            ),
            _defaultLockScreenButton(context),
            SizedBox(
              height: 10,
            ),
            // _customColorsLockScreenButton(context)

            Container(
              margin: EdgeInsets.all(10),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0),
                width: double.infinity,
                child: RaisedButton(
                  elevation: 4.0,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  color: Colors.blueAccent,
                  padding: EdgeInsets.all(10.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    'ยืนยัน',
                    style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _defaultLockScreenButton(BuildContext context) => MaterialButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(
                color: Colors.blueAccent, style: BorderStyle.solid, width: 2)),
        height: 50,
        minWidth: double.minPositive,
        child: Text(
          'เปิดเข้าสู่หน้าจอ',
          style: TextStyle(color: Colors.blueAccent, fontSize: 15),
        ),
        onPressed: () {
          _showLockScreen(context, opaque: false);
        },
      );

  _showLockScreen(BuildContext context,
      {bool opaque,
      CircleUIConfig circleUIConfig,
      KeyboardUIConfig keyboardUIConfig}) {
    Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
              PasscodeScreen(
            title: 'ระบุรหัสผ่าน',
            circleUIConfig: circleUIConfig,
            keyboardUIConfig: keyboardUIConfig,
            passwordEnteredCallback: _onPasscodeEntered,
            cancelLocalizedText: 'ยกเลิก',
            deleteLocalizedText: 'ลบ',
            shouldTriggerVerification: _verificationNotifier.stream,
            backgroundColor: Colors.black.withOpacity(0.8),
            cancelCallback: _onPasscodeCancelled,
          ),
        ));
  }

  _onPasscodeEntered(String enteredPasscode) async {
    bool isValid = widget.otpcode == enteredPasscode;
    _verificationNotifier.add(isValid);
    print(widget.otpcode);
    if (isValid) {
      setState(() {
        this.isAuthenticated = isValid;
      });


      if (isValid=true){
        AuthService().loginok(widget.p_customercode,widget.otpcode);

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ProfilePage(p_customercode:
            widget.p_customercode)));
      }




    }
  }

  _onPasscodeCancelled() {}

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}



//--
class CircleUIConfig {
  final Color borderColor;
  final Color fillColor;
  final double borderWidth;
  final double circleSize;
  double extraSize;

  CircleUIConfig(
      {this.extraSize = 0,
      this.borderColor = Colors.white,
      this.borderWidth = 1,
      this.fillColor = Colors.white,
      this.circleSize = 20});
}

class Circle extends StatelessWidget {
  final bool filled;
  final CircleUIConfig circleUIConfig;

  Circle({Key key, this.filled = false, @required this.circleUIConfig})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: circleUIConfig.extraSize),
      width: circleUIConfig.circleSize,
      height: circleUIConfig.circleSize,
      decoration: BoxDecoration(
          color: filled ? circleUIConfig.fillColor : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
              color: circleUIConfig.borderColor,
              width: circleUIConfig.borderWidth)),
    );
  }
}

//--
typedef KeyboardTapCallback = void Function(String text);

class KeyboardUIConfig {
  final double digitSize;
  final double digitBorderWidth;
  final TextStyle digitTextStyle;
  final TextStyle deleteButtonTextStyle;
  final Color primaryColor;
  final Color digitFillColor;
  final EdgeInsetsGeometry keyboardRowMargin;
  final EdgeInsetsGeometry deleteButtonMargin;

  KeyboardUIConfig({
    this.digitSize = 80,
    this.digitBorderWidth = 1,
    this.keyboardRowMargin = const EdgeInsets.only(top: 15),
    this.primaryColor = Colors.white,
    this.digitFillColor = Colors.transparent,
    this.digitTextStyle = const TextStyle(fontSize: 30, color: Colors.white),
    this.deleteButtonMargin =
        const EdgeInsets.only(right: 25, left: 20, top: 15),
    this.deleteButtonTextStyle =
        const TextStyle(fontSize: 16, color: Colors.white),
  });
}

class Keyboard extends StatelessWidget {
  final KeyboardUIConfig keyboardUIConfig;
  final GestureTapCallback onDeleteCancelTap;
  final KeyboardTapCallback onKeyboardTap;
  final bool shouldShowCancel;
  final String cancelLocalizedText;
  final String deleteLocalizedText;

  Keyboard(
      {Key key,
      @required this.keyboardUIConfig,
      @required this.onDeleteCancelTap,
      @required this.onKeyboardTap,
      this.shouldShowCancel = true,
      @required this.cancelLocalizedText,
      @required this.deleteLocalizedText})
      : super(key: key);

  @override
  Widget build(BuildContext context) => _buildKeyboard();

  Widget _buildKeyboard() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildKeyboardDigit('1'),
            _buildKeyboardDigit('2'),
            _buildKeyboardDigit('3'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildKeyboardDigit('4'),
            _buildKeyboardDigit('5'),
            _buildKeyboardDigit('6'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildKeyboardDigit('7'),
            _buildKeyboardDigit('8'),
            _buildKeyboardDigit('9'),
          ],
        ),
        Stack(
          children: <Widget>[
            Center(child: _buildKeyboardDigit('0')),
            Align(alignment: Alignment.topRight, child: _buildDeleteButton())
          ],
        ),
      ],
    );
  }

  Widget _buildKeyboardDigit(String text) {
    return Container(
      margin: keyboardUIConfig.keyboardRowMargin,
      width: keyboardUIConfig.digitSize,
      height: keyboardUIConfig.digitSize,
      child: ClipOval(
        child: Material(
          color: keyboardUIConfig.digitFillColor,
          child: InkWell(
            highlightColor: keyboardUIConfig.primaryColor,
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: () {
              onKeyboardTap(text);
            },
            child: Center(
              child: Text(
                text,
                style: keyboardUIConfig.digitTextStyle,
              ),
            ),
          ),
        ),
      ),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: keyboardUIConfig.primaryColor,
            width: keyboardUIConfig.digitBorderWidth),
      ),
    );
  }

  Widget _buildDeleteButton() {
    return Container(
      margin: keyboardUIConfig.deleteButtonMargin,
      height: keyboardUIConfig.digitSize,
      width: keyboardUIConfig.digitSize,
      child: ClipOval(
        child: Material(
          color: keyboardUIConfig.digitFillColor,
          child: InkWell(
            highlightColor: keyboardUIConfig.primaryColor,
            splashColor: keyboardUIConfig.primaryColor.withOpacity(0.4),
            onTap: onDeleteCancelTap,
            child: Center(
              child: Text(
                shouldShowCancel ? cancelLocalizedText : deleteLocalizedText,
                style: keyboardUIConfig.deleteButtonTextStyle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//--
typedef PasswordEnteredCallback = void Function(String text);
typedef IsValidCallback = void Function();
typedef CancelCallback = void Function();

class PasscodeScreen extends StatefulWidget {
  final String title;
  final int passwordDigits;
  final Color titleColor;
  final Color backgroundColor;
  final PasswordEnteredCallback passwordEnteredCallback;

  //isValidCallback will be invoked after passcode screen will pop.
  final IsValidCallback isValidCallback;
  final CancelCallback cancelCallback;
  final String cancelLocalizedText;
  final String deleteLocalizedText;
  final Stream<bool> shouldTriggerVerification;
  final Widget bottomWidget;
  final CircleUIConfig circleUIConfig;
  final KeyboardUIConfig keyboardUIConfig;

  PasscodeScreen({
    Key key,
    @required this.title,
    this.passwordDigits = 6,
    @required this.passwordEnteredCallback,
    @required this.cancelLocalizedText,
    @required this.deleteLocalizedText,
    @required this.shouldTriggerVerification,
    this.isValidCallback,
    this.circleUIConfig,
    this.keyboardUIConfig,
    this.bottomWidget,
    this.titleColor = Colors.white,
    this.backgroundColor,
    this.cancelCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen>
    with SingleTickerProviderStateMixin {
  StreamSubscription<bool> streamSubscription;
  String enteredPasscode = '';
  AnimationController controller;
  Animation<double> animation;

  @override
  initState() {
    super.initState();
    streamSubscription = widget.shouldTriggerVerification
        .listen((isValid) => _showValidation(isValid));
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    final Animation curve =
        CurvedAnimation(parent: controller, curve: ShakeCurve());
    animation = Tween(begin: 0.0, end: 10.0).animate(curve)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            enteredPasscode = '';
            controller.value = 0;
          });
        }
      })
      ..addListener(() {
        setState(() {
          // the animation object’s value is the changed state
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor ?? Colors.black.withOpacity(0.8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  color: widget.titleColor,
                  fontWeight: FontWeight.w300),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20, left: 60, right: 60),
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _buildCircles(),
              ),
            ),
            IntrinsicHeight(
              child: Container(
                margin: const EdgeInsets.only(top: 20, left: 40, right: 40),
                child: Keyboard(
                  onDeleteCancelTap: _onDeleteCancelButtonPressed,
                  onKeyboardTap: _onKeyboardButtonPressed,
                  shouldShowCancel: enteredPasscode.length == 0,
                  cancelLocalizedText: widget.cancelLocalizedText,
                  deleteLocalizedText: widget.deleteLocalizedText,
                  keyboardUIConfig: widget.keyboardUIConfig != null
                      ? widget.keyboardUIConfig
                      : KeyboardUIConfig(),
                ),
              ),
            ),
            widget.bottomWidget != null ? widget.bottomWidget : Container()
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCircles() {
    var list = <Widget>[];
    var config = widget.circleUIConfig != null
        ? widget.circleUIConfig
        : CircleUIConfig();
    config.extraSize = animation.value;
    for (int i = 0; i < widget.passwordDigits; i++) {
      list.add(Circle(
        filled: i < enteredPasscode.length,
        circleUIConfig: config,
      ));
    }
    return list;
  }

  _onDeleteCancelButtonPressed() {
    if (enteredPasscode.length > 0) {
      setState(() {
        enteredPasscode =
            enteredPasscode.substring(0, enteredPasscode.length - 1);
      });
    } else {
      Navigator.maybePop(context);

      if (widget.cancelCallback != null) {
        widget.cancelCallback();
      }
    }
  }

  _onKeyboardButtonPressed(String text) {
    setState(() {
      if (enteredPasscode.length < widget.passwordDigits) {
        enteredPasscode += text;
        if (enteredPasscode.length == widget.passwordDigits) {
          widget.passwordEnteredCallback(enteredPasscode);
        }
      }
    });
  }

  @override
  didUpdateWidget(PasscodeScreen old) {
    super.didUpdateWidget(old);
    // in case the stream instance changed, subscribe to the new one
    if (widget.shouldTriggerVerification != old.shouldTriggerVerification) {
      streamSubscription.cancel();
      streamSubscription = widget.shouldTriggerVerification
          .listen((isValid) => _showValidation(isValid));
    }
  }

  @override
  dispose() {
    controller.dispose();
    streamSubscription.cancel();
    super.dispose();
  }

  _showValidation(bool isValid) {
    if (isValid) {
      Navigator.maybePop(context).then((pop) => _validationCallback());
    } else {
      controller.forward();
    }
  }

  _validationCallback() {
    if (widget.isValidCallback != null) {
      widget.isValidCallback();
    } else {
      print(
          "You didn't implement validation callback. Please handle a state by yourself then.");
    }
  }
}

//--
class ShakeCurve extends Curve {
  @override
  double transform(double t) {
    //t from 0.0 to 1.0
    return sin(t * 3 * pi).abs();
  }
}