import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetflutter_nam/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'homepage.dart';

class Taskpage extends StatefulWidget {
  const Taskpage({Key? key}) : super(key: key);

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  Color myColor = Colors.white;
  File? image;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myColor,
      body: SafeArea(
          child: Container(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.blueGrey,
                            size: 36.0,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: TextField(
                        decoration: InputDecoration(
                          hintText: "Entrer le titre de la tâche",
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ))
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    bottom: 8.0,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        hintText: "Entrer le description de la tâche",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 24.0,
                        )),
                  ),
                ),
                ToDoWidget("vide", true),
                ToDoWidget("vide", false),
              ],
            ),
            ]),
          ),
      ),
        floatingActionButton: FloatingActionButton.extended(
            elevation: 4.0,
            icon: const Icon(Icons.add),
            label: const Text("Create"),
            backgroundColor: Colors.grey,
            onPressed: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white70,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  iconSize: 36.0,
                  icon: Icon(
                    Icons.color_lens_outlined,
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Choisis une couleur'),
                            content: SingleChildScrollView(
                              child: ColorPicker(
                                pickerColor: myColor, //default color
                                onColorChanged: (Color color) {
                                  //on color picked
                                  setState(() {
                                    myColor = color;
                                  });
                                },
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: const Text('Valider'),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); //dismiss the color picker
                                },
                              ),
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Importer une image'),
                            actions: <Widget>[
                              MaterialButton(
                                  child: Icon(Icons.image),
                                  onPressed: () {
                                    pickImageGallery();
                                  }),
                              MaterialButton(
                                  child: Icon(Icons.camera_alt),
                                  onPressed: () {
                                    pickImageCamera();
                                  }),
                              MaterialButton(
                                child: Icon(Icons.close),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pop(); //dismiss the color picker
                                },
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              image != null
                                  ? Image.file(image!)
                                  : Text('No image selected')
                            ],
                          );
                        });
                  },
                ),
                IconButton(
                  iconSize: 36.0,
                  icon: Icon(Icons.delete_forever_rounded,
                      color: Colors.redAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Homepage()),
                    );
                  },
                )
              ]
          ),
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
        )
    );
  }


  //Méthodes pour l'image picker
  Future pickImageGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e){
      print('pas pu récup l image: $e');
    }
  }

  Future pickImageCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if(image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch(e){
      print('pas pu récup l image: $e');
    }
  }
}

