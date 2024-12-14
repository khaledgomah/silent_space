import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({super.key, required this.category, this.onDismissed});
  final String category;
  final void Function(DismissDirection)? onDismissed;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      secondaryBackground: Container(
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
        ),
      ),
      background: Container(color: Colors.red),
      onDismissed: onDismissed,
      key: Key(category),
      child: ListTile(
        title: Text(category),
      ),
    );
  }
}
