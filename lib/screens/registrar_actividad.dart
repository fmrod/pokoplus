import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/data_models.dart';

class RegistrarActividadScreen extends StatefulWidget {
  const RegistrarActividadScreen({super.key});

  @override
  State<RegistrarActividadScreen> createState() =>
      _RegistrarActividadScreenState();
}

class _RegistrarActividadScreenState extends State<RegistrarActividadScreen> {
  // Filtrar solo las actividades con estado "Registrado"
  List<Activity> get _filteredActivities =>
      DataLists.activityList.where((a) => a.status == "Registrado").toList();

  void _showAddActivityDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedPriority = 'Medio';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          // Para manejar el estado del dropdown dentro del modal
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text("Nueva Actividad"),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: "Título"),
                        validator: (v) => v!.isEmpty ? "Obligatorio" : null,
                      ),
                      TextFormField(
                        controller: descController,
                        decoration: const InputDecoration(
                          labelText: "Descripción",
                        ),
                        validator: (v) => v!.isEmpty ? "Obligatorio" : null,
                      ),
                      DropdownButtonFormField<String>(
                        value: selectedPriority,
                        items: ['Alto', 'Medio', 'Bajo']
                            .map(
                              (p) => DropdownMenuItem(value: p, child: Text(p)),
                            )
                            .toList(),
                        onChanged: (val) =>
                            setModalState(() => selectedPriority = val!),
                        decoration: const InputDecoration(
                          labelText: "Prioridad",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                // g) Botones Cancelar y Aceptar
                IconButton(
                  icon: const Icon(Icons.cancel, color: Colors.red),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  onPressed: () => _saveActivity(
                    titleController.text,
                    descController.text,
                    selectedPriority,
                    formKey,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveActivity(
    String title,
    String desc,
    String priority,
    GlobalKey<FormState> key,
  ) {
    if (key.currentState!.validate()) {
      final newId = DataLists.activityList.isEmpty
          ? 1
          : DataLists.activityList.last.idActivity + 1;
      final currentUserId =
          1; // En una app real, vendría del contexto de sesión del Padre

      // i) Almacenar en activityList
      final newActivity = Activity(
        idActivity: newId,
        idUser: currentUserId,
        title: title,
        description: desc,
        priority: priority,
        status: "Registrado",
        registrationDate: DateTime.now(),
      );

      setState(() {
        DataLists.activityList.add(newActivity);
      });
      dev.log("Activity registrado correctamente");

      // i) Almacenar en eventActivityList
      final newEvent = EventActivity(
        idEvent: DataLists.eventActivityList.length + 1,
        idUser: currentUserId,
        idActivity: newId,
        eventEntity: "Activity",
        eventType: "Registrado",
        sentimentActivity: null,
        eventRegistrationDate: DateTime.now(),
      );

      DataLists.eventActivityList.add(newEvent);
      dev.log("eventActivity registrado correctamente");

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // j) Botón superior izquierdo para retornar a Inicio
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // a) y b) Textos de cabecera
            const Text(
              "Registrar actividad",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              "La actividad del hogar forja tu persona",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // c) y d) Listado de actividades
            Expanded(
              child: ListView.builder(
                itemCount: _filteredActivities.length,
                itemBuilder: (context, index) {
                  final act = _filteredActivities[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        act.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("Prioridad: ${act.priority}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => setState(
                              () => DataLists.activityList.remove(act),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // e) Botón añadir (+)
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "add",
            onPressed: _showAddActivityDialog,
            backgroundColor: Colors.blue,
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 10),
          // k) Botón inferior derecho para Reportes
          FloatingActionButton(
            heroTag: "report",
            onPressed: () => context.push('/reportes'),
            backgroundColor: Colors.green,
            child: const Icon(Icons.bar_chart, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
