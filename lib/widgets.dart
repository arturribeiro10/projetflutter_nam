import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final title;
  final desc;
  late final color;

  TaskCardWidget({required this.title, required this.desc, this.color = const Color(0xFFFFFFFF)});

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
      decoration: BoxDecoration(
          //color : Color(0xB00F0FFF),
          //color: Color(color) ?? Colors.white,
          color: Color(int.parse(color)),
          borderRadius: BorderRadius.circular(20.0)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? "(unnamed task)",
            style: const TextStyle(
              color: Colors.blueGrey,
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
                color: Colors.blueGrey,
                height: 1.5,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ToDoWidget extends StatelessWidget {
  String text;
  bool isDone;

  ToDoWidget(this.text,
      this.isDone, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 12.0,
      ),
      child: Row(
        children: [
          Container(
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


/*
* Author(s) : Artur Ribeiro
*/
