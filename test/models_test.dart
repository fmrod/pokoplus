import 'package:flutter_test/flutter_test.dart';
import 'package:pokoplus/models/data_models.dart';

void main() {
  group('Pruebas de Reportes y Datos', () {
    test('Debe contar correctamente los sentimientos en eventActivityList', () {
      // 1. Limpiar lista y agregar datos de prueba
      DataLists.eventActivityList.clear();
      DataLists.eventActivityList.addAll([
        EventActivity(
          idEvent: 1,
          idUser: 2,
          idActivity: 101,
          eventEntity: "Activity",
          eventType: "Terminado",
          sentimentActivity: "Alegría",
        ),
        EventActivity(
          idEvent: 2,
          idUser: 2,
          idActivity: 102,
          eventEntity: "Activity",
          eventType: "Terminado",
          sentimentActivity: "Alegría",
        ),
        EventActivity(
          idEvent: 3,
          idUser: 2,
          idActivity: 103,
          eventEntity: "Activity",
          eventType: "Terminado",
          sentimentActivity: "Enfado",
        ),
      ]);

      // 2. Ejecutar la lógica de conteo
      int conteoAlegria = DataLists.eventActivityList
          .where((e) => e.sentimentActivity == "Alegría")
          .length;
      int conteoEnfado = DataLists.eventActivityList
          .where((e) => e.sentimentActivity == "Enfado")
          .length;

      // 3. Verificar resultados
      expect(conteoAlegria, 2);
      expect(conteoEnfado, 1);
    });

    test('Validación de búsqueda de usuario por Email', () {
      final user = DataLists.findUserByEmail("hijo@poko.com");
      expect(user, isNotNull);
      expect(user?.userRole, "Hijo");
    });
  });
}
