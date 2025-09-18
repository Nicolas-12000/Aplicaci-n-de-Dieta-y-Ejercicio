import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/ejercicio.dart';

class EjercicioScreen extends StatefulWidget {
  const EjercicioScreen({Key? key}) : super(key: key);

  @override
  State<EjercicioScreen> createState() => _EjercicioScreenState();
}

class _EjercicioScreenState extends State<EjercicioScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Ejercicio> _ejercicios = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarEjercicios();
  }

  Future<void> _cargarEjercicios() async {
    setState(() => _isLoading = true);
    try {
      _ejercicios = await _dbHelper.obtenerEjercicios();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ejercicios: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _mostrarDialogoEjercicio({Ejercicio? ejercicio}) async {
    final nombreController =
        TextEditingController(text: ejercicio?.nombre ?? '');
    final caloriasController = TextEditingController(
      text: ejercicio?.caloriasQuemadas.toString() ?? '',
    );
    String tipoSeleccionado = ejercicio?.tipo ?? 'cardio';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:
            Text(ejercicio == null ? 'Agregar Ejercicio' : 'Editar Ejercicio'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del ejercicio',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calorías quemadas',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de ejercicio',
                  border: OutlineInputBorder(),
                ),
                items: [
                  'cardio',
                  'pesas',
                  'yoga',
                  'natacion',
                  'ciclismo',
                  'correr',
                  'caminar',
                  'otro'
                ]
                    .map((tipo) => DropdownMenuItem(
                          value: tipo,
                          child: Text(tipo.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) => tipoSeleccionado = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (nombreController.text.isNotEmpty &&
                  caloriasController.text.isNotEmpty) {
                final nuevoEjercicio = Ejercicio(
                  id: ejercicio?.id,
                  nombre: nombreController.text,
                  caloriasQuemadas:
                      double.tryParse(caloriasController.text) ?? 0,
                  tipo: tipoSeleccionado,
                  fecha: ejercicio?.fecha ?? DateTime.now(),
                );

                try {
                  if (ejercicio == null) {
                    await _dbHelper.insertarEjercicio(nuevoEjercicio);
                  } else {
                    await _dbHelper.actualizarEjercicio(nuevoEjercicio);
                  }
                  Navigator.pop(context);
                  _cargarEjercicios();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        ejercicio == null
                            ? 'Ejercicio agregado exitosamente'
                            : 'Ejercicio actualizado exitosamente',
                      ),
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
            child: Text(ejercicio == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarEjercicio(Ejercicio ejercicio) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text(
            '¿Estás seguro de que quieres eliminar "${ejercicio.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await _dbHelper.eliminarEjercicio(ejercicio.id!);
        _cargarEjercicios();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ejercicio eliminado exitosamente')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al eliminar: $e')),
        );
      }
    }
  }

  Color _obtenerColorTipo(String tipo) {
    switch (tipo) {
      case 'cardio':
        return Colors.red;
      case 'pesas':
        return Colors.brown;
      case 'yoga':
        return Colors.purple;
      case 'natacion':
        return Colors.blue;
      case 'ciclismo':
        return Colors.green;
      case 'correr':
        return Colors.orange;
      case 'caminar':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _obtenerIconoTipo(String tipo) {
    switch (tipo) {
      case 'cardio':
        return Icons.favorite;
      case 'pesas':
        return Icons.fitness_center;
      case 'yoga':
        return Icons.self_improvement;
      case 'natacion':
        return Icons.pool;
      case 'ciclismo':
        return Icons.directions_bike;
      case 'correr':
        return Icons.directions_run;
      case 'caminar':
        return Icons.directions_walk;
      default:
        return Icons.sports;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _cargarEjercicios,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _ejercicios.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.fitness_center,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay ejercicios registrados',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Presiona el botón + para agregar un ejercicio',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarEjercicios,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _ejercicios.length,
                    itemBuilder: (context, index) {
                      final ejercicio = _ejercicios[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _obtenerColorTipo(ejercicio.tipo)
                                .withOpacity(0.1),
                            child: Icon(
                              _obtenerIconoTipo(ejercicio.tipo),
                              color: _obtenerColorTipo(ejercicio.tipo),
                            ),
                          ),
                          title: Text(
                            ejercicio.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.whatshot,
                                    size: 16,
                                    color: Colors.red[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${ejercicio.caloriasQuemadas.toStringAsFixed(0)} kcal quemadas'),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _obtenerColorTipo(ejercicio.tipo)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      ejercicio.tipo.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            _obtenerColorTipo(ejercicio.tipo),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${ejercicio.fecha.day}/${ejercicio.fecha.month}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'editar':
                                      _mostrarDialogoEjercicio(
                                          ejercicio: ejercicio);
                                      break;
                                    case 'eliminar':
                                      _eliminarEjercicio(ejercicio);
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'editar',
                                    child: Row(
                                      children: [
                                        Icon(Icons.edit, size: 18),
                                        SizedBox(width: 8),
                                        Text('Editar'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'eliminar',
                                    child: Row(
                                      children: [
                                        Icon(Icons.delete,
                                            size: 18, color: Colors.red),
                                        SizedBox(width: 8),
                                        Text('Eliminar',
                                            style:
                                                TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () =>
                              _mostrarDialogoEjercicio(ejercicio: ejercicio),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarDialogoEjercicio(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
