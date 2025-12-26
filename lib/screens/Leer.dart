import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Leerscreen extends StatefulWidget {
  const Leerscreen({super.key});

  @override
  State<Leerscreen> createState() => _LeerscreenState();
}

class _LeerscreenState extends State<Leerscreen> {

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
          "precio": valor["precio"],
        });
      });
    }
    return gastos;
  }

  Future<void> eliminar(String id) async {
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("gastos/$id");
    await ref.remove();

    setState(() {}); 
  }

  void editar(BuildContext context, Map item) {
    TextEditingController titulo =
        TextEditingController(text: item["titulo"]);
    TextEditingController descripcion =
        TextEditingController(text: item["descripcion"]);
    TextEditingController precio =
        TextEditingController(text: item["precio"].toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Editar Gasto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titulo,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: descripcion,
              decoration: const InputDecoration(labelText: "Descripción"),
            ),
            TextField(
              controller: precio,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Precio"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Guardar"),
            onPressed: () async {
              DatabaseReference ref = FirebaseDatabase.instance
                  .ref("gastos/${item["id"]}");

              await ref.update({
                "titulo": titulo.text,
                "descripcion": descripcion.text,
                "precio": precio.text,
              });

              Navigator.pop(context);
              setState(() {}); 
            },
          ),
        ],
      ),
    );
  }

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
      ),
      body: FutureBuilder(
        future: leerFire(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List data = snapshot.data!;

            if (data.isEmpty) {
              return const Center(child: Text("No tienes gastos guardados"));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: data.length,
              itemBuilder: (context, index) {
                final item = data[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      item["titulo"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    childrenPadding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    children: [
                      Text(
                        item["descripcion"],
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "\$ ${item["precio"]}",
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => editar(context, item),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => eliminar(item["id"]),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar datos"));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
