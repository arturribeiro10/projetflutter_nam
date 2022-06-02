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
import '../imagemanager.dart';
import 'homepage.dart';

class Taskpage extends StatefulWidget {
  Taskpage(
      {Key? key,
      required this.id,
      this.title,
      this.desc,
      this.color = Colors.white,
      this.date,
      this.time,
      this.image,
      this.todolist})
      : super(key: key);
  final id;
  late final title;
  late final desc;
  final Color color;
  final date;
  final time;
  final image;
  final List<dynamic>? todolist;

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  final Stream<QuerySnapshot> _tasksStream =
      FirebaseFirestore.instance.collection('todo').snapshots();

  final primaryColor = Colors.orange;
  final secondaryColor = Colors.orange.shade100;


  //attribut colorPicker
  late Color myColor;
  //attribut imagepicker
  Uint8List? imageUser;
  //attributs Date & Time Picker
  DateTime? date;
  TimeOfDay? time;
  String _date = "";
  String _time = "";

  //String? valueString;

  List<dynamic> todolist = [];

  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();
  final controllerEtape = TextEditingController();

  void initState() {
    print("ID de la tâche: ${widget.id}");
    print("Titre de la tâche: ${widget.title}");
    print("Description de la tâche: ${widget.desc}");
    print("Couleur de la tâche: ${widget.color}");
    print("Date de la tâche: ${widget.date}");
    print("Heure de la tâche: ${widget.time}");
    print("Image de la tâche: ${widget.image}");
    print("imageUser:  $imageUser");

    if (widget.image != null) {
      imageUser = base64Decode(widget.image);
    } else {
      imageUser = null;
    }

    todolist = widget.todolist ?? [];
    controllerTitle.text = widget.title;
    controllerDescription.text = widget.desc;
    myColor = widget.color;

    super.initState();
  }

