import 'dart:convert';

import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final id;
  final title;
  final desc;
  late final Color color;
  late final date;
  late final time;
  late final image;

  TaskCardWidget(
      {required this.title,
      required this.desc,
      required this.color,
      this.id,
      this.date,
      this.time,
      this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 32.0,
        horizontal: 24.0,
      ),
      margin: const EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 2,
          blurRadius: 4,
          offset: Offset(0, 3),
        )
      ], color: color, borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Center(
              child: image != null
                  ? Image.memory(
                      base64Decode(image),
                      width: 200,
                      height: 200,
                    )
                  : null,
            ),
          ),
          Text(
            title ?? "(unnamed task)",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            child: Text(
              desc ?? "no description added",
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                height: 1.5,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: Chip(
                label: date.isNotEmpty && date != ' '
                    ? Text("Échéance : ${date}  ${time}")
                    : Text("Pas d'échéance"),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ToDoWidget extends StatelessWidget {
  final text;
  bool isDone = false;

  Function onChange;

  ToDoWidget({this.text, required this.isDone, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Row(
        children: [
          GestureDetector(
            child: Container(
              width: 20.0,
              height: 20.0,
              margin: const EdgeInsets.only(
                right: 12.0,
              ),
              child: Icon(
                isDone ? Icons.check_box : Icons.check_box_outline_blank,
                color: Colors.blueGrey,
                size: 24.0,
              ),
            ),
            onTap: () => onChange(),
          ),
          Text(
            //text ?? "Entrer un élément à effectuer",
            text,
            style: const TextStyle(
              //color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TagWidget extends StatelessWidget {
  final text;

  TagWidget({this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      // espace entre widget
      child: Chip(
        label: Text(
          "#" + text,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

/*
* Author : Artur
* création de la structure des deux widgets
*/
/*
* Author : Nicolas
* ajout des composants nécessaires pour image, date et heure
*/
/*
* Author : Manuel
* ajout de l'image dans la taskcard
* ajout de l'échéance dans la taskcard
*/

/*
 * Authors : Manuel, Nicolas, Artur
 * Tags widget
 */
