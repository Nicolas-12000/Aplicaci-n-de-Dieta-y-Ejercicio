import 'package:hive/hive.dart';
part 'configuracion.g.dart';

class Configuracion {
  double metaCalorias;
  double pesoActual;
  double pesoMeta;

  Configuracion({
    this.metaCalorias = 2000.0,
    this.pesoActual = 70.0,
    this.pesoMeta = 65.0,
  });

  Map<String, dynamic> toMap() {
    return {
      'metaCalorias': metaCalorias,
      'pesoActual': pesoActual,
      'pesoMeta': pesoMeta,
    };
  }

  factory Configuracion.fromMap(Map<String, dynamic> map) {
    return Configuracion(
      metaCalorias: (map['metaCalorias'] as num?)?.toDouble() ?? 2000.0,
      pesoActual: (map['pesoActual'] as num?)?.toDouble() ?? 70.0,
      pesoMeta: (map['pesoMeta'] as num?)?.toDouble() ?? 65.0,
    );
  }
}
