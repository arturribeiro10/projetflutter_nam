import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projetflutter_nam/widgets.dart';

class Taskpage extends StatefulWidget {
  const Taskpage({Key? key}) : super(key: key);

  @override
  State<Taskpage> createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Positioned(
              bottom: 60.0,
              right: 60.0,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Taskpage()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: const Icon(
                    Icons.delete_forever_rounded,
                    color: Color(0xFFB0BEC5),
                    size: 36.0,
                  ),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}