import 'dart:convert';

import 'package:brainhouse_client/activity/app_theme/app_theme.dart';
import 'package:brainhouse_client/activity/client_login_page.dart';
import 'package:brainhouse_client/activity/widget/constrant_login_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:http/http.dart' as http;

class ClientSignup extends StatefulWidget {
  @override
  _ClientSignupState createState() => _ClientSignupState();
}

class _ClientSignupState extends State<ClientSignup> {
  TapGestureRecognizer _recognizer1, _recognizer2;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userType='client';
  var passKey = GlobalKey<FormFieldState>();
  bool _isLoading = false;
  bool _autoValidate = false;
  bool rememberMe = false;
  bool contains_eight_characters = false;
  bool contains_number = false;
  bool contains_special_character = false;
  bool contains_uppercase = false;
  bool validpass=false;

  String fName;
  String lName;
  String email;
  String cName;
  String web;
  String password;
  String confirmPassword;
  int passwordLength;


  @override
  void initState() {
    // TODO: implement initState
    _recognizer1 = TapGestureRecognizer()
      ..onTap = () {
        print("tapped");
      };
    _recognizer2 = TapGestureRecognizer()
      ..onTap = () {
        print("double tapped");
      };
    super.initState();
  }

  final EmailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    PatternValidator(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        errorText: 'Please Enter valid email')
  ]);
  final nameValidation = MultiValidator([
    MinLengthValidator(3, errorText: 'Name must At least 3 Charecter'),
  ]);

  signIn(String type,String companyName,String confirmPass,bool eightChar,bool number,
      bool specialChar,bool upperCase,String userEmail,String fristName,
      String lastName,String userPass,bool checkTerm,int passlen,bool validPass,String webAddres) async {
    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      "user_type": type,
      "first_name": fristName,
      "last_name": lastName,
      "company_name": companyName,
      "website_address": webAddres,
      "email": userEmail,
      "password": userPass,
      "terms_condition": checkTerm,
      "confirm_password": confirmPass,
      "password_length": passlen,
      "contains_eight_characters": eightChar,
      "contains_number": number,
      "contains_uppercase": upperCase,
      "contains_special_character": specialChar,
      "valid_password": validPass

    };
    var body=json.encode(data);
    //var jsonResponse = null;
    var response = await http.post("https://brainhouse.net/apiv2/register",
        body:body,headers: {"Content-Type": "application/json"}).then((response){
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if(response.statusCode == 200) {
//        jsonResponse = json.decode(response.body);
//        print(jsonResponse.toString());
        if(response != null) {
          setState(() {
            _isLoading = false;
          });
          Fluttertoast.showToast(
            msg: "SignUp Sucessfully ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: AppTheme.bhb,
            textColor: Colors.white,
            fontSize: 16.0
        );

          //sharedPreferences.setString("token", jsonResponse['token']);
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
              builder: (BuildContext context) => NewLoginPage()), (
              Route<dynamic> route) => false);
        }
      }
      else {
        setState(() {
          _isLoading = false;
        });
        print(response.body);
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppTheme.bhb, AppTheme.nearlyWhite],
          tileMode: TileMode.mirror,
        )),
        child: ListView(
          children: <Widget>[
            _isLoading?Center(child: SpinKitWave(color: AppTheme.bhb, type: SpinKitWaveType.center),)
                :Container(
              child: Form(
                key: _formKey,
                autovalidate: _autoValidate,
                child: FormUI(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget FormUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: 15.0,
        ),
        Center(
          child: Text(
            "Sign up for free.",
            style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyWhite),
          ),
        ),
        Center(
          child: Text(
            "Join Thousands of Companies That Use Brainhouse Every Day !",
            style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyWhite),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10),
          child: Text(
            "Frist Name",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                  decoration: InputDecoration(
                    //labelText: "Frist Name",
                    hintText: "Enter Frist Name",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    labelStyle: const TextStyle(
                        color: AppTheme.nearlyBlack, fontSize: 18.0),
                  ),
                  keyboardType: TextInputType.text,
                  validator: nameValidation,
                  onChanged: (val) => fName = val,
                  onSaved: (val) {
                    fName = val;
                  },
                ))),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 10),
          child: Text(
            "Last Name",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                  decoration: InputDecoration(
                    // labelText: "Last Name",
                    hintText: "Enter Last name",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    labelStyle: const TextStyle(
                        color: AppTheme.nearlyBlack, fontSize: 18.0),
                  ),
                  keyboardType: TextInputType.text,
                  validator: nameValidation,
                  onChanged: (val) => lName = val,
                  onSaved: (val) {
                    lName = val;
                  },
                ))),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 10),
          child: Text(
            "Email Address",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                    decoration: InputDecoration(
                      //labelText: "Last Name",
                      hintText: "Enter Email Address",
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.bh),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: AppTheme.bh),
                      ),
                      labelStyle: const TextStyle(
                          color: AppTheme.nearlyBlack, fontSize: 18.0),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) => email = val,
                    validator: EmailValidator,
                    onSaved: (val) {
                      email = val;
                    }))),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 10),
          child: Text(
            "Company Name",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                  decoration: InputDecoration(
                    // labelText: "Last Name",
                    hintText: "Enter Your Company Name",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    labelStyle: const TextStyle(
                        color: AppTheme.nearlyBlack, fontSize: 18.0),
                  ),
                  keyboardType: TextInputType.text,
                  validator: nameValidation,
                  onChanged: (val) => cName = val,
                  onSaved: (val) {
                    cName = val;
                  },
                ))),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 10),
          child: Text(
            "Web Address",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                  decoration: InputDecoration(
                    // labelText: "Last Name",
                    hintText: "Enter Your Web Address",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    labelStyle: const TextStyle(
                        color: AppTheme.nearlyBlack, fontSize: 18.0),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (String val) {
                    bool _validURL = Uri.parse(val).isAbsolute;
                    if (!_validURL) {
                      return "Enter valid web address";
                    }
                    return null;
                  },
                  onChanged: (val) => web = val,
                  onSaved: (val) {
                    web = val;
                  },
                ))),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 10),
          child: Text(
            "Password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                  key: passKey,
                  decoration: InputDecoration(
                    // labelText: "Last Name",
                    hintText: "Enter Password",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    labelStyle: const TextStyle(
                        color: AppTheme.nearlyBlack, fontSize: 18.0),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (String val) {
                    if(val.length>=8){
                      contains_eight_characters=true;
                    }
                    if(val.isNotEmpty && !val.contains(RegExp(r'^[\w&.-]+_'), 0)){
                      contains_special_character=true;
                    }
                    if(val.contains(RegExp(r'\d'), 0)){
                      contains_number=true;
                    }
                    if(val.contains(new RegExp(r'[A-Z]'), 0)){
                      contains_uppercase=true;
                    }
//                    contains_eight_characters ==val.length >= 8;
//                    contains_special_character == val.isNotEmpty &&
//                        !val.contains(RegExp(r'^[\w&.-]+_'), 0);
//                    contains_number == val.contains(RegExp(r'\d'), 0);
//                    contains_uppercase == val.contains(new RegExp(r'[A-Z]'), 0);

                    if (!_allValidate()) {
                      return 'Enter valid Password';
                    }
                    validpass=true;
                    return null;
                  },
                  onChanged: (val) => password = val,
                  onSaved: (val) {
                    password = val;
                    passwordLength=val.length;
                  },
                ))),
        Padding(
          padding: EdgeInsets.only(top: 8, left: 10),
          child: Text(
            "Confirm Password",
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.nearlyBlack),
          ),
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, right: 10, left: 10),
            child: Container(
                color: AppTheme.nearlyWhite,
                child: TextFormField(
                  decoration: InputDecoration(
                    // labelText: "Last Name",
                    hintText: "Re-enter Your Password",
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: AppTheme.bh.withOpacity(0.1)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.bh),
                    ),
                    labelStyle: const TextStyle(
                        color: AppTheme.nearlyBlack, fontSize: 18.0),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (val) {
                    String password = passKey.currentState.value;
                    if (val != password) {
                      return 'Please check your password';
                    }
                    return null;
                  },
                  onChanged: (val) => confirmPassword = val,
                  onSaved: (val) {
                    confirmPassword = val;
                  },
                ))),
        SizedBox(
          height: 10,
        ),
        Padding(
            padding: EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              child: _buildRememberMeCheckbox(),
            )),
        _buildLoginBtn()
      ],
    );
  }

  Widget _buildRememberMeCheckbox() {
    var underlineStyle = TextStyle(
        decoration: TextDecoration.underline,
        color: Colors.black,
        fontSize: 16);
    return Container(
      height: 15.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: AppTheme.bh),
            child: Checkbox(
              value: rememberMe,
              checkColor: AppTheme.bhb,
              activeColor: AppTheme.bh,
              onChanged: (val) {
                if (rememberMe == false) {
                  setState(() {
                    rememberMe = true;
                  });
                } else if (rememberMe == true) {
                  setState(() {
                    rememberMe = false;
                  });
                }
              },
            ),
          ),
          Expanded(
              child: RichText(
            text: TextSpan(
                text: "I have read & accept Brainhouse ",
                style: underlineStyle.copyWith(decoration: TextDecoration.none),
                children: <TextSpan>[
                  TextSpan(
                      text: ' Privacy Policy  ',
                      style: underlineStyle,
                      recognizer: _recognizer1),
                  TextSpan(text: 'And '),
                  TextSpan(
                      text: 'Terms of Uses ',
                      style: underlineStyle,
                      recognizer: _recognizer2)
                ]),
          ))
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: _validateInputs,
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Sign Up',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  void _validateInputs() {
    if (_formKey.currentState.validate()) {
//    If all data are correct then save data to out variables
      _formKey.currentState.save();

       setState(() {
         _isLoading=true;
       });

      signIn(userType,cName, confirmPassword, contains_eight_characters,contains_number, contains_special_character, contains_uppercase,
          email, fName, lName, password, rememberMe,passwordLength, validpass, web);
    print(passwordLength);
    print (contains_uppercase);
    print(userType);

    } else {
//    If all data are not valid then start auto validation.
      setState(() {
        _autoValidate = true;
      });
    }
  }

  bool _allValidate() {
    return contains_special_character &&
        contains_uppercase &&
        contains_eight_characters &&
        contains_number;
  }

}
