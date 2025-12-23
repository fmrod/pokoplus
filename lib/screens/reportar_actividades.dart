import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../models/data_models.dart';

class ReportarActividadesScreen extends StatelessWidget {
  const ReportarActividadesScreen({super.key});

  // Helper para contar ocurrencias en eventActivityList
  int _countByEventType(String type) {
    return DataLists.eventActivityList.where((e) => e.eventType == type).length;
  }

  int _countBySentiment(String sentiment) {
    return DataLists.eventActivityList
        .where((e) => e.sentimentActivity == sentiment)
        .length;
  }

  @override
  Widget build(BuildContext context) {
    // Supongamos que obtenemos el rol del usuario actual (en una app real vendría de un Provider/Auth)
    final String userRole = DataLists.usersList
        .firstWhere((u) => u.idUser == 2)
        .userRole;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Reporte de Logros",
          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // a) Botón superior izquierdo con lógica de retorno por rol
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.blue),
          onPressed: () {
            if (userRole == "Padre") {
              context.go('/registro-actividad');
            } else {
              context.go('/ejecutar-actividad');
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              "Actividades por Estado",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildBarChart([
              _ChartData("Reg.", _countByEventType("Registrado"), Colors.blue),
              _ChartData(
                "Prog.",
                _countByEventType("En progreso"),
                Colors.orange,
              ),
              _ChartData("Term.", _countByEventType("Terminado"), Colors.green),
              _ChartData("Anul.", _countByEventType("Anulado"), Colors.red),
            ]),
            const SizedBox(height: 40),
            const Text(
              "Sentimientos al Terminar",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _buildBarChart([
              _ChartData(
                "Alegría",
                _countBySentiment("Alegría"),
                Colors.yellow,
              ),
              _ChartData(
                "Satis.",
                _countBySentiment("Satisfacción"),
                Colors.lightGreen,
              ),
              _ChartData(
                "Sorpr.",
                _countBySentiment("Sorpresa"),
                Colors.purple,
              ),
              _ChartData(
                "Enfado",
                _countBySentiment("Enfado"),
                Colors.redAccent,
              ),
              _ChartData(
                "Desag.",
                _countBySentiment("Desagrado"),
                Colors.brown,
              ),
            ]),
          ],
        ),
      ),
      // b) Botón inferior derecho para volver a Inicio
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/'),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.home, color: Colors.white),
      ),
    );
  }

  Widget _buildBarChart(List<_ChartData> data) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY:
              data
                  .map((e) => e.value)
                  .reduce((a, b) => a > b ? a : b)
                  .toDouble() +
              2,
          barGroups: data.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value.toDouble(),
                  color: entry.value.color,
                  width: 20,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  data[value.toInt()].label,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final int value;
  final Color color;
  _ChartData(this.label, this.value, this.color);
}
