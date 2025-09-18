# MVP - Aplicación de Dieta y Ejercicio

## Descripción
Aplicación móvil desarrollada en Flutter para el seguimiento de dieta y ejercicio. Permite a los usuarios registrar sus comidas, ejercicios y configurar metas personales de calorías y peso.

## Características Principales

### 📊 Dashboard
- Resumen diario de calorías consumidas y quemadas
- Progreso hacia metas de peso
- Acceso rápido a funcionalidades principales

### 🍽️ Gestión de Dieta
- Registro de comidas por tipo (desayuno, almuerzo, cena, merienda)
- Seguimiento de calorías por comida
- Edición y eliminación de registros

### 💪 Gestión de Ejercicios
- Registro de ejercicios por tipo (cardio, pesas, yoga, etc.)
- Seguimiento de calorías quemadas
- Variedad de tipos de ejercicio

### ⚙️ Configuración Personal
- Meta de calorías diarias
- Peso actual y peso meta
- Seguimiento de progreso

## Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo multiplataforma
- **SQLite (sqflite)**: Base de datos local para comidas y ejercicios
- **Hive**: Almacenamiento de configuraciones del usuario
- **Material Design**: Interfaz de usuario moderna

## Instalación

### Requisitos Previos
- Flutter SDK (versión 3.0 o superior)
- Dart SDK
- Android Studio / VS Code
- Dispositivo Android/iOS o emulador

### Pasos de Instalación

1. **Clonar o crear el proyecto**
   ```bash
   flutter create dieta_ejercicio
   cd dieta_ejercicio
   ```

2. **Configurar dependencias**
   - Reemplaza el contenido de `pubspec.yaml` con la configuración proporcionada
   - Ejecuta:
   ```bash
   flutter pub get
   ```

3. **Crear estructura de carpetas**
   ```
   lib/
   ├── models/
   │   ├── comida.dart
   │   ├── ejercicio.dart
   │   ├── configuracion.dart
   │   └── configuracion.g.dart
   ├── database/
   │   └── db_helper.dart
   ├── services/
   │   └── configuracion_service.dart
   ├── screens/
   │   ├── dashboard_screen.dart
   │   ├── dieta_screen.dart
   │   ├── ejercicio_screen.dart
   │   └── configuracion_screen.dart
   └── main.dart
   ```

4. **Copiar todos los archivos**
   - Copia cada archivo proporcionado en su ubicación correspondiente

5. **Generar archivos de Hive (opcional)**
   ```bash
   flutter packages pub run build_runner build
   ```

6. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## Uso de la Aplicación

### Primera Configuración
1. Abre la aplicación
2. Ve a la pestaña "Configuración"
3. Establece tu meta de calorías diarias
4. Ingresa tu peso actual y peso meta
5. Guarda la configuración

### Registro de Comidas
1. Ve a la pestaña "Dieta"
2. Presiona el botón "+" 
3. Completa el formulario:
   - Nombre de la comida
   - Calorías
   - Tipo de comida
4. Guarda el registro

### Registro de Ejercicios
1. Ve a la pestaña "Ejercicio"
2. Presiona el botón "+"
3. Completa el formulario:
   - Nombre del ejercicio
   - Calorías quemadas
   - Tipo de ejercicio
4. Guarda el registro

### Dashboard
- Visualiza el resumen diario
- Ve el progreso hacia tus metas
- Accede rápidamente a otras funciones

## Funcionalidades Adicionales

### Edición de Registros
- Toca cualquier elemento en la lista para editarlo
- Usa el menú de opciones para editar o eliminar

### Filtros por Fecha
- Los registros se ordenan por fecha automáticamente
- Las estadísticas del dashboard son del día actual

### Persistencia de Datos
- Los datos se guardan localmente en el dispositivo
- No se requiere conexión a internet

## Estructura de Base de Datos

### Tabla Comidas
- id (INTEGER PRIMARY KEY)
- nombre (TEXT)
- calorias (REAL)
- tipo (TEXT)
- fecha (TEXT)

### Tabla Ejercicios
- id (INTEGER PRIMARY KEY)
- nombre (TEXT)
- caloriasQuemadas (REAL)
- tipo (TEXT)
- fecha (TEXT)

### Configuración (Hive)
- metaCalorias (double)
- pesoActual (double)
- pesoMeta (double)

## Personalización

### Agregar Nuevos Tipos de Comida
Modifica el array en `dieta_screen.dart`:
```dart
['desayuno', 'almuerzo', 'cena', 'merienda', 'colacion']
```

### Agregar Nuevos Tipos de Ejercicio
Modifica el array en `ejercicio_screen.dart`:
```dart
['cardio', 'pesas', 'yoga', 'natacion', 'ciclismo', 'correr', 'caminar', 'pilates']
```

### Cambiar Colores del Tema
Modifica el `ThemeData` en `main.dart`

## Solución de Problemas

### Error al ejecutar
1. Verifica que todas las dependencias estén instaladas: `flutter pub get`
2. Limpia el proyecto: `flutter clean`
3. Reinstala dependencias: `flutter pub get`

### Error de base de datos
1. Desinstala la app del dispositivo/emulador
2. Vuelve a instalar para recrear la base de datos

### Error de Hive
1. Verifica que el adapter esté registrado correctamente
2. Revisa que `configuracion.g.dart` exista

## Próximas Mejoras

- [ ] Gráficos de progreso
- [ ] Exportar datos
- [ ] Recordatorios de comidas
- [ ] Base de datos de alimentos
- [ ] Sincronización en la nube
- [ ] Calculadora de IMC
- [ ] Rutinas de ejercicio predefinidas

## Contribución

Si deseas contribuir al proyecto:
1. Fork el repositorio
2. Crea una rama para tu feature
3. Realiza los cambios
4. Envía un pull request

## Licencia

Este proyecto es un MVP educativo y está disponible para uso personal y educativo.

---

**Tiempo estimado de desarrollo:** 10-12 horas
**Nivel de dificultad:** Intermedio
**Plataformas soportadas:** Android e iOS