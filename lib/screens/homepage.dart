import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projetflutter_nam/screens/taskpage.dart';
import 'package:projetflutter_nam/widgets.dart';
import 'dart:async';

import 'newtaskpage.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Stream<QuerySnapshot> _tasksStream =
      FirebaseFirestore.instance.collection('taches').snapshots();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            horizontal: 24.0,
            //vertical: 32.0,
          ),
          color: Color(0xFFB0BEC5),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 32.0,
                    bottom: 32.0,
                  ),
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
                        return
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>  Taskpage(
                                          id: document.id,
                                          title: document.get('title'),
                                          desc: document.get('desc'),
                                          color: data['color'] != null ? Color(data['color']) : Colors.white,
                                          date: document.get('date'),
                                          time: document.get('time'),
                                          image: document.get('image'),
                                          todolist: document.get('todolist')
                                      ),
                                  )
                              );
                            },
                            child: TaskCardWidget(
                              id: data['id'],
                              title: data['title'],
                              desc: data['desc'],
                              color: data['color'] != null ? Color(data['color']) : Colors.white,
                          ),

                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
            Positioned(
                bottom: 24.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewTaskPage(
                              )),
                    );
                  },
                  child: Container(
                      child: Icon(
                    Icons.add_box_rounded,
                    size: 72.0,
                    color: Colors.blue,
                  )),
                )),
          ]),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Travail',
    'Personnel',
    'Urgent',
    'Important',
    'Vacances'
  ];

  @override
  //Nettoie la requête
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  //Quitter et fermer la searchbar
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var tags in searchTerms) {
      if (tags.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(tags);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    for (var fruit in searchTerms) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}

/*
 * Author : Nicolas
 *  AppBar avec la barre de recherche
 *  Méthodes de "comportement" de la searchBar
 *  + changement visuelle/graphique de la page
 */

/*
 * Author : Artur
 */
