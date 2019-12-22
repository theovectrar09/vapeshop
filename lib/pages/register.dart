import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/login.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override

  String _nama, _email, _password;
  File pickedImage;
  File pickedImage2;
  bool isImageLoaded = false;
  bool isImageLoaded2 = false;
  final _formKey = GlobalKey<FormState>();
  
  Future pickImage() async{
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);    

    setState(() {
      if(tempStore==null){
        return;
      }
      pickedImage =tempStore;
      isImageLoaded = true;
    });
  }
  Future pickImage2() async{
    var tempStore2 = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage2 =tempStore2;
      isImageLoaded2 = true;
    });
  }
  @override
  Widget build(BuildContext context) {

    void addData(){
      FirebaseDatabase.instance.reference().child("1").set({
      'nama' : _nama,
      'email' : _email,
      'password' : _password  
      });

    // Firestore.instance.runTransaction((Transaction transsaction) async{
    //   CollectionReference reference = Firestore.instance.collection('User');
    //   await reference.add({
    //     "nama" : _nama,
    //     "email" : _email,
    //     "password" : _password
    //   });
    // });
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (Route<dynamic> route)=> false);
  }

    final nama = TextFormField(
      onChanged: (val){
        setState(() {
          _nama = val;
        });
      },
      onSaved: (val) => _nama = val,
      keyboardType: TextInputType.text,
      autofocus: false,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.account_box,color: Colors.deepOrange),
        labelText: "Nama Lengkap",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  
    final email = TextFormField(
      key: _formKey,
      onSaved: (val) => _email = val,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onChanged: (val){
              setState(() {
                _email = val;
            });
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.email,color: Colors.deepOrange),
        labelText: "E-mail",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final password = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onChanged: (val){
              setState(() {
                _password = val;
            });
          },
      onSaved: (val) => _email = val,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: Colors.deepOrange),
        labelText: "Password",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

      final currentpassword = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock,color: Colors.deepOrange),
        labelText: "Confirm Password",
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );


    final saveButton =
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 70.0) ,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
                addData();
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _email,
                  password: _password).then((user){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> Home()), (Route<dynamic> route)=> false);
                  }).catchError((e){
                    print(e);
                    throw(e);
                });
            },
            padding: EdgeInsets.all(12),
            color: Colors.deepOrange,
            child: Text('Log In', style: TextStyle(color: Colors.white)
          ),
        )
      );
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text('Myfirstapp'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: ListView(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        children: <Widget>[
          Text(
            'Register',
            textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Lilita',fontSize: 25.0,color: Colors.deepOrange)
          ),
         isImageLoaded ? Row(
            children: <Widget>[
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(pickedImage),fit: BoxFit.cover
                  )
                ),
              ),
            ],
          ) : Container(),
          SizedBox(
            height :10.0),
          RaisedButton(
            onPressed: pickImage,
            padding: EdgeInsets.all(10),
            color: Colors.grey[700],
            child: Text('Foto KTP', style: TextStyle(color: Colors.white)
          ),
        ),
        isImageLoaded2 ? Row(
            children: <Widget>[
              Container(
                height: 200.0,
                width: 200.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(pickedImage2),fit: BoxFit.cover
                  )
                ),
              ),
            ],
          ) : Container(),
          SizedBox(
            height :10.0),
          RaisedButton(
            onPressed: pickImage2,
            padding: EdgeInsets.all(10),
            color: Colors.grey[700],
            child: Text('Foto Closeup', style: TextStyle(color: Colors.white)
          ),
        ),
              SizedBox(height: 20.0),
              nama,
              SizedBox(height: 10.0),
              email,
              SizedBox(height: 10.0),
              password,
              SizedBox(height: 10.0),
              currentpassword,
              SizedBox(height: 10.0),
              saveButton
        ],
      ),
    );
  }
}