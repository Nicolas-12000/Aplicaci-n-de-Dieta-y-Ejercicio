class Comida {
  int? id;
  String nombre;
  double calorias;
  String tipo; // desayuno, almuerzo, cena, merienda
  DateTime fecha;

  Comida({
    this.id,
    required this.nombre,
    required this.calorias,
    required this.tipo,
    required this.fecha,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'calorias': calorias,
      'tipo': tipo,
      'fecha': fecha.toIso8601String(),
    };
  }

  factory Comida.fromMap(Map<String, dynamic> map) {
    return Comida(
      id: map['id'] as int?,
      nombre: map['nombre'] as String,
      calorias: (map['calorias'] as num).toDouble(),
      tipo: map['tipo'] as String,
      fecha: DateTime.parse(map['fecha'] as String),
    );
  }
}
