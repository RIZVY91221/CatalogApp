import 'package:flutter/material.dart';
import 'package:food_delivery_app/src/pages/SignUp_page.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  bool _toggleVisiblity = true;

  @override
  Widget build(BuildContext context) {
    final loginBt = Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.cyan,
        child: MaterialButton(
          minWidth: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          onPressed: () {},
          child: Text("Login",
              textAlign: TextAlign.center,
              style: style.copyWith(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ));
    return Scaffold(
      body: Center(
        child: ListView(
          padding: const EdgeInsets.only(top: 100.0),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                )
              ],
            ),
            ListTile(
              title: Card(
                elevation: 5.5,
                margin: const EdgeInsets.only(top: 100.0),
                child: Container(
                    height: 220,
                    width: 300,
                    decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15)),
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          controller: null,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                              left: 10.0,
                            ),
                            hintText: "Email or phone Number",
                            icon: Icon(Icons.person),
                            labelText: "User Info",
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        TextField(
                          controller: null,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(left: 10.0),
                            hintText: " Password",
                            icon: Icon(Icons.lock),
                            labelText: "User Password",
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _toggleVisiblity = !_toggleVisiblity;
                                });
                              },
                              icon: _toggleVisiblity
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),
                          obscureText: _toggleVisiblity,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 40.5),
                            ),
                            Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.5),
                            )
                          ],
                        )
                      ],
                    )),
              ),
            ),
            Divider(
              height: 20.0,
            ),
            ListTile(
              title: loginBt,
            ),
            Divider(
              height: 12.5,
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't Have Account?"),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) => SignUp()));
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.greenAccent),
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
