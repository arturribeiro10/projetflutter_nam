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
      /*
      * Author(s) : Nicolas Corminboeuf
      * AppBar with searchBar
      */
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
      /*
      * Author(s) : Artur Ribeiro
      */
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
                      TaskCardWidget(
                          title: "Get Started",
                          desc: "hello user - description"),
                      TaskCardWidget(
                        title: "vide",
                        desc: "vide",
                      ),
                      TaskCardWidget(title: "vifde", desc: "dafdesc")
                    ],
                  ),
                )
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
                    Icons.add_to_photos_outlined,
                    color: Color(0xFFB0BEC5),
                    size: 36.0,
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

      /*
      * Author(s) : Nicolas Corminboeuf
      * Class who manages the searchbar
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

