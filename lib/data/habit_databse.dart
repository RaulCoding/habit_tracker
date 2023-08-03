import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//Refrencia a nuestra caja
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};

  // Crear datos predeterminados iniciales
  void createDefaultData() {
    todaysHabitList = [
      ["Correr", false],
      ["Leer", false],
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  //Cargar datos si es que existen
  void loadData() {
    // Si es un nuevo dia, toma la lista habitos de la db
    if (_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      // Marcar todos los datos como falsos ya que es un nuevo día
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i][1] = false;
      }
    }
    //Si no es un nuevo día, cargar la lista de hoy
    else {
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }

  //Actualizar base de datos
  void updateDatabase() {
    // Actualizar la entrada de hoy
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    //Actualizar la lista universal de Habitos en caso de que esta haya cambiado (nuevo ahabito, editar habito, borrar habito)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    //Calcular porcentajes diarios de habitos completos
    calculateHabitPercentages();

    //Cargar Heat Map
    loadHeatMap();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i][1] == true) {
        countCompleted++;
      }
    }
    String percent = todaysHabitList.isEmpty
        ? "0.0"
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    //key: "PERCENTAGE_SUMMARY_YYYYMMDD"
    //value: string de 1 numero decimal entre 0.0 y 1.0 inclusives
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // Cuenta el numero  de días a cargar
    int daysInBetween = DateTime.now().difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      //Separa el DateTime como abajo para que asi no se tenga que preocupar por horas/minutos/segundos
      // Año
      int year = startDate.add(Duration(days: i)).year;

      // Mes
      int month = startDate.add(Duration(days: i)).month;

      // Día
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      print(heatMapDataSet);
    }
  }
}
