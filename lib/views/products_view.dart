import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'product_details_view.dart';
import 'profile_view.dart';

class ProductsView extends StatefulWidget {
  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProductsViewBody(),
    ProfileView(), // Tu vista de perfil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Vehículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

// Cuerpo de la vista de productos (listado de vehículos)
class ProductsViewBody extends StatefulWidget {
  @override
  _ProductsViewBodyState createState() => _ProductsViewBodyState();
}

class _ProductsViewBodyState extends State<ProductsViewBody> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _addVehicle(Map<String, dynamic> newVehicle) async {
    await _firestore.collection('vehicles').add(newVehicle);
  }

  Future<void> _deleteVehicle(String vehicleId) async {
    await _firestore.collection('vehicles').doc(vehicleId).delete();
  }

  void _navigateToDetails(Map<String, dynamic> vehicleData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(productData: vehicleData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehículos'),
        backgroundColor: Colors.blue[100],
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('vehicles').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No hay vehículos disponibles'));
          }

          return ListView(
            padding: EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((vehicle) {
              Map<String, dynamic> data = vehicle.data() as Map<String, dynamic>;

              return GestureDetector(
                onTap: () => _navigateToDetails(data),
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    leading: data['imageUrl'] != null && data['imageUrl'].isNotEmpty
                        ? Image.network(
                            data['imageUrl'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image),
                          )
                        : Icon(Icons.directions_car, size: 40),
                    title: Text('Poliza: ${data['numeroPoliza']}'),
                    subtitle: Text(
                      '${data['marca']} - ${data['modelo']}\nExpira: ${data['fechaExpiracion']}',
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteVehicle(vehicle.id),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddVehicleDialog(),
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddVehicleDialog() {
    String? numeroPoliza;
    String? marca;
    String? modelo;
    String? imageUrl;
    DateTime? fechaExpiracion;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Añadir Vehículo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: InputDecoration(labelText: 'Número de Póliza'),
                  onChanged: (value) => numeroPoliza = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Marca'),
                  onChanged: (value) => marca = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Modelo'),
                  onChanged: (value) => modelo = value,
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'URL de la Imagen'),
                  onChanged: (value) => imageUrl = value,
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        fechaExpiracion == null
                            ? 'Selecciona una fecha de expiración'
                            : 'Fecha de Expiración: ${fechaExpiracion!.day}/${fechaExpiracion!.month}/${fechaExpiracion!.year}',
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () async {
                        final DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            fechaExpiracion = pickedDate;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (numeroPoliza != null &&
                    marca != null &&
                    modelo != null &&
                    fechaExpiracion != null) {
                  final newVehicle = {
                    'numeroPoliza': numeroPoliza,
                    'marca': marca,
                    'modelo': modelo,
                    'fechaExpiracion':
                        '${fechaExpiracion!.day}-${fechaExpiracion!.month}-${fechaExpiracion!.year}',
                    'imageUrl': imageUrl ?? '',
                  };
                  _addVehicle(newVehicle);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, completa todos los campos')),
                  );
                }
              },
              child: Text('Añadir'),
            ),
          ],
        );
      },
    );
  }
}
