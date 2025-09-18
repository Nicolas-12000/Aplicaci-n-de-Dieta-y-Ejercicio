import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/comida.dart';

class DietaScreen extends StatefulWidget {
  const DietaScreen({Key? key}) : super(key: key);

  @override
  State<DietaScreen> createState() => _DietaScreenState();
}

class _DietaScreenState extends State<DietaScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Comida> _comidas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarComidas();
  }

  Future<void> _cargarComidas() async {
    setState(() => _isLoading = true);
    try {
      _comidas = await _dbHelper.obtenerComidas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar comidas: $e')),
      );
    }
    setState(() => _isLoading = false);
  }

  Future<void> _mostrarDialogoComida({Comida? comida}) async {
    final nombreController = TextEditingController(text: comida?.nombre ?? '');
    final caloriasController = TextEditingController(
      text: comida?.calorias.toString() ?? '',
    );
    String tipoSeleccionado = comida?.tipo ?? 'desayuno';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(comida == null ? 'Agregar Comida' : 'Editar Comida'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre de la comida',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: caloriasController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calorías',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoSeleccionado,
                decoration: const InputDecoration(
                  labelText: 'Tipo de comida',
                  border: OutlineInputBorder(),
                ),
                items: ['desayuno', 'almuerzo', 'cena', 'merienda']
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
                final nuevaComida = Comida(
                  id: comida?.id,
                  nombre: nombreController.text,
                  calorias: double.tryParse(caloriasController.text) ?? 0,
                  tipo: tipoSeleccionado,
                  fecha: comida?.fecha ?? DateTime.now(),
                );

                try {
                  if (comida == null) {
                    await _dbHelper.insertarComida(nuevaComida);
                  } else {
                    await _dbHelper.actualizarComida(nuevaComida);
                  }
                  Navigator.pop(context);
                  _cargarComidas();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        comida == null
                            ? 'Comida agregada exitosamente'
                            : 'Comida actualizada exitosamente',
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
            child: Text(comida == null ? 'Agregar' : 'Actualizar'),
          ),
        ],
      ),
    );
  }

  Future<void> _eliminarComida(Comida comida) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content:
            Text('¿Estás seguro de que quieres eliminar "${comida.nombre}"?'),
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
        await _dbHelper.eliminarComida(comida.id!);
        _cargarComidas();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comida eliminada exitosamente')),
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
      case 'desayuno':
        return Colors.orange;
      case 'almuerzo':
        return Colors.green;
      case 'cena':
        return Colors.blue;
      case 'merienda':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dieta'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _cargarComidas,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _comidas.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No hay comidas registradas',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Presiona el botón + para agregar una comida',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _cargarComidas,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _comidas.length,
                    itemBuilder: (context, index) {
                      final comida = _comidas[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                _obtenerColorTipo(comida.tipo).withOpacity(0.1),
                            child: Icon(
                              Icons.restaurant,
                              color: _obtenerColorTipo(comida.tipo),
                            ),
                          ),
                          title: Text(
                            comida.nombre,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 16,
                                    color: Colors.orange[700],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${comida.calorias.toStringAsFixed(0)} kcal'),
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
                                      color: _obtenerColorTipo(comida.tipo)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      comida.tipo.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: _obtenerColorTipo(comida.tipo),
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
                                '${comida.fecha.day}/${comida.fecha.month}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              PopupMenuButton<String>(
                                onSelected: (value) {
                                  switch (value) {
                                    case 'editar':
                                      _mostrarDialogoComida(comida: comida);
                                      break;
                                    case 'eliminar':
                                      _eliminarComida(comida);
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
                          onTap: () => _mostrarDialogoComida(comida: comida),
                        ),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: () => _mostrarDialogoComida(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
