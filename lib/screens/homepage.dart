import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:projetflutter_nam/screens/taskpage.dart';
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
                Expanded(
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Taskpage(id: 0,)
                              )
                          );
                        },
                        child: TaskCardWidget(
                            title: "Première tâche",
                            desc: "mettre en place flutter"),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Taskpage(id: 1,)
                              )
                          );
                        },
                        child: TaskCardWidget(
                          title: "Deuxième tâche",
                          desc: "créer unt tâche",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Taskpage(id: 2,)
                              )
                          );
                        },
                        child: TaskCardWidget(
                            title: "Troisième tâche",
                            desc: "rendre les tâches dynamiques"
                        ),
                      ),
                    ],
                  ),
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
                          builder: (context) => Taskpage(id: 0,)
                      ),
                    );
                  },
                  child: Container(
                      child: Icon(
                        Icons.add_box_rounded,
                        size: 72.0,
                        color: Colors.blue,
                      )
                  ),
                )
            ),
          ]),
        ),
      ),
    );
  }
}

      /*
      * Author(s) : Nicolas Corminboeuf
      * Class qui gère les comportements de la searchBar
      * TODO : faire en sorte que les suggestions de recherche soit les tags que le user valide dans des tâches
      */
class CustomSearchDelegate extends SearchDelegate {
  List<String> searchTerms = [
    'Mangue',
    'Kiwi',
    'Fraise',
    'Pomme',
    'Ananas'
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
