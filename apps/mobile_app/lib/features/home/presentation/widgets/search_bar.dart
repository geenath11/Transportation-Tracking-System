import 'package:flutter/material.dart';
import '../../../passenger/presentation/screen/map_search_page.dart';

Widget buildSearchBar(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,

        MaterialPageRoute(builder: (context) => const MapSearchPage()),
      );
    },

    child: Container(
      height: 55,

      decoration: BoxDecoration(
        color: Colors.grey.shade100,

        borderRadius: BorderRadius.circular(15),
      ),

      child: const Row(
        children: [
          SizedBox(width: 15),

          Icon(Icons.search),

          SizedBox(width: 10),

          Text("Where do you want to go?"),
        ],
      ),
    ),
  );
}
