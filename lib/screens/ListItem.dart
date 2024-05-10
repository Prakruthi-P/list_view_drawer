import 'package:flutter/material.dart';
class ListItem extends StatelessWidget {
  final String item_name;
  final String page;
  const ListItem({super.key, required this.item_name, required this.page});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(item_name,
          style: const TextStyle(
            fontSize: 20,

          ),),
          onTap: () {
            Navigator.pushNamed(context, page);// Close the drawer
          },
        ),
      ],
    );
  }
}
