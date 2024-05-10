import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ListItem.dart';

class ListViewPage extends StatefulWidget {
  const ListViewPage({Key? key}) : super(key: key);

  @override
  State<ListViewPage> createState() => _ListViewPageState();
}

class _ListViewPageState extends State<ListViewPage> {
  List<String> fullNameList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      fetchData();
    });

  }
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://35.200.153.236/development/testfiles/prakruthi_list.php'));

    if (response.statusCode == 200) {
      // Data fetched successfully
      print('Response Body: ${response.body}'); // Print response body

      // Extract the JSON string from the response body
      String jsonString = response.body.substring(response.body.indexOf('['));

      // Parse the JSON array
      List<dynamic> jsonData = json.decode(jsonString);

      // Convert dynamic list to string list
      List<String> jsonNames = jsonData.whereType<String>().toList();

      setState(() {
        fullNameList = jsonNames;
      });
    } else {
      // Failed to fetch data
      print('Failed to fetch data: ${response.statusCode}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              "Candidates",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          backgroundColor: Colors.indigo,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            },
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: 50,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                ),
                child: const Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              const ListItem(item_name: "Navigation1", page: "/page1"),
              const ListItem(item_name: "Navigation2", page: "/page2"),
              const ListItem(item_name: "Navigation3", page: "/page3"),
              const ListItem(item_name: "Navigation4", page: "/page4"),
              // Add more ListTiles for additional items in the drawer
            ],
          ),
        ),
        body: ListView.builder(
          itemCount: fullNameList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  title: Text(fullNameList[index]),
                  onTap: () {
                    // Handle onTap event if needed
                  },
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
