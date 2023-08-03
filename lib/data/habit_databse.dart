import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

//Refrencia a nuestra caja
final _myBox = Hive.box("Habit_Database");

class HabitDatabase {

  List todaysHabitList = [];
  
  // Crear datos predeterminados iniciales
  void createDefaultData (){
    todaysHabitList = [
      ["Correr", false],
      ["Leer", false],
    ];
    
    _myBox.put("START_DATE", todaysDateFormatted());
  }
  //Cargar datos si es que existen
  void loadData(){
    // Si es un nuevo dia, toma la lista habitos de la db
    if(_myBox.get(todaysDateFormatted()) == null) {
      todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      // Marcar todos los datos como falsos ya que es un nuevo día
      for (int i = 0; i < todaysHabitList.length; i++){
      todaysHabitList[i][1] = false;
      }
    }
    //Si no es un nuevo día, cargar la lista de hoy
    else{
      todaysHabitList = _myBox.get(todaysDateFormatted());
    }
  }
  
  
  //Actualizar base de datos
  void updateDatabase(){
    // Actualizar la entrada de hoy
    _myBox.put(todaysDateFormatted(), todaysHabitList);
    //Actualizar la lista universal de Habitos en caso de que esta haya cambiado (nuevo ahabito, editar habito, borrar habito)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);
  }
}