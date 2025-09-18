class Ejercicio {
  int? id;
  String nombre;
  double caloriasQuemadas;
  String tipo; // cardio, pesas, yoga, etc.
  DateTime fecha;

  Ejercicio({
    this.id,
    required this.nombre,
    required this.caloriasQuemadas,
    required this.tipo,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'caloriasQuemadas': caloriasQuemadas,
      'tipo': tipo,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Ejercicio.fromMap(Map<String, dynamic> map) {
    return Ejercicio(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      caloriasQuemadas: (map['caloriasQuemadas'] as num).toDouble(),
      tipo: map['tipo'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }
}
