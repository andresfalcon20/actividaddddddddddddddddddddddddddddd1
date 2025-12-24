import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Guardar extends StatelessWidget {
  const Guardar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Registrar Gasto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: formulario(context),
        ),
      ),
    );
  }
}

Widget formulario(context) {
  TextEditingController id = TextEditingController();
  TextEditingController titulo = TextEditingController();
  TextEditingController detalle = TextEditingController();
  TextEditingController precio = TextEditingController();

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- CAMPO ID (Manual) ---
        TextField(
          controller: id,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'ID (Ej: 1, 2...)',
            prefixIcon: const Icon(Icons.numbers),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // --- CAMPO TITULO ---
        TextField(
          controller: titulo,
          decoration: InputDecoration(
            labelText: 'Título',
            prefixIcon: const Icon(Icons.label_outline),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // --- CAMPO DETALLE ---
        TextField(
          controller: detalle,
          decoration: InputDecoration(
            labelText: 'Descripción',
            prefixIcon: const Icon(Icons.description_outlined),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        const SizedBox(height: 20),

        // --- CAMPO PRECIO ---
        TextField(
          controller: precio,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Precio',
            prefixIcon: const Icon(Icons.attach_money),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),

        const SizedBox(height: 30),

        // BOTÓN
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 5,
            ),
            // Llamamos a la función
            onPressed: () => guardar(id.text, titulo.text, detalle.text, precio.text, context),
            child: const Text(
              'Guardar Gasto',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
        
        // Botón para ir a ver la lista (Opcional)
        const SizedBox(height: 20),
        TextButton(
          onPressed: () => Navigator.pushNamed(context, '/leer'), 
          child: const Text(
            'Ver Lista',
            style: TextStyle(
              fontSize: 16, 
              color: Colors.deepPurple, 
              decoration: TextDecoration.underline
            ),
          ),
        )
      ],
    ),
  );
}

Future<void> guardar(String id, String titulo, String detalle, String precio, context) async {
  
  // Si falta algo, solo imprimimos en consola y no hacemos nada
  if (id.isEmpty || titulo.isEmpty || precio.isEmpty) {
      print("Faltan llenar campos"); 
      return;
  }

  // Referencia simple usando el ID manual
  DatabaseReference ref = FirebaseDatabase.instance.ref("gastos/$id");

  await ref.set({
    "titulo": titulo,
    "descripcion": detalle,
    "precio": precio
  });
  
  print("Guardado correctamente en la base de datos");
  
  }
