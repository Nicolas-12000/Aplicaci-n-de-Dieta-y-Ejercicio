import 'package:hive_flutter/hive_flutter.dart';
import '../models/configuracion.dart';

class ConfiguracionService {
  static const String _boxName = 'configuracion';
  Box<Configuracion>? _box;

  static final ConfiguracionService _instance =
      ConfiguracionService._internal();
  factory ConfiguracionService() => _instance;
  ConfiguracionService._internal();

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(ConfiguracionAdapter());
    }
    _box = await Hive.openBox<Configuracion>(_boxName);
  }

  Future<Configuracion> obtenerConfiguracion() async {
    if (_box == null) await init();

    Configuracion? config = _box!.get('config');
    if (config == null) {
      config = Configuracion();
      await guardarConfiguracion(config);
    }
    return config;
  }

  Future<void> guardarConfiguracion(Configuracion configuracion) async {
    if (_box == null) await init();
    await _box!.put('config', configuracion);
  }

  Future<void> actualizarMetaCalorias(double metaCalorias) async {
    Configuracion config = await obtenerConfiguracion();
    config.metaCalorias = metaCalorias;
    await guardarConfiguracion(config);
  }

  Future<void> actualizarPesoActual(double pesoActual) async {
    Configuracion config = await obtenerConfiguracion();
    config.pesoActual = pesoActual;
    await guardarConfiguracion(config);
  }

  Future<void> actualizarPesoMeta(double pesoMeta) async {
    Configuracion config = await obtenerConfiguracion();
    config.pesoMeta = pesoMeta;
    await guardarConfiguracion(config);
  }

  void dispose() {
    _box?.close();
  }
}
