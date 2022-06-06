import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projetflutter_nam/screens/taskpage.dart';

class CustomSearchDelegate extends SearchDelegate {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("taches");

  List<String> searchTerms = [];

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
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['title']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    element['desc']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()) ||
                    element['tags']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return Center(
                child: Text("Aucun résultat trouvé",
                    style: TextStyle(fontSize: 18)),
              );
            }
            print(snapshot.data);
            return ListView(children: [
              ...snapshot.data!.docs
                  .where((QueryDocumentSnapshot<Object?> element) =>
                      element['title']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      element['desc']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      element['tags']
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()))
                  .map((QueryDocumentSnapshot<Object?> data) {
                final String title = data['title'];
                final List<dynamic> tags = data['tags'];
                final String desc = data['desc'];

                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Taskpage(
                                id: data.id,
                                title: data.get('title'),
                                desc: data.get('desc'),
                                color: data['color'] != null
                                    ? Color(data['color'])
                                    : Colors.white,
                                date: data.get('date'),
                                time: data.get('time'),
                                image: data.get('image'),
                                todolist: data.get('todolist'),
                                tags: data.get('tags'))));
                  },
                  title: Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Text(" - "),
                      Text(desc)
                    ],
                  ),
                  subtitle: Row(
                    children: tags.map((data) {
                      return Text(
                        " #" + data['tag'],
                        style: TextStyle(fontSize: 15),
                      );
                    }).toList(),
                  ),
                );
              }),
            ]);
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(
        "Cherchez par titre, description, tags...",
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}

/*
 * Authors : Manuel, Nicolas, Artur
 * Search feature
 */
