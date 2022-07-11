import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mobile/models/poi.dart';
import 'package:mobile/navigation/saved/poi_tile.dart';
import 'package:mobile/globals.dart' as globals;

import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({required this.category, Key? key}) : super(key: key);
  final String category;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}


class _CategoryScreenState extends State<CategoryScreen> {

  final username = globals.getUsername();
  String get category => widget.category;

  @override
  void initState() {
    super.initState();
  }

  Future<List<POITile>> getSavedPois(String username, String category) async {
    final response = await http
        .get(
      Uri.parse('http://localhost:3001/me/poi/$username'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final pois = await jsonDecode(response.body);
      List<POI> poiList = [];
      for (var poi in pois['POIs']) {
        poiList.add(POI.fromJson(poi));
      }
      switch (category){
        case "edifici storici":
          category = "historical building";
          break;
        case "parchi":
          category = "park";
          break;
        case "teatri":
          category = "theater";
          break;
        case "musei":
          category = "museum";
          break;
        case "dipartimenti":
          category = "department";
          break;
        default:
          category = "error";
          break;
      }

      poiList = poiList.where((p) => p.type == category).toList();
      return poiList.map((p) => POITile(poi: p)).toList();
    } else {
      throw Exception('Failed to call http request');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<POITile>>(
      future: getSavedPois(username, category),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: Text(category.toUpperCase())
              ),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                      itemCount: snapshot.data?.length ?? 5,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (_, index) => snapshot.data?[index] ?? Container(),
                      separatorBuilder: (_, index) => const SizedBox(
                        height: 5,
                      ),
                    ),
                  ),
                ],
              )
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}