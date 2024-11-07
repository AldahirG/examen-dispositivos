import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details_view.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controladores para los datos de los productos
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();

  // Función para agregar un nuevo producto a Firestore
  Future<void> _addProduct() async {
    await _firestore.collection('productos').add({
      'description': _descriptionController.text,
      'imagen': _imageController.text,
      'precio': double.tryParse(_priceController.text) ?? 0,
    });
    _nameController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _imageController.clear();
  }

  // Función para eliminar un producto de Firestore
  Future<void> _deleteProduct(String productId) async {
    await _firestore.collection('productos').doc(productId).delete();
  }

  // Función para navegar a la vista de detalles del producto
  void _navigateToDetails(Map<String, dynamic> productData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(productData: productData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('productos').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay productos disponibles'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((product) {
              Map<String, dynamic> data = product.data() as Map<String, dynamic>;
              String tagText;
              Color tagColor;

              // Determina el texto y color del tag según el precio
              if (data['precio'] > 1000) {
                tagText = 'Gasto alto';
                tagColor = Colors.red;
              } else if (data['precio'] <= 1000 && data['precio'] >= 500) {
                tagText = 'Cuidado';
                tagColor = Colors.orange;
              } else {
                tagText = 'Bajo';
                tagColor = Colors.green;
              }

              return GestureDetector(
                onTap: () => _navigateToDetails(data),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: Image.network(
                      data['imagen'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                    ),
                    title: Text('\$${data['precio']}'),
                    subtitle: Text(data['description']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
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
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product.id),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.bluetooth),
            label: 'Bluetooth',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Gastos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        onTap: (index) {
          if (index == 2) {
            Navigator.pushNamed(context, '/profile'); // Navega a la vista de perfil
          }
        },
      ),

    );
  }

  // Diálogo para agregar un nuevo producto
  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Añadir Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _imageController,
              decoration: InputDecoration(labelText: 'URL de Imagen'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _addProduct();
              Navigator.pop(context);
            },
            child: Text('Añadir'),
          ),
        ],
      ),
    );
  }
}
