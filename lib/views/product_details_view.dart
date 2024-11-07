import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final Map<String, dynamic> productData;

  ProductDetailsView({required this.productData});

  @override
  Widget build(BuildContext context) {
    String tagText;
    Color tagColor;

    // Determina el texto y color del tag según el precio
    if (productData['precio'] > 1000) {
      tagText = 'Gasto alto';
      tagColor = Colors.red;
    } else if (productData['precio'] <= 1000 && productData['precio'] >= 500) {
      tagText = 'Cuidado';
      tagColor = Colors.orange;
    } else {
      tagText = 'Bajo';
      tagColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(productData['description']),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Image.network(
                    productData['imagen'],
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 100),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      tagText,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              productData['description'],
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Precio: \$${productData['precio']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Descripción:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              productData['description'],
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
