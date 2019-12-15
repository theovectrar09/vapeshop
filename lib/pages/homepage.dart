import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  File pickedImage;
  bool isImageLoaded = false;
  final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'E-mail',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  
  Future pickImage() async{
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      pickedImage =tempStore;
      isImageLoaded = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: Text('Myfirstapp'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: <Widget>[
         isImageLoaded ? Center(
            child: Container(
              height: 200.0,
              width: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: FileImage(pickedImage),fit: BoxFit.cover
                )
              ),
            ),

          ) : Container(),
          SizedBox(
            height :10.0),
          RaisedButton(
            child: Text('Pick an Image'),
            onPressed: pickImage,
          ),
          SizedBox(height: 10.0,),
        ],
      ),
    );
  }
}