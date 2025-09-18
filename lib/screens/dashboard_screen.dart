import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../services/configuracion_service.dart';
import '../models/configuracion.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DBHelper _dbHelper = DBHelper();
  final ConfiguracionService _configService = ConfiguracionService();

  Map<String, double> _estadisticas = {
    'caloriasConsumidas': 0.0,
    'caloriasQuemadas': 0.0,
    'caloriasNetas': 0.0,
  };

  Configuracion? _configuracion;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);

    try {
      DateTime hoy = DateTime.now();
      _estadisticas = await _dbHelper.obtenerEstadisticasDelDia(hoy);
      _configuracion = await _configService.obtenerConfiguracion();
    } catch (e) {
      print('Error al cargar datos: $e');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _cargarDatos,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Resumen del día',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 16),

                    // Tarjeta de Calorías
                    _buildCaloriasCard(),
                    const SizedBox(height: 16),

                    // Tarjeta de Progreso
                    _buildProgresoCard(),
                    const SizedBox(height: 16),

                    // Botones de acceso rápido
                    _buildAccesoRapido(),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCaloriasCard() {
    double metaCalorias = _configuracion?.metaCalorias ?? 2000.0;
    double caloriasRestantes = metaCalorias - _estadisticas['caloriasNetas']!;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Calorías',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCaloriaItem(
                  'Consumidas',
                  _estadisticas['caloriasConsumidas']!,
                  Colors.orange,
                ),
                _buildCaloriaItem(
                  'Quemadas',
                  _estadisticas['caloriasQuemadas']!,
                  Colors.green,
                ),
                _buildCaloriaItem(
                  'Restantes',
                  caloriasRestantes,
                  caloriasRestantes > 0 ? Colors.blue : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: (_estadisticas['caloriasNetas']! / metaCalorias)
                  .clamp(0.0, 1.0),
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                caloriasRestantes > 0 ? Colors.blue : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaloriaItem(String label, double valor, Color color) {
    return Column(
      children: [
        Text(
          valor.toStringAsFixed(0),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProgresoCard() {
    if (_configuracion == null) return const SizedBox();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progreso de Peso',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildPesoItem(
                  'Actual',
                  _configuracion!.pesoActual,
                  'kg',
                  Colors.blue,
                ),
                _buildPesoItem(
                  'Meta',
                  _configuracion!.pesoMeta,
                  'kg',
                  Colors.green,
                ),
                _buildPesoItem(
                  'Diferencia',
                  (_configuracion!.pesoActual - _configuracion!.pesoMeta).abs(),
                  'kg',
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPesoItem(
      String label, double valor, String unidad, Color color) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              valor.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unidad,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAccesoRapido() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acceso Rápido',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildBotonAcceso(
                  'Agregar\\nComida',
                  Icons.restaurant,
                  Colors.orange,
                  () => Navigator.pushNamed(context, '/dieta'),
                ),
                _buildBotonAcceso(
                  'Agregar\\nEjercicio',
                  Icons.fitness_center,
                  Colors.green,
                  () => Navigator.pushNamed(context, '/ejercicio'),
                ),
                _buildBotonAcceso(
                  'Configuración',
                  Icons.settings,
                  Colors.blue,
                  () => Navigator.pushNamed(context, '/configuracion'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBotonAcceso(
      String texto, IconData icono, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icono, color: color, size: 30),
          ),
          const SizedBox(height: 8),
          Text(
            texto,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
