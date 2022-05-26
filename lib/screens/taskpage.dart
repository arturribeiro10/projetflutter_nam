import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetflutter_nam/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'homepage.dart';

class Taskpage extends StatefulWidget {
  const Taskpage({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  Color myColor = Colors.white;
  File? image;

  String _taskTitle = '';

  void initState(){
    print("ID de la tâche: ${widget.id}");
    if(widget.id != null){
      _taskTitle = "nouveau";
    }

    super.initState();
  }

  //Méthodes pour l'image picker
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);

      if (image == null) return;

      final imageTemp = File(image.path);
      setState(() => this.image = imageTemp);
    } on PlatformException catch (e) {
      print('Impossible de recuprer l"image: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColor,
        body: SafeArea(
          child: Container(
            child: Stack(
                children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  image != null
                      ? Image.file(
                          image!,
                          width: 275,
                          height: 275,
                        )
                      : //Text('No image selected'),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 17.0,
                        bottom: 6.0,),
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
                        Expanded(
                            child: TextField(
                              onSubmitted: (value){
                                print("Titre de la tâche: $value");
                              },
                          decoration: InputDecoration(
                            hintText: "Entrer le titre de la tâche",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        )
                        )
                      ],
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.only(
                      bottom: 8.0,
                    ),
                    child: TextField(
                      onSubmitted: (desc){
                        print("Description de la tâche: $desc");
                      },
                      decoration: InputDecoration(
                          hintText: "Entrer le description de la tâche",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          )),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 20.0,
                              height: 20.0,
                              margin: const EdgeInsets.only(
                                right: 12.0,
                              ),
                              child: const Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.blueGrey,
                                size: 24.0,
                              ),
                            ),
                            Expanded(
                                child: TextField(
                                  onSubmitted: (value){
                                    print("Element à faire: $value");
                                  },
                                  decoration: const InputDecoration(
                                    hintText: "Entrer un élément à faire...",
                                    border: InputBorder.none,
                                  ),
                                ))
                          ],
                        ),
                      )
                    ],
                  )
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
          child: Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
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
                              print(myColor);
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
                                pickImage(ImageSource.gallery);
                              }),
                          MaterialButton(
                              child: Icon(Icons.camera_alt),
                              onPressed: () {
                                pickImage(ImageSource.camera);
                              }),
                          MaterialButton(
                            child: Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      );
                    });
              },
            ),
            IconButton(
              iconSize: 36.0,
              icon: Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
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
        ));
  }
}

/*
 * Author : Nicolas
 *  BottomAppBar
 *  Colopicker feature
 *  ImagePicker feature + Méthode PickImage();
 *  CreateButton
 *  + changement visuelle/graphique de la page
 */
