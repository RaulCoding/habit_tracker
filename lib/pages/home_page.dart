import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_fab.dart';
import '../components/habit_tile.dart';
import '../components/my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  //Estructura de datos para la todayslist
  List todaysHabitList = [
    //[habitName, habitCompleted]
    ["Morning Run", false],
    ["Read Book", false]
  ];
  
  
  //checkbox pulsada
  void checkBoxTapped(bool? value, int index){
    setState(() {
      todaysHabitList[index][1] = value;
    });
  }
  
  //Crear un nuevo habito
  final _newHabitNameController = TextEditingController();
  void createaNewHabit(){
    //Mostrar un AlertBox al usuario para introducir un nuevo habito
    showDialog(
      context: context, 
      builder: (context){
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
  void saveNewHabit(){
    //Añadir un hábito a la lista de hoy
    setState(() {
    todaysHabitList.add([_newHabitNameController.text, false]);
    });
  
    //Limpiar el cuadro de texto
    _newHabitNameController.clear();

    //Salir de la ventana
    Navigator.of(context).pop();
  }
    
    
  //Cancelar el nuevo habito
  void cancelDialogBox(){
    //Limpiar cuadro de texto
    _newHabitNameController.clear();
    //Salir de la ventana
    Navigator.of(context).pop();
  }
  // Abrir ventana editar habito
  void openHabitSettings(int index){
    showDialog(
      context: context , 
      builder: (context){
        return MyAlertBox(
          controller: _newHabitNameController, 
          hintText: todaysHabitList[index][0] ,
          onSave: () => SaveExistingHabit(index), 
          onCancel: cancelDialogBox,
        );
      }
    );
  }
  
  //Guardar habito existente con un nuevo nombre
  void SaveExistingHabit(int index){
    setState(() {
      todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
  }
  
  // delete habit
  void deleteHabit(int index){
    setState(() {
      todaysHabitList.removeAt(index);
    });
  }
    
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: createaNewHabit,
      ),
      body: ListView.builder(
        itemCount: todaysHabitList.length,
        itemBuilder: (context, index){
          return HabitTile(
            habitName: todaysHabitList[index][0], 
            habitCompleted: todaysHabitList[index][1],
            onChanged: (value) => checkBoxTapped(value, index),
            settingsTapped:(context) => openHabitSettings(index),
            deleteTapped: (context) => deleteHabit(index),
          );
        }
        )
    );
  }
}