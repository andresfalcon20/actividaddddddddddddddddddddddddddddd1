import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Registro extends StatelessWidget {
  const Registro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          child: formulario(context),
        ),
      ),
    );
  }
}

Widget formulario(context) {
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Crear Cuenta",
          style: TextStyle(
            fontSize: 30, 
            fontWeight: FontWeight.bold, 
            color: Colors.deepPurple
          ),
        ),
        const SizedBox(height: 30),

        TextField(
          controller: nombre,
          decoration: InputDecoration(
            labelText: 'Ingresar Nombre', 
            prefixIcon: const Icon(Icons.person), 
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        
        const SizedBox(height: 20),

        TextField(
          controller: correo,
          decoration: InputDecoration(
            labelText: 'Ingresar Correo',
            prefixIcon: const Icon(Icons.email_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        
        const SizedBox(height: 20),

        TextField(
          controller: contrasena,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Ingresar Contraseña',
            prefixIcon: const Icon(Icons.vpn_key_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        const SizedBox(height: 30),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              elevation: 5,
            ),
            onPressed: () => login(correo.text, contrasena.text, context),
            child: const Text(
              'Registrarse', 
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ),
        ),
      ],
    ),
  );
}

Future<void> login(correo, contrasena, context) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: correo,
      password: contrasena,
    );
    Navigator.pushNamed(context, '/guardar');
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
  }
}
