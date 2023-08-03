import 'package:flutter/material.dart';
import 'package:habit_tracker/components/month_summary.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/data/habit_databse.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/habit_tile.dart';
import '../components/my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    //Si no hay una lista de habitos aun, es la 1ª vez que se abre la app.
    //Entonces crear datos predeterminados

    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }
    // Si ya existen datos, no es la 1ª vez
    else {
      db.loadData();
    }
    // Actualizar la base de datos
    db.updateDatabase();

    super.initState();
  }

  //checkbox pulsada
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  //Crear un nuevo habito
  final _newHabitNameController = TextEditingController();
  void createaNewHabit() {
    //Mostrar un AlertBox al usuario para introducir un nuevo habito
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: "Nombre del hábito",
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // Guardar nuevo hábito
  void saveNewHabit() {
    //Añadir un hábito a la lista de hoy
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    //Limpiar el cuadro de texto
    _newHabitNameController.clear();

    //Salir de la ventana
    Navigator.of(context).pop();

    db.updateDatabase();
  }

  //Cancelar el nuevo habito
  void cancelDialogBox() {
    //Limpiar cuadro de texto
    _newHabitNameController.clear();
    //Salir de la ventana
    Navigator.of(context).pop();
  }

  // Abrir ventana editar habito
  void openHabitSettings(int index) {
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controller: _newHabitNameController,
            hintText: db.todaysHabitList[index][0],
            onSave: () => saveExistingHabit(index),
            onCancel: cancelDialogBox,
          );
        });
  }

  //Guardar habito existente con un nuevo nombre
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: MyFloatingActionButton(
          onPressed: createaNewHabit,
        ),
        body: ListView(
          children: [
            //Resumen mensual del Heat Map
            MonthlySummary(
              datasets: db.heatMapDataSet, 
              startDate: _myBox.get("START_DATE")
            ),

            //Lista de Habitos
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: db.todaysHabitList.length,
                itemBuilder: (context, index) {
                  return HabitTile(
                    habitName: db.todaysHabitList[index][0],
                    habitCompleted: db.todaysHabitList[index][1],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                  );
                })
          ],
        ));
  }
}
