import 'package:flutter/material.dart';

class TaskCardWidget extends StatelessWidget {
  final id;
  final title;
  final desc;
  late final Color color;
  late final date;
  late final time;

  TaskCardWidget({required this.title, required this.desc, required this.color, this.id, this.date, this.time});

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
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 4,
            offset: Offset(0, 3),
          )
        ],
          color: color,
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
          ),
          Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
                child: Chip(
                  label: Text("Échéance : ${date}  ${time}"),
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
class NoGlowScroll extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}


/*
* Author(s) : Artur Ribeiro
*/
