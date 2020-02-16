import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/pages/homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myapp/pages/login.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'dart:ui' as ui;

class RegisterPage extends StatefulWidget {
  
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
  
  @override

  String _nama, _email, _password, id, _image, _image2;
  File pickedImage;
  File pickedImage2;
  bool isImageLoaded = false;
  bool isImageLoaded2 = false;
  ui.Image _imageFile;
  List<Face> _faces;
  
  final _formKey = GlobalKey<FormState>();
  final db = Firestore.instance;

   _loadImage(File file) async {
    final data = await file.readAsBytes();
    await decodeImageFromList(data).then(
      (value) => setState(() {
        _imageFile = value;
        isImageLoaded = false;
      }),
    );
  }
  //Revisi
  Future pickImage() async{
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);    

    setState(() {
      if(tempStore==null){
        return;
      }
      pickedImage =tempStore;
      isImageLoaded = true;
      print('Image Path $pickedImage');
    });
    detectFaces(pickedImage);
  }
   
   detectFaces(File imageFile) async {
    final tempStore = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector = FirebaseVision.instance.faceDetector();
    List<Face> faces = await faceDetector.processImage(tempStore);
    if (mounted) {
      setState(() {
        pickedImage = imageFile;
        _faces = faces;
        _loadImage(imageFile);
      });
    }
  }
  //Revisi
  Future pickImage2() async{
    var tempStore2 = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if(tempStore2==null){
        return;
      }
      pickedImage2 =tempStore2;
      isImageLoaded2 = true;
      print('Image Path $pickedImage2');
    });
  }
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
    Future<void> addPic() async{
      _image = basename(pickedImage.path);
      StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(_image);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(pickedImage);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

      _image2 = basename(pickedImage2.path);
      StorageReference firebaseStorageRef2 = FirebaseStorage.instance.ref().child(_image2);
      StorageUploadTask uploadTask2 = firebaseStorageRef2.putFile(pickedImage2);
      StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;

    }

     Future<void> addPic2() async{

      _image2 = basename(pickedImage2.path);
      StorageReference firebaseStorageRef2 = FirebaseStorage.instance.ref().child(_image2);
      StorageUploadTask uploadTask2 = firebaseStorageRef2.putFile(pickedImage2);
      StorageTaskSnapshot taskSnapshot2 = await uploadTask2.onComplete;

    }

    Future<void> addData() async {
        DocumentReference ref = await db.collection('User').add({
          'KTP' : _image,
          'closeup' : _image2,
          'nama' : _nama,
          'email' : _email,
          'password' : _password  
        });
        setState(()=> id = ref.documentID);{
          print(ref.documentID);
        };
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
                addPic();
                addPic2();
                addData();
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: _email,
                  password: _password).then((user){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> LoginPage()), (Route<dynamic> route)=> false);
                  }).catchError((e){
                    print(e);
                    throw(e);
                });
            },
            padding: EdgeInsets.all(12),
            color: Colors.deepOrange,
            child: Text('Sign Up', style: TextStyle(color: Colors.white)
          ),
        )
      );
    
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
        padding: EdgeInsets.only(left: 30.0, right: 30.0),
        children: <Widget>[
           SizedBox(height: 20.0),
            logo,
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
                 child :FittedBox(
                        child: SizedBox(
                          width: _imageFile.width.toDouble(),
                          height: _imageFile.height.toDouble(),
                          child: CustomPaint(
                            painter: FacePainter(_imageFile, _faces),
                          ),
                        ),
                      ),
              ),
            ],
          ) : Container(),
          SizedBox(
            height :10.0),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: pickImage,
            padding: EdgeInsets.all(10),
            color: Colors.grey[700],
            child: Text('Foto KTP', style: TextStyle(color: Colors.white),
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: pickImage2,
            padding: EdgeInsets.all(10),
            color: Colors.grey[700],
            child: Text('Foto Closeup', style: TextStyle(color: Colors.white), 
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

class FacePainter extends CustomPainter {
  final ui.Image tempStore;
  final List<Face> faces;
  final List<Rect> rects = [];

  FacePainter(this.tempStore, this.faces) {
    for (var i = 0; i < faces.length; i++) {
      rects.add(faces[i].boundingBox);
    }
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15.0
      ..color = Colors.yellow;

    canvas.drawImage(tempStore, Offset.zero, Paint());
    for (var i = 0; i < faces.length; i++) {
      canvas.drawRect(rects[i], paint);
    }
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return tempStore != oldDelegate.tempStore || faces != oldDelegate.faces;
  }
}