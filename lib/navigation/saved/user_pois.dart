import 'package:flutter/material.dart';

import 'package:mobile/navigation/saved/category_tile.dart';

class UserPOIs extends StatefulWidget {
  const UserPOIs({Key? key}) : super(key: key);

  @override
  State<UserPOIs> createState() => _UserPOIsState();
}

class _UserPOIsState extends State<UserPOIs> {

  @override
  Widget build(BuildContext context) {
    var listViewPadding =
    const EdgeInsets.symmetric(horizontal: 16, vertical: 40);
    return Scaffold(
      body: ListView(
        padding: listViewPadding,
        children: const [
          SizedBox(height: 16),
          CategoryTile(
            imageUrl: "res/historical_building.jpg",
            category: 'edifici storici',
            imageAlignment: Alignment.topCenter,
          ),
          SizedBox(height: 16),
          CategoryTile(
            imageUrl: "res/park.jpg",
            category: 'parchi',
            imageAlignment: Alignment.topCenter,
          ),
          SizedBox(height: 16),
          CategoryTile(
            imageUrl: "res/theater.jpg",
            category: 'teatri',
          ),
          SizedBox(height: 16),
          CategoryTile(
            imageUrl: "res/museum.jpg",
            category: 'musei',
          ),
          SizedBox(height: 16),
          CategoryTile(
            imageUrl: "res/department.jpg",
            category: 'dipartimenti',
          ),
        ],
      ),
    );
  }
}