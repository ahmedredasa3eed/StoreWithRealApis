import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies/auth/signup-screen.dart';
import 'package:movies/models/exceptions.dart';
import 'package:movies/networking/user-helper.dart';
import 'package:movies/screens/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const route = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState(){
    super.initState();
    checkLogin();
  }

  checkLogin() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.getString('token') != null){
      Navigator.pushNamed(context, HomeScreen.route);
    }
  }

  final _key2 = GlobalKey<FormState>();

  String phone = '';
  String password = '';
  String token ='';
  var _isLoading = false;

  UserHelper userHelper = UserHelper();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Ok")),
          ],
        );
      },
    );
  }

  void _tryLoginUser() async {
    try {
      print(token);
      final isValid = _key2.currentState.validate();
      if (isValid) {
        setState(() {
          _isLoading = true;
        });
        _key2.currentState.save();

        SharedPreferences preferences = await SharedPreferences.getInstance();
        if(preferences.getString('token') != null)
          {
            token = preferences.getString('token');
          }
          await userHelper.login(phone, password, token);
          Navigator.pushReplacementNamed(context, HomeScreen.route);
      }
    } on FetchDataException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var errorMessage = error;
      _showErrorDialog(errorMessage.toString());
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      var errorMessage = error;
      _showErrorDialog(errorMessage.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(
            child: SpinKitChasingDots(
            color: Colors.blue,
              size: 50.0,
            ),
          )
        : Stack(
            children: <Widget>[
              Image.asset(
                'assets/images/bg4.jpg',
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
              ),
              Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: Align(
                    alignment: Alignment.topCenter,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(48),
                        child: Form(
                          key: _key2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 40),
                              ),
                              SizedBox(
                                height: 55,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "رقم الجوال مطلوب";
                                  } else
                                    return null;
                                },
                                keyboardType: TextInputType.phone,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'رقم الجوال',
                                  hintText: '05XXXXXXXX',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusColor: Colors.black,
                                ),
                                onSaved: (newValue) {
                                  phone = newValue;
                                },
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return "كلمة المرور مطلوبة";
                                  } else
                                    return null;
                                },
                                style: TextStyle(color: Colors.black),
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'كلمة المرور',
                                  hintText: '******',
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.black,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  border: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusColor: Colors.black,
                                ),
                                onSaved: (newValue) {
                                  password = newValue;
                                },
                              ),
                              SizedBox(
                                height: 24,
                              ),
                              InkWell(
                                onTap: _tryLoginUser,
                                child: Container(
                                  width: 150,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.lightGreenAccent,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(25),
                                      bottomRight: Radius.circular(25),
                                      bottomLeft: Radius.circular(25),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        'دخول',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Color(0xFF358D1E),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 48,
                              ),
                              FlatButton(
                                onPressed: () {},
                                child: Text(
                                  'نسيت كلمة المرور ؟',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()));
                                },
                                child: Text(
                                  "ليس لديك حساب ! تسجيل",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 55,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}
