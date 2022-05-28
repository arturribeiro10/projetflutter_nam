import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetflutter_nam/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'homepage.dart';

class Taskpage extends StatefulWidget {
  Taskpage({Key? key, required this.id, this.title, this.desc, this.color, this.date, this.time, this.image}) : super(key: key);
  final id;
  final title;
  final desc;
  final color;
  final date;
  final time;
  final image;




  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {

  final Stream<QuerySnapshot> _tasksStream =
  FirebaseFirestore.instance.collection('todo').snapshots();

  final fktache = FirebaseFirestore.instance.collection("taches");

  //Uint8List base64Decode(String img64) => base64.decode(img64);
  //String decoded = stringToBase64.decode(img64);

  //attribut colorPicker
  Color myColor = Colors.white;
  //attribut ImagePicker
  File? image;
  //attributs Date & Time Picker
  DateTime? date;
  TimeOfDay? time;
  String _date = "";
  String _time = "";


  String _taskTitle = '';

  void initState(){
    print("ID de la tâche: ${widget.id}");
    print("Titre de la tâhe: ${widget.title}");
    print("Description de la tâhe: ${widget.desc}");
    print("Couleur de la tâhe: ${widget.color}");
    print("Date de la tâhe: ${widget.date}");
    print("Heure de la tâhe: ${widget.time}");
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
        //backgroundColor: myColor,
        backgroundColor: Color(int.parse('${widget.color}')),
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
                      : Text(''),
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
                            //hintText: "Entrer le titre de la tâche",
                            hintText: "${widget.title}",
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
                          //hintText: "Entrer le description de la tâche",
                          hintText: "${widget.desc}",
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
                        /*
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
                        */
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: _tasksStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Text("Loading");
                          }
                          return ListView(
                            shrinkWrap: true,
                            children:snapshot.data!.docs.map((DocumentSnapshot document) {
                              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                              return ToDoWidget(
                                    isDone: data['isdone'],
                                    text: data['etape'],
                                    fktache: data['fktache'],
                                  );
                            }).toList(),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          top: 25,
                        ),
                        child: Row(
                          children: [
                            Text((() {
                              /*
                              if (date == null) {
                                return "Pas de date de fin";
                              }*/
                              //return "Date de fin : ${_date}  ${_time}";
                              return "Date de fin : ${widget.date}  ${widget.time}";
                            })())
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            elevation: 4.0,
            icon: const Icon(Icons.update),
            label: const Text("Mettre à jour"),
            backgroundColor: Colors.grey,
            onPressed: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.white70,
          child: Row(mainAxisSize: MainAxisSize.max,
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
              iconSize: 36.0,
              icon: Icon(Icons.calendar_month),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Sélectionner une date'),
                        actions: <Widget>[
                          ElevatedButton(
                            child: Icon(Icons.calendar_month),
                            onPressed: () async {
                              DateTime? newDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2022),
                                lastDate: DateTime(2100),
                              );
                              if (newDate == null) return;
                              setState(() => date = newDate);
                              _date = "${newDate.day.toString().padLeft(2,'0')}-${newDate.month.toString().padLeft(2,'0')}-${newDate.year.toString()}";
                            },
                          ),
                          ElevatedButton(
                            child: Icon(Icons.more_time),
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                              );
                              if(newTime == null) return;

                              setState(() => time = newTime);
                              _time = "${newTime.hour}:${newTime.minute}";
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
