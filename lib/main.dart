import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/dashboard_screen.dart';
import 'screens/dieta_screen.dart';
import 'screens/ejercicio_screen.dart';
import 'screens/configuracion_screen.dart';
import 'models/configuracion.dart';
import 'services/configuracion_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Hive
  await Hive.initFlutter();

  // Registrar adaptadores de Hive
  if (!Hive.isAdapterRegistered(12)) {
    Hive.registerAdapter(ConfiguracionAdapter());
  }

  // Inicializar servicio de configuración
  await ConfiguracionService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dieta y Ejercicio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
      ),
      home: const MainScreen(),
      routes: {
        '/dashboard': (context) => const DashboardScreen(),
        '/dieta': (context) => const DietaScreen(),
        '/ejercicio': (context) => const EjercicioScreen(),
        '/configuracion': (context) => const ConfiguracionScreen(),
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    // Create placeholders; we'll instantiate lazily in build to avoid
    // doing heavy work for all screens on startup.
    const SizedBox.shrink(), // Dashboard placeholder
    const SizedBox.shrink(), // Dieta placeholder
    const SizedBox.shrink(), // Ejercicio placeholder
    const SizedBox.shrink(), // Configuracion placeholder
  ];

  final List<Widget?> _screenInstances = [null, null, null, null];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(_screens.length, (i) {
          // instantiate the screen on first access and cache it
          if (_screenInstances[i] == null) {
            switch (i) {
              case 0:
                _screenInstances[i] = const DashboardScreen();
                break;
              case 1:
                _screenInstances[i] = const DietaScreen();
                break;
              case 2:
                _screenInstances[i] = const EjercicioScreen();
                break;
              case 3:
                _screenInstances[i] = const ConfiguracionScreen();
                break;
            }
          }
          return _screenInstances[i]!;
        }),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        elevation: 8,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Dieta',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Ejercicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
      ),
    );
  }
}
