import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
  TextEditingController correo = TextEditingController();
  TextEditingController contrasena = TextEditingController();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0), // Espacio a los lados
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Título visual (opcional, ayuda al diseño)
        const Text(
          "Bienvenido",
          style: TextStyle(
            fontSize: 30, 
            fontWeight: FontWeight.bold, 
            color: Colors.blueAccent
          ),
        ),
        const SizedBox(height: 30), // Separación

        // Input Correo
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
        
        const SizedBox(height: 20), // Separación entre inputs

        // Input Contraseña
        TextField(
          controller: contrasena,
          obscureText: true, // Oculta el texto visualmente (puntos)
          decoration: InputDecoration(
            labelText: 'Ingresar Contraseña',
            prefixIcon: const Icon(Icons.lock_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        const SizedBox(height: 30), // Separación botón

        // Botón Estilizado
        SizedBox(
          width: double.infinity, // Ocupa todo el ancho disponible
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              elevation: 5,
            ),
            onPressed: () => login(correo.text, contrasena.text, context),
            child: const Text(
              'Iniciar sesión',
              style: TextStyle(color: Colors.white, fontSize: 18),
            )
          ),
        ),
      ],
    ),
  );
}

// Lógica intacta
Future<void> login(correo, contrasena, context) async {
  try {
    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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