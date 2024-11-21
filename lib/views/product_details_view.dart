import 'package:flutter/material.dart';

class ProductDetailsView extends StatelessWidget {
  final Map<String, dynamic> productData;

  ProductDetailsView({required this.productData});

  @override
  Widget build(BuildContext context) {
    String tagText;
    Color tagColor;

    final DateTime currentDate = DateTime.now();
    final List<String> dateParts = productData['fechaExpiracion'].split('-'); 
    final DateTime expirationDate = DateTime(
      int.parse(dateParts[2]), 
      int.parse(dateParts[1]), 
      int.parse(dateParts[0]), 
    );

    if (expirationDate.isBefore(currentDate)) {
      tagText = 'Póliza expirada';
      tagColor = Colors.red;
    } else if (expirationDate.difference(currentDate).inDays <= 30) {
      tagText = 'Póliza próxima a expirar';
      tagColor = Colors.orange;
    } else {
      tagText = 'Póliza al corriente';
      tagColor = Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Vehículo'),
        backgroundColor: Colors.blue[100],
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
                  child: productData['imageUrl'] != null && productData['imageUrl'].isNotEmpty
                      ? Image.network(
                          productData['imageUrl'],
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.broken_image, size: 100),
                        )
                      : Icon(
                          Icons.directions_car,
                          size: 100,
                          color: Colors.blueAccent,
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
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Número de Póliza: ${productData['numeroPoliza']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Marca: ${productData['marca']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Modelo: ${productData['modelo']}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Fecha de Expiración: ${productData['fechaExpiracion']}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
