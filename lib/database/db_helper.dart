import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/comida.dart';
import '../models/ejercicio.dart';

class DBHelper {
  static Database? _database;
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'dieta_ejercicio.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE comidas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        calorias REAL NOT NULL,
        tipo TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ejercicios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        caloriasQuemadas REAL NOT NULL,
        tipo TEXT NOT NULL,
        fecha TEXT NOT NULL
      )
    ''');
  }

  // Métodos para Comidas
  Future<int> insertarComida(Comida comida) async {
    final db = await database;
    return await db.insert('comidas', comida.toMap());
  }

  Future<List<Comida>> obtenerComidas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'comidas',
      orderBy: 'fecha DESC',
    );
    return List.generate(maps.length, (i) => Comida.fromMap(maps[i]));
  }

  Future<List<Comida>> obtenerComidasPorFecha(DateTime fecha) async {
    final db = await database;
    String fechaStr = fecha.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'comidas',
      where: 'date(fecha) = ?',
      whereArgs: [fechaStr],
      orderBy: 'fecha DESC',
    );
    return List.generate(maps.length, (i) => Comida.fromMap(maps[i]));
  }

  Future<void> actualizarComida(Comida comida) async {
    final db = await database;
    await db.update(
      'comidas',
      comida.toMap(),
      where: 'id = ?',
      whereArgs: [comida.id],
    );
  }

  Future<void> eliminarComida(int id) async {
    final db = await database;
    await db.delete('comidas', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para Ejercicios
  Future<int> insertarEjercicio(Ejercicio ejercicio) async {
    final db = await database;
    return await db.insert('ejercicios', ejercicio.toMap());
  }

  Future<List<Ejercicio>> obtenerEjercicios() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'ejercicios',
      orderBy: 'fecha DESC',
    );
    return List.generate(maps.length, (i) => Ejercicio.fromMap(maps[i]));
  }

  Future<List<Ejercicio>> obtenerEjerciciosPorFecha(DateTime fecha) async {
    final db = await database;
    String fechaStr = fecha.toIso8601String().split('T')[0];
    final List<Map<String, dynamic>> maps = await db.query(
      'ejercicios',
      where: 'date(fecha) = ?',
      whereArgs: [fechaStr],
      orderBy: 'fecha DESC',
    );
    return List.generate(maps.length, (i) => Ejercicio.fromMap(maps[i]));
  }

  Future<void> actualizarEjercicio(Ejercicio ejercicio) async {
    final db = await database;
    await db.update(
      'ejercicios',
      ejercicio.toMap(),
      where: 'id = ?',
      whereArgs: [ejercicio.id],
    );
  }

  Future<void> eliminarEjercicio(int id) async {
    final db = await database;
    await db.delete('ejercicios', where: 'id = ?', whereArgs: [id]);
  }

  // Método para calcular estadísticas del día
  Future<Map<String, double>> obtenerEstadisticasDelDia(DateTime fecha) async {
    List<Comida> comidas = await obtenerComidasPorFecha(fecha);
    List<Ejercicio> ejercicios = await obtenerEjerciciosPorFecha(fecha);

    double caloriasConsumidas =
        comidas.fold(0.0, (sum, comida) => sum + comida.calorias);
    double caloriasQuemadas = ejercicios.fold(
        0.0, (sum, ejercicio) => sum + ejercicio.caloriasQuemadas);

    return {
      'caloriasConsumidas': caloriasConsumidas,
      'caloriasQuemadas': caloriasQuemadas,
      'caloriasNetas': caloriasConsumidas - caloriasQuemadas,
    };
  }
}
