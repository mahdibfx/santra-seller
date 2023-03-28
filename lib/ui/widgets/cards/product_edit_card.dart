import 'package:flutter/material.dart';


class ProductEditCard extends StatelessWidget {
  final String title;
  final bool outOfStock;
  final void Function(bool)? onChanged;
  const ProductEditCard({super.key, required this.title, this.outOfStock = false, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Switch(
          value: outOfStock,
          onChanged:onChanged
        ),
      ),
    );
  }
}