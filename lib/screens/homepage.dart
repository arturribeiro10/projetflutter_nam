import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projetflutter_nam/widgets.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
            vertical: 32.0,
          ),
          color: Color(0xFFB0BEC5),
          child: Stack(
            children:[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      bottom: 32.0,
                    ),
                  ),
                  TaskCardWidget(
                      title: "Get Started",
                      desc: "hello user - description"
                  ),
                  TaskCardWidget(
                    title:"vide",
                    desc: "vide",
                  ),
                ],
              ),
              Positioned(
                bottom: 60.0,
                  right: 60.0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                      borderRadius: BorderRadius.circular(20.0)
                  ),
                  child: const Icon(
                    Icons.add_to_photos_outlined,
                    color: Color(0xFFB0BEC5),
                    size: 36.0,
                  ),
                ),
              )
            ]
        ),
        ),

      ),
    );
  }
}
