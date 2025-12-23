import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/data_models.dart';

class EjecutarActividadScreen extends StatefulWidget {
  const EjecutarActividadScreen({super.key});

  @override
  State<EjecutarActividadScreen> createState() =>
      _EjecutarActividadScreenState();
}

class _EjecutarActividadScreenState extends State<EjecutarActividadScreen> {
  final int currentUserId = 2; // ID del Usuario Hijo según DataLists

  // c) Obtener actividades en estado "Registrado" o "En progreso"
  List<Activity> get _filteredActivities => DataLists.activityList
      .where((a) => a.status == "Registrado" || a.status == "En progreso")
      .toList();

  // e) Modal para Ver Detalles
  void _showViewDialog(Activity activity) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detalles de la Actividad"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Título: ${activity.title}"),
            Text("Descripción: ${activity.description}"),
            Text("Estado: ${activity.status}"),
            Text("Prioridad: ${activity.priority}"),
            Text(
              "Fecha: ${activity.registrationDate.toLocal().toString().split(' ')[0]}",
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.blue),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // g) Acción Ejecutar
  void _ejecutarActividad(Activity activity) {
    setState(() {
      activity.status = "En progreso";
    });

    dev.log(
      "${activity.idActivity} actualizado correctamente con el estado En progreso por el usuario $currentUserId",
    );

    final newEvent = EventActivity(
      idEvent: DataLists.eventActivityList.length + 1,
      idUser: currentUserId,
      idActivity: activity.idActivity,
      eventEntity: "Activity",
      sentimentActivity: null,
      eventType: "En progreso",
    );
    DataLists.eventActivityList.add(newEvent);
    dev.log("eventActivity registrado correctamente");
  }

  // b) Modal para Terminar (con Sentimiento)
  void _showFinishDialog(Activity activity) {
    String selectedSentiment = 'Alegría';
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          title: const Text("Terminar Actividad"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Actividad: ${activity.title}"),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedSentiment,
                items:
                    [
                          'Alegría',
                          'Satisfacción',
                          'Sorpresa',
                          'Enfado',
                          'Desagrado',
                        ]
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                onChanged: (val) =>
                    setModalState(() => selectedSentiment = val!),
                decoration: const InputDecoration(labelText: "Sentimiento"),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.pop(context),
            ),
            IconButton(
              icon: const Icon(Icons.check_circle, color: Colors.green),
              onPressed: () => _confirmarTerminar(activity, selectedSentiment),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarTerminar(Activity activity, String sentiment) {
    setState(() {
      activity.status = "Terminado";
    });

    dev.log(
      "${activity.idActivity} actualizado correctamente con el estado Terminado por el usuario $currentUserId",
    );

    final newEvent = EventActivity(
      idEvent: DataLists.eventActivityList.length + 1,
      idUser: currentUserId,
      idActivity: activity.idActivity,
      eventEntity: "Activity",
      sentimentActivity: sentiment,
      eventType: "Terminado",
    );
    DataLists.eventActivityList.add(newEvent);
    dev.log("eventActivity registrado correctamente");

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.home, color: Colors.blue, size: 30),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Ejecutar actividad",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const Text(
              "Hacer las actividades del hogar con dedicación",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredActivities.length,
                itemBuilder: (context, index) {
                  final act = _filteredActivities[index];
                  bool isEnProgreso = act.status == "En progreso";

                  return Card(
                    margin: const EdgeInsets.only(bottom: 15),
                    child: ListTile(
                      title: Text(
                        act.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Estado: ${act.status} | Prioridad: ${act.priority} | Fecha: ${act.registrationDate.toLocal().toString().split(' ')[0]}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 1) Ver
                          IconButton(
                            icon: const Icon(
                              Icons.visibility,
                              color: Colors.blue,
                            ),
                            onPressed: () => _showViewDialog(act),
                          ),
                          // 2) Ejecutar
                          IconButton(
                            icon: const Icon(
                              Icons.play_arrow,
                              color: Colors.green,
                            ),
                            onPressed: !isEnProgreso
                                ? () => _ejecutarActividad(act)
                                : null,
                          ),
                          // 3) Terminar
                          IconButton(
                            icon: const Icon(Icons.stop, color: Colors.red),
                            onPressed: isEnProgreso
                                ? () => _showFinishDialog(act)
                                : null,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/reportes'),
        backgroundColor: Colors.orange,
        child: const Icon(Icons.bar_chart, color: Colors.white),
      ),
    );
  }
}
