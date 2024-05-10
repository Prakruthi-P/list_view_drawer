import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Page1 extends StatefulWidget {
  const Page1({Key? key}) : super(key: key);

  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  List<String> items = [];

  final Map<String, Color> colorMap = {
    "amber": Colors.amber,
    "black": Colors.black,
    "blue": Colors.blue,
    "brown": Colors.brown,
    "cyan": Colors.cyan,
    "green": Colors.green,
    "grey": Colors.grey,
    "indigo": Colors.indigo,
    "lime": Colors.lime,
    "orange": Colors.orange,
    "pink": Colors.pink,
    "purple": Colors.purple,
    "red": Colors.red,
    "teal": Colors.teal,
    "transparent": Colors.transparent,
    "white": Colors.white,
    "yellow": Colors.yellow,
  };

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch colors when the page initializes
  }

  Future<void> fetchData() async {
    try {
      var response = await http.get(Uri.parse('http://192.168.1.46/Database_Connection/fetch_data.php'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        setState(() {
          items = List<String>.from(data); // Convert fetched data to a list of strings
        });
      } else {
        print('Failed to fetch data');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void deleteColor(String color) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.46/Database_Connection/delete_data.php'),
        body: {'color': color},
      );
      if (response.statusCode == 200) {
        print('Color deleted successfully');
        fetchData(); // Fetch updated data after deletion
      } else {
        print('Failed to delete color');
      }
    } catch (e) {
      print('Error deleting color: $e');
    }
  }


  void insertColor(String color) async {
    try {
      var response = await http.post(
        Uri.parse('http://192.168.1.46/Database_Connection/insert_data.php'),
        body: {'color': color},
      );
      if (response.statusCode == 200) {
        print('Color added successfully');
        fetchData(); // Fetch updated data after insertion
      } else {
        print('Failed to add color');
      }
    } catch (e) {
      print('Error adding color: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Center(
            child: Text(
              "Page1",
              style: TextStyle(
                fontSize: 30,
              ),
            ),
          ),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ColumnItems(
              text1: items[index],
              onDelete: () {
                deleteColor(items[index]);
              },
              colorMap: colorMap,
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add Color'),
                  content: DropdownButton<String>(
                    items: colorMap.keys.map((String color) {
                      return DropdownMenuItem<String>(
                        value: color,
                        child: Text(color),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      if (value != null) {
                        insertColor(value); // Call function to insert color
                        Navigator.of(context).pop(); // Close the dialog
                      }
                    },
                    hint: Text('Select a color'),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the dialog
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                );
              },
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class ColumnItems extends StatefulWidget {
  final String text1;
  final VoidCallback onDelete;
  final Map<String, Color> colorMap;

  const ColumnItems({
    Key? key,
    required this.text1,
    required this.onDelete,
    required this.colorMap,
  }) : super(key: key);

  @override
  _ColumnItemsState createState() => _ColumnItemsState();
}

class _ColumnItemsState extends State<ColumnItems> {
  Color backgroundColor = Colors.teal;

  @override
  void initState() {
    super.initState();
    //backgroundColor = widget.colorMap[widget.text1.toLowerCase()] ?? Colors.teal;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // Update the background color based on the text value
          backgroundColor = widget.colorMap[widget.text1.toLowerCase()] ?? Colors.teal;
        });
      },
      onLongPress: widget.onDelete,
      child: Container(
        padding: const EdgeInsets.all(30.0),
        margin: const EdgeInsets.all(20),
        width: 200,
        height: 100,
        color: backgroundColor,
        child: Center(
          child: Text(
            widget.text1,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
