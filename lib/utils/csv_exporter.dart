import 'package:intl/intl.dart';
import 'csv_exporter_stub.dart' if (dart.library.html) 'csv_exporter_web.dart';

class CsvExporter {
  static Future<void> exportHistory(List<Map<String, dynamic>> items) async {
    // Encabezados del CSV
    String csvContent = "Fecha,Hora,Estudiante,Curso,Autorizado por,Guardia,Estado\n";

    // Filas de datos
    for (var item in items) {
      final date = DateFormat('dd/MM/yyyy').format(item['date']);
      final time = item['time'];
      final student = item['studentName'];
      final grade = item['grade'];
      final auth = item['authorizedBy'];
      final guard = item['guardName'];
      final status = item['isFlagged'] ? 'Alerta' : 'Exitoso';

      csvContent += "$date,$time,$student,$grade,$auth,$guard,$status\n";
    }

    // Llamar a la función de descarga (específica de plataforma)
    downloadCSV("historial_retiras.csv", csvContent);
  }
}
