import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projetflutter_nam/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projetflutter_nam/imagemanager.dart';
import 'package:projetflutter_nam/notifications.dart';
import 'package:projetflutter_nam/utilities.dart';

class NewTaskPage extends StatefulWidget {
  NewTaskPage(
      {Key? key,
      this.id,
      this.title,
      this.desc,
      this.color = Colors.white,
      this.date,
      this.time,
      this.image,
      this.todolist,
      this.tags})
      : super(key: key);
  var id;
  final title;
  final desc;
  final color;
  final date;
  final time;
  final image;
  final List<dynamic>? todolist;
  final List<dynamic>? tags;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'color': color.value,
        'image': image,
        'date': date,
        'time': time,
        'todolist': todolist,
        'tags': tags,
      };

  @override
  State<NewTaskPage> createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final controllerTitle = TextEditingController();
  final controllerDescription = TextEditingController();

  final primaryColor = Colors.orange;
  final secondaryColor = Colors.orange.shade100;

  //attribut colorPicker
  Color myColor = Colors.white;

  //attribut ImagePicker
  //attribut
  Uint8List? imageUser;

  //attributs Date & Time Picker
  DateTime? date;
  TimeOfDay? time;
  String _date = "";
  String _time = "";

  String? valueString;

  List<dynamic>? todolist;

  List<dynamic>? tags;

  final controllerTag = TextEditingController();
  final controllerEtape = TextEditingController();

  void initState() {
    print("ID de la t??che: ${widget.id}");
    print("Titre de la t??che: ${widget.title}");
    print("Description de la t??che: ${widget.desc}");
    print("Couleur de la t??che: ${widget.color}");
    print("Date de la t??che: ${widget.date}");
    print("Heure de la t??che: ${widget.time}");

    todolist = widget.todolist ?? [];
    tags = widget.tags ?? [];

    myColor = widget.color;

    super.initState();
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  //M??thodes pour l'image picker
  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: source, maxHeight: 250, maxWidth: 250);

      if (image == null) return;

      Uint8List imageBytes = await image.readAsBytes();
      setState(() => {imageUser = imageBytes});
    } on PlatformException catch (e) {
      print('Impossible de recup??rer l"image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Container(
            child: Stack(children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 12.0,
                ),
                child: ListView(
                  children: [
                    imageUser != null
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Stack(children: <Widget>[
                              Center(
                                child: Container(
                                    child: Image.memory(
                                  imageUser!,
                                  width: 275,
                                  height: 275,
                                )),
                              ),
                              Positioned(
                                right: 45,
                                top: 30,
                                child: InkWell(
                                  child: Icon(Icons.remove_circle,
                                      size: 30, color: Colors.red),
                                  onTap: () {
                                    setState(
                                      () {
                                        imageUser = null;
                                      },
                                    );
                                  },
                                ),
                              )
                            ]),
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
                              color: Colors.grey,
                              size: 36.0,
                            ),
                          ),
                        ),
                        Expanded(
                            child: TextField(
                          autofocus: true,
                          onSubmitted: (value) {
                            print("Titre de la t??che: $value");
                          },
                          decoration: InputDecoration(
                              labelText: "Titre de la t??che",
                              hintText: "Entrer le titre de la t??che...",
                              hintStyle: TextStyle(
                                  fontSize: 18.0,
                                  color: myColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white),
                              labelStyle: TextStyle(
                                  color: myColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
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
                            color: myColor.computeLuminance() > 0.5
                                ? Colors.black
                                : Colors.white,
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
                        onSubmitted: (desc) {
                          print("Description de la t??che: $desc");
                        },
                        controller: controllerDescription,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Entrer la description de la t??che...",
                          labelStyle: TextStyle(
                              color: myColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 18.0),
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
                            decoration: InputDecoration(
                                hintText: "Entrer une ??tape...",
                                hintStyle: TextStyle(
                                    color: myColor.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myColor.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white),
                                ),
                                suffixIcon: IconButton(
                                  // Icon to
                                  icon: Icon(Icons.clear), // clear text
                                  onPressed: clearTextEtape,
                                  color: myColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                )),
                            controller: controllerEtape,
                            onSubmitted: (String text) {
                              setState(() {
                                todolist?.add({"etape": text, "isdone": false});
                              });
                              clearTextEtape();
                            },
                            style: TextStyle(
                              color: myColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                        ),
                        tags != null
                            ? Row(
                                children: tags!.map((data) {
                                  return TagWidget(
                                    text: data['tag'],
                                  );
                                }).toList(),
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                              )
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 10,
                            left: 25,
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                                hintText: "Ajouter un tag...",
                                hintStyle: TextStyle(
                                    color: myColor.computeLuminance() > 0.5
                                        ? Colors.black
                                        : Colors.white),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: myColor.computeLuminance() > 0.5
                                          ? Colors.black
                                          : Colors.white),
                                ),
                                suffixIcon: IconButton(
                                  // Icon to
                                  icon: Icon(Icons.clear), // clear text
                                  onPressed: clearTextTag,
                                  color: myColor.computeLuminance() > 0.5
                                      ? Colors.black
                                      : Colors.white,
                                )),
                            controller: controllerTag,
                            onSubmitted: (String text) {
                              setState(() {
                                tags?.add({"tag": text});
                              });
                              clearTextTag();
                            },
                            style: TextStyle(
                              color: myColor.computeLuminance() > 0.5
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                              top: 25,
                            ),
                            child: GestureDetector(
                              onLongPressUp: () {
                                setState(() => _date = ' ');
                                setState(() => _time = '- ');
                              },
                              child: ActionChip(
                                  backgroundColor:
                                      myColor.computeLuminance() > 0.5
                                          ? Colors.black12
                                          : Colors.white,
                                  label: Text("??ch??ance : ${_date}  ${_time}"),
                                  labelStyle: TextStyle(fontSize: 16.0),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                                'S??lectionner une ??ch??ance'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                child:
                                                    Icon(Icons.calendar_month),
                                                onPressed: () async {
                                                  DateTime? newDate =
                                                      await showDatePicker(
                                                    context: context,
                                                    locale: const Locale(
                                                        "fr", "FR"),
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(2022),
                                                    lastDate: DateTime(2100),
                                                    builder: (context, child) {
                                                      return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary:
                                                                primaryColor,
                                                            // <-- SEE HERE
                                                            onPrimary:
                                                                Colors.white,
                                                            // <-- SEE HERE
                                                            onSurface: Colors
                                                                .black, // <-- SEE HERE
                                                          ),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              primary: Colors
                                                                  .black, // button text color
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (newDate == null) return;
                                                  setState(
                                                      () => date = newDate);
                                                  _date =
                                                      "${newDate.day.toString().padLeft(2, '0')}-${newDate.month.toString().padLeft(2, '0')}-${newDate.year.toString()}";
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: primaryColor),
                                              ),
                                              ElevatedButton(
                                                child: Icon(Icons.more_time),
                                                onPressed: () async {
                                                  TimeOfDay? newTime =
                                                      await showTimePicker(
                                                    context: context,
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    builder: (context, child) {
                                                      return Theme(
                                                        data: Theme.of(context)
                                                            .copyWith(
                                                          colorScheme:
                                                              ColorScheme.light(
                                                            primary:
                                                                primaryColor,
                                                            // <-- SEE HERE
                                                            onPrimary:
                                                                Colors.white,
                                                            // <-- SEE HERE
                                                            onSurface: Colors
                                                                .black, // <-- SEE HERE
                                                          ),
                                                          textButtonTheme:
                                                              TextButtonThemeData(
                                                            style: TextButton
                                                                .styleFrom(
                                                              primary: Colors
                                                                  .black, // button text color
                                                            ),
                                                          ),
                                                        ),
                                                        child: child!,
                                                      );
                                                    },
                                                  );
                                                  if (newTime == null) return;

                                                  setState(
                                                      () => time = newTime);
                                                  _time =
                                                      "${newTime.hour.toString().padLeft(2, '0')}:${newTime.minute.toString().padLeft(2, '0')}";
                                                },
                                                style: ElevatedButton.styleFrom(
                                                    primary: primaryColor),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          );
                                        });
                                  }),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 25,
                            top: 25,
                          ),
                          //TODO add tags here
                        )
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 4.0,
            child: const Icon(Icons.add),
            backgroundColor: primaryColor,
            onPressed: () {
              final task = NewTaskPage(
                title: controllerTitle.text,
                desc: controllerDescription.text,
                color: myColor,
                image: ImageManager.bytesToBase64(imageUser),
                date: _date,
                time: _time,
                todolist: todolist,
                tags: tags,
              );
              createTask(task);
              if (date != null) {
                creerNotificationFinEcheance(
                    NotificationDateAndTime(date: date!, timeOfDay: time!));
              }
              //revenir en arri??re
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
                        title: Text('Choisir une couleur'),
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
              icon: Icon(Icons.image),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Importer une image'),
                        actions: <Widget>[
                          ElevatedButton(
                              child: Icon(Icons.image),
                              onPressed: () {
                                pickImage(ImageSource.gallery);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: primaryColor)),
                          ElevatedButton(
                              child: Icon(Icons.camera_alt),
                              onPressed: () {
                                pickImage(ImageSource.camera);
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: primaryColor)),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      );
                    });
              },
            ),
          ]),
          shape: AutomaticNotchedShape(
              RoundedRectangleBorder(), StadiumBorder(side: BorderSide())),
        ),
        backgroundColor: myColor);
  }

  Future createTask(NewTaskPage task) async {
    final docTask = FirebaseFirestore.instance.collection('taches').doc();
    task.id = docTask.id;

    final json = task.toJson();
    await docTask.set(json);
  }

  void clearTextEtape() {
    controllerEtape.clear();
  }

  void clearTextTag() {
    controllerTag.clear();
  }
}

/*
 * Author : Nicolas
 *  BottomAppBar
 *  Colopicker feature
 *  ImagePicker feature + M??thode PickImage();
 *  CreateButton
 *  + changement visuelle/graphique de la page
 *  M??thode date time picker
 */

/*
 * Author : Artur
 * cr??ation de la structure de la page
 * configuration pour l'envoi des donn??es vers firebase
 */

/*
 * Author : Artur et Nicolas
 * conversion de la couleur pour envoi sur firebase
 * rendre l'??tape et la case ?? cocher dynamique
 * fonction de cr??ation d'une t??che
 */

/*
 * Author : Manuel
 * Nouveau wraps pour un meilleure affichage
 * ??ch??ance (chip)
 * - Delete on longPress
 * Restructuration de la partie ajout de t??ches
 * Couleur du texte qui change en fonction du colorPicker
 */

/*
 * Author : Manuel et Nicolas
 * suppression de l'image
 */

/*
 * Authors : Manuel, Nicolas, Artur
 * Tags feature
 */
