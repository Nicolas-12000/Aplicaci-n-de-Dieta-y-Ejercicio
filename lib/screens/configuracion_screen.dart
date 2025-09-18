import 'package:flutter/material.dart';
import '../services/configuracion_service.dart';
import '../models/configuracion.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({Key? key}) : super(key: key);

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  final ConfiguracionService _configService = ConfiguracionService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _metaCaloriasController;
  late TextEditingController _pesoActualController;
  late TextEditingController _pesoMetaController;

  Configuracion? _configuracion;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _metaCaloriasController = TextEditingController();
    _pesoActualController = TextEditingController();
    _pesoMetaController = TextEditingController();
    _cargarConfiguracion();
  }

  @override
  void dispose() {
    _metaCaloriasController.dispose();
    _pesoActualController.dispose();
    _pesoMetaController.dispose();
    super.dispose();
  }

  Future<void> _cargarConfiguracion() async {
    setState(() => _isLoading = true);

    try {
      _configuracion = await _configService.obtenerConfiguracion();
      _metaCaloriasController.text = _configuracion!.metaCalorias.toString();
      _pesoActualController.text = _configuracion!.pesoActual.toString();
      _pesoMetaController.text = _configuracion!.pesoMeta.toString();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar configuración: $e')),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _guardarConfiguracion() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final nuevaConfiguracion = Configuracion(
        metaCalorias: double.parse(_metaCaloriasController.text),
        pesoActual: double.parse(_pesoActualController.text),
        pesoMeta: double.parse(_pesoMetaController.text),
      );

      await _configService.guardarConfiguracion(nuevaConfiguracion);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Configuración guardada exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar configuración: $e')),
      );
    }
  }

  String? _validarNumero(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (double.tryParse(value) == null) {
      return 'Ingresa un número válido';
    }
    if (double.parse(value) <= 0) {
      return 'El valor debe ser mayor a 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          if (!_isLoading)
            IconButton(
              onPressed: _guardarConfiguracion,
              icon: const Icon(Icons.save),
              tooltip: 'Guardar configuración',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuración Personal',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 24),

                    // Meta de Calorías
                    _buildSeccionConfiguracion(
                      titulo: 'Meta de Calorías Diarias',
                      descripcion:
                          'Establece tu objetivo diario de calorías a consumir',
                      icono: Icons.local_fire_department,
                      color: Colors.orange,
                      child: TextFormField(
                        controller: _metaCaloriasController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Meta de calorías',
                          suffixText: 'kcal',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.local_fire_department),
                        ),
                        validator: _validarNumero,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Peso Actual
                    _buildSeccionConfiguracion(
                      titulo: 'Peso Actual',
                      descripcion:
                          'Ingresa tu peso actual para seguir tu progreso',
                      icono: Icons.scale,
                      color: Colors.blue,
                      child: TextFormField(
                        controller: _pesoActualController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Peso actual',
                          suffixText: 'kg',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.scale),
                        ),
                        validator: _validarNumero,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Peso Meta
                    _buildSeccionConfiguracion(
                      titulo: 'Peso Meta',
                      descripcion: 'Define tu peso objetivo',
                      icono: Icons.flag,
                      color: Colors.green,
                      child: TextFormField(
                        controller: _pesoMetaController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Peso meta',
                          suffixText: 'kg',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          prefixIcon: const Icon(Icons.flag),
                        ),
                        validator: _validarNumero,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Información adicional
                    Card(
                      color: Colors.blue[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info, color: Colors.blue[700]),
                                const SizedBox(width: 8),
                                Text(
                                  'Consejos',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[700],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• La meta calórica típica para adultos es de 1800-2500 kcal/día\n'
                              '• Consulta con un profesional para establecer metas personalizadas\n'
                              '• Actualiza tu peso regularmente para un seguimiento preciso',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Botón de guardar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _guardarConfiguracion,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.save),
                            SizedBox(width: 8),
                            Text(
                              'Guardar Configuración',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSeccionConfiguracion({
    required String titulo,
    required String descripcion,
    required IconData icono,
    required Color color,
    required Widget child,
  }) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: color.withOpacity(0.1),
                  child: Icon(icono, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        descripcion,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