  //Méthodes pour l'image picker
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, maxHeight: 250, maxWidth: 250);

      if (image == null) return;

      Uint8List imageBytes = await image.readAsBytes();
      setState(() => {imageUser = imageBytes});
    } on PlatformException catch (e) {
      print('Impossible de recupérer l"image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: myColor,
        body: SafeArea(
          child: Container(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                    ),
                    //La condition nulle est valable pour la newTaskPage mais pas pour l'update -> crash l'appli
                    // TODO faire une condition NULL avec l'image FIREBASE
                    imageUser != null
                        ? Image.memory(
                            imageUser!,
                            width: 275,
                            height: 275,
                          )
                        : Text(''),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 22.0,
                              right: 10.0,
                            ),
                            child: Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.black,
                              size: 36.0,
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          onSubmitted: (String text) {
                            if (text.isEmpty) {
                              return;
                            }
                            setState(() {
                              widget.title = text;
                            });
                          },
                          decoration: InputDecoration(
                              labelText: "Titre de la tâche",
                              hintText: "Entrer le titre de la tâche...",
                              hintStyle: TextStyle(fontSize: 18.0),
                              labelStyle: TextStyle(
                                  color: Colors.black54,
                                  fontWeight: FontWeight.normal),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.transparent, width: 2.0),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 2, color: Colors.black54),
                                borderRadius: BorderRadius.circular(15),
                              )),
                          controller: controllerTitle,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        top: 8.0,
                        bottom: 8.0,
                        right: 10.0,
                        left: 12.0,
                      ),
                      child: TextField(
                        maxLines: 3,
                        minLines: 1,
                        maxLength: 100,
                        onSubmitted: (String text) {
                          if (text.isEmpty) {
                            return;
                          }
                          setState(() {
                            widget.desc = text;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Entrer la description de la tâche...",
                          labelStyle:
                              TextStyle(color: Colors.black54, fontSize: 18.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.transparent, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2, color: Colors.black54),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        controller: controllerDescription,
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                        ),
                        todolist != null
                            ? ListView(
                                shrinkWrap: true,
                                children: todolist!.map((data) {
                                  return ToDoWidget(
                                    isDone: data['isdone'],
                                    text: data['etape'],
                                    onChange: () => setState(() {
                                      data['isdone'] = !data['isdone'];
                                    }),
                                  );
                                }).toList(),
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                          ),
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                                hintText: "Entrer une étape...",
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                suffixIcon: IconButton(
                                  // Icon to
                                  icon: Icon(Icons.clear), // clear text
                                  onPressed: clearText,
                                )),
                            controller: controllerEtape,
                            onSubmitted: (String text) {
                              print("etape $text");
                              if (text.isEmpty) {
                                return;
                              }
                              setState(() {
                                todolist.add({"etape": text, "isdone": false});
                              });
                              clearText();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            top: 25,
                          ),
                          child: ActionChip(
                              label: Text("Échéance : ${_date}  ${_time}"),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Sélectionner une échéance'),
                                        actions: <Widget>[
                                          ElevatedButton(
                                            child: Icon(Icons.calendar_month),
                                            onPressed: () async {
                                              DateTime? newDate =
                                              await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(2022),
                                                lastDate: DateTime(2100),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(
                                                      colorScheme: ColorScheme.light(
                                                        primary: primaryColor, // <-- SEE HERE
                                                        onPrimary: Colors.white, // <-- SEE HERE
                                                        onSurface: Colors.black, // <-- SEE HERE
                                                      ),
                                                      textButtonTheme: TextButtonThemeData(
                                                        style: TextButton.styleFrom(
                                                          primary: Colors.black, // button text color
                                                        ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );
                                              if (newDate == null) return;
                                              setState(() => date = newDate);
                                              _date =
                                              "${newDate.day.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.year.toString()}";
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: primaryColor
                                            ),
                                          ),
                                          ElevatedButton(
                                            child: Icon(Icons.more_time),
                                            onPressed: () async {
                                              TimeOfDay? newTime =
                                              await showTimePicker(
                                                context: context,
                                                initialTime: TimeOfDay.now(),
                                                builder: (context, child) {
                                                  return Theme(
                                                    data: Theme.of(context).copyWith(
                                                      colorScheme: ColorScheme.light(
                                                        primary: primaryColor, // <-- SEE HERE
                                                        onPrimary: Colors.white, // <-- SEE HERE
                                                        onSurface: Colors.black, // <-- SEE HERE
                                                      ),
                                                      textButtonTheme: TextButtonThemeData(
                                                        style: TextButton.styleFrom(
                                                          primary: Colors.black, // button text color
                                                        ),
                                                      ),
                                                    ),
                                                    child: child!,
                                                  );
                                                },
                                              );
                                              if (newTime == null) return;

                                              setState(() => time = newTime);
                                              _time =
                                              "${newTime.hour}:${newTime.minute}";
                                            },
                                            style: ElevatedButton.styleFrom(
                                                primary: primaryColor
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    });
                              }),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 4.0,
            child : const Icon(Icons.update),
            backgroundColor: primaryColor,
            onPressed: () {
              final docTask = FirebaseFirestore.instance
                  .collection('taches')
                  .doc(widget.id);
              docTask.update({
                'title': controllerTitle.text,
                'desc': controllerDescription.text,
                'color': myColor.value,
                'image': ImageManager.bytesToBase64(imageUser),
                'date': _date,
                'time': _time,
                'todolist': todolist,
              });
              //revenir en arrière
              Navigator.pop(context);
            }),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: secondaryColor,
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
                        title: Text('Modifier la couleur'),
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
                            child: const Text('OK'),
                            onPressed: () {
                              //couleurFinal = int.parse(valueString, radix: 16);
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
                              _date =
                                  "${newDate.day.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.year.toString()}";
                            },
                          ),
                          ElevatedButton(
                            child: Icon(Icons.more_time),
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              );
                              if (newTime == null) return;

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
                final toDo = FirebaseFirestore.instance
                    .collection('taches')
                    .doc(widget.id);
                toDo.delete();

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Homepage()),
                );
              },
            )
          ]),
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
        ));
  }


  void clearText() {
    controllerEtape.clear();
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
