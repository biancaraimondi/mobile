import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  const CategoryTile(
      {required this.category,
        required this.imageUrl,
        this.imageAlignment = Alignment.center,
        Key? key})
      : super(key: key);
  final String imageUrl;
  final String category;

  final Alignment imageAlignment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/category', arguments: category),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image(
                image: AssetImage(imageUrl),
                fit: BoxFit.cover
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                category.toUpperCase(),
                style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Colors.white,
                    background: Paint()
                      ..color = Colors.black.withOpacity(.5)
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}