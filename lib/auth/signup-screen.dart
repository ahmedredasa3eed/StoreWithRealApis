
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:movies/auth/login_screen.dart';
import 'package:movies/models/exceptions.dart';
import 'package:movies/networking/user-helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {

  static const route = 'signUp-screen';

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  var _isLoading = false;

  final _key = GlobalKey<FormState>();

  String dropdownCity = 'Jeddah';
  String name = '';
  String password = '';
  String mobile = '';

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

  void _tryRegisterUser() async {
    final isValid = _key.currentState.validate();
    if (isValid) {
      setState(() {
        _isLoading = true;
      });
      _key.currentState.save();
      try{
        await userHelper.register(mobile, name, password, dropdownCity);

        SharedPreferences preferences = await SharedPreferences.getInstance();
        if(preferences.getString('token') != null){
          setState(() {
            _isLoading = false;
          });
          Navigator.pushReplacementNamed(context, LoginScreen.route);
        }

      } on FetchDataException catch(error){
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(error.toString());
      } catch (error){
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(error.toString());
      }

    }
  }

  @override
  Widget build(BuildContext context) {

    return _isLoading ? Center(
      child: SpinKitChasingDots(
      color: Colors.blue,
      size: 50.0,
    ),)
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
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'حساب جديد',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 40),
                        ),
                        SizedBox(
                          height: 55,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value.isEmpty){
                              return "الاسم مطلوب";
                            }
                            else return null;
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'الاسم',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusColor: Colors.black,
                          ),
                          onSaved: (value){
                            name = value;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          validator: (value){
                            if(value.isEmpty){
                              return "رقم الجوال مطلوب";
                            }
                            else if (value.length <9){
                              return "يجب ان لا يقل رقم الجوال عن ١٠ ارقام";
                            }
                            else return null;
                          },
                          keyboardType: TextInputType.phone,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            labelText: 'رقم الجوال',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusColor: Colors.black,
                          ),
                          onSaved: (value){
                            mobile = value;
                          },
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        DropdownButton<String>(
                          value: dropdownCity,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 20,
                          elevation: 16,
                          style: TextStyle(color: Colors.black,fontSize:16),
                          underline: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1.0,
                                  color: Colors.black
                                ),
                              )
                            ),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownCity = newValue;
                            });
                          },
                          items: <String>['Jeddah', 'Yanbu', 'Riyadh', 'Makkah'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),

                        SizedBox(
                          height: 16,
                        ),


                        TextFormField(
                          validator: (value){
                            if(value.isEmpty){
                              return "كلمة المرور مطلوبة";
                            }
                            else if (value.length <6){
                              return "يجب ان تكون كلمة المرور ٦ حروف على  الأقل";
                            }
                            else return null;
                          },
                          style: TextStyle(color: Colors.black),
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'كلمة المرور',
                            labelStyle: TextStyle(
                              color: Colors.black,
                            ),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                            focusColor: Colors.black,
                          ),
                          onSaved: (value){
                            password = value;
                          },
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        InkWell(
                          onTap:  _tryRegisterUser,
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
                                  'تسجيل',
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
                          onPressed: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
                          },
                          child: Text(
                            "لديك حساب ! تسجيل الدخول",
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
