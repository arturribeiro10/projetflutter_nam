import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projetflutter_nam/screens/taskpage.dart';
import 'package:projetflutter_nam/widgets.dart';
import 'dart:async';
import 'package:projetflutter_nam/searchbarmanagement.dart';
import 'newtaskpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final primaryColor = Colors.orange;
  final secondaryColor = Colors.orange.shade100;
  final Stream<QuerySnapshot> _tasksStream =
      FirebaseFirestore.instance.collection('taches').snapshots();

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Notifications'),
                  content: Text(
                      'Notre application aimerait vous envoyer des notifications'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Ne pas autoriser',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    TextButton(
                        onPressed: () => AwesomeNotifications()
                            .requestPermissionToSendNotifications()
                            .then((_) => Navigator.pop(context)),
                        child: Text(
                          'Autoriser',
                          style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ));
      }
    });
  }

  @override
  void dispose() {
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 0.0,
          ),
          color: secondaryColor,
          child: Expanded(
            child: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: StreamBuilder<QuerySnapshot>(
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
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children:
                          snapshot.data!.docs.map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Taskpage(
                                      id: document.id,
                                      title: document.get('title'),
                                      desc: document.get('desc'),
                                      color: data['color'] != null
                                          ? Color(data['color'])
                                          : Colors.white,
                                      date: document.get('date'),
                                      time: document.get('time'),
                                      image: document.get('image'),
                                      todolist: document.get('todolist')),
                                ));
                          },
                          child: TaskCardWidget(
                            id: data['id'],
                            title: data['title'],
                            desc: data['desc'],
                            color: data['color'] != null
                                ? Color(data['color'])
                                : Colors.white,
                            date: data['date'],
                            time: data['time'],
                            image: data['image'],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ]),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewTaskPage()),
          );
        },
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
    );
  }
}

/*
 * Author : Nicolas
 *  AppBar avec la barre de recherche
 *  + changement visuelle/graphique de la page
 */
/*
 * Author : Artur
 * création de la structure de la page
 * récupération des données depuis firebase
 * envoi des données vers la taskpage
 */
/*
 * Author : Manuel
 * redesign de la page
 * restructuration de la page en listview
 * + bouton flottant add new
 */
