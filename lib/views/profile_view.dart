import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        backgroundColor: Colors.pink[100],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user?.photoURL ?? 'https://imgs.search.brave.com/H5TPoAAJ4NW1WQHE2kXyM3e_HA5qtavQtYezSPZyW4o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9vdWNo/LWNkbjIuaWNvbnM4/LmNvbS9pYVN2V3g4/MVlZelhna2RsaHRR/NFZWWWkzZm9qSklD/OU1HS3ZNZjF5R0tz/L3JzOmZpdDozNjg6/MzY4L2N6TTZMeTlw/WTI5dWN6Z3UvYjNW/amFDMXdjbTlrTG1G/ei9jMlYwY3k5d2Jt/Y3ZOVFk1L0x6SXlZ/V05oWVRjd0xUSTQv/T1RBdE5HVXdaQzA0/WkdGai9MVEkyWm1G/bVpESmpOelkyL1lT/NXdibWMucG5n'),
            ),
            const SizedBox(height: 20),
            
            Text(
              user?.displayName ?? 'Milton jaimes',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
           
            Text(
              user?.email ?? 'Correo no disponible',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 40),
            
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacementNamed(context, '/login'); 
              },
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
