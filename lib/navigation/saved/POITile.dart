import 'package:flutter/material.dart';
import 'package:mobile/navigation/explore/map.dart';
import 'package:mobile/navigation/userNavigationBar.dart';

import 'POI.dart';
import 'categoryScreen.dart';

class POITile extends StatelessWidget {
  const POITile({required this.poi, Key? key}) : super(key: key);

  final POI poi;

  void _pushScreen() {
    final dynamic navigationBar = globalKey.currentWidget;
    navigationBar.onTap(0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushScreen(),
      child: SizedBox(
        width: 200,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Spacer(),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage("res/areeVerdi.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const Spacer(),
            Text(
              poi.id,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
            const Spacer(),
            Text(
              poi.rank.toString(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}