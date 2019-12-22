import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:myapp/pages/register.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 70.0,
        child: Image.asset('assets/12.png')
      ),
    );
    final email = Form(
      key:_formKey,
      child: Column(
        children: <Widget>[ 
          TextFormField(
            validator: (val) {
              if (val.isEmpty) {
                return 'Please enter an E-mail';
              }
              return null;
            },
            onChanged: (val){
              setState(() {
                _email = val;
            });
          },
          onSaved: (val) => _email = val,
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email,color: Colors.deepOrange),
            labelText: "E-mail",
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child:TextFormField(
            validator:(val){ 
              if (val.isEmpty) {
                return 'Please enter a Password';
              }
              return null;
            },
            onChanged: (val){
              setState(() {
                _password = val;
            });
          },
          onSaved: (val) => _password = val,
          autofocus: false,
          obscureText: true,
          decoration: InputDecoration(
            labelText: "Password",
            prefixIcon: Icon(Icons.lock,color: Colors.deepOrange),
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          )
        )
      )
    ]
  )
);

      final loginButton =
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0) ,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: _email,
                  password: _password).then((user){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Home()), (Route<dynamic> route)=> false);
                  }).catchError((e){
                    print(e);
                    throw(e);
                });
              }
            },
            padding: EdgeInsets.all(12),
            color: Colors.deepOrange,
            child: Text('Log In', style: TextStyle(color: Colors.white)
          ),
        )
      );
      
      final registerButton = Padding(
        padding: EdgeInsets.symmetric(horizontal: 70.0),
        child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RegisterPage()));},
            padding: EdgeInsets.all(12),
            color: Colors.grey[700],
            child: Text('Register', style: TextStyle(color: Colors.white)
          ),
        )
      );
   
      final forgotLabel = FlatButton(
        child: Text(
          'Forgot password?',
          style: TextStyle(color: Colors.black54)
        ),
        onPressed: () {

      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Myfirstapp'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 30.0, right: 30.0),
          children: <Widget>[
            SizedBox(height: 20.0),
            logo,
            SizedBox(height: 20.0),
            Text(
              "LOGIN",
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Lilita',fontSize: 25.0,color: Colors.deepOrange)
            ),
            SizedBox(height: 28.0),
            email,
            SizedBox(height: 8.0),
            // password,
            SizedBox(height: 24.0),
            loginButton,
            registerButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}