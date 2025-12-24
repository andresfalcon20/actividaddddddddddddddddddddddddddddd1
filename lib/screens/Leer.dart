import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Leerscreen extends StatelessWidget {
  const Leerscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Mis Gastos",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: lista(),
    );
  }
}

// 1. LEER
Future<List> leerFire() async {
  List gastos = [];
  DatabaseReference ref = FirebaseDatabase.instance.ref('gastos/');

  final snapshot = await ref.get();
  final data = snapshot.value;

  if (data != null) {
    Map mapGastos = data as Map;

    mapGastos.forEach((clave, valor) {
      gastos.add({
        "id": clave,
        "titulo": valor["titulo"],
        "descripcion": valor["descripcion"],
        "precio": valor["precio"]
      });
    });
  }
  return gastos;
}

// 2. LISTA
Widget lista() {
  return FutureBuilder(
    future: leerFire(),
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        List data = snapshot.data!;

        if (data.isEmpty) {
          return const Center(child: Text("No tienes gastos guardados"));
        }

        return ListView.builder(
          itemCount: data.length,
          padding: const EdgeInsets.all(15),
          itemBuilder: (context, index) {
            final item = data[index];

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple[100],
                  child: Text(
                    item['id'].toString(),
                    style: const TextStyle(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                title: Text(
                  item['titulo'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['descripcion']),
                    const SizedBox(height: 5),
                    Text(
                      "\$ ${item['precio']}",
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                // 👉 EDITAR + ELIMINAR (SIN COSAS NUEVAS)
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => editar(item["id"]),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => eliminar(item["id"], context),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      } else if (snapshot.hasError) {
        return const Center(child: Text('Error al cargar datos'));
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
  );
}

// 3. ELIMINAR
Future<void> eliminar(id, context) async {
  DatabaseReference ref =
      FirebaseDatabase.instance.ref("gastos/$id");
  await ref.remove();
  print("Gasto eliminado");
}

// 4. EDITAR (MISMA SIMPLICIDAD)
Future<void> editar(id) async {
  print("Editar gasto con id: $id");
}

