import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_fab.dart';
import '../components/habit_tile.dart';
import '../components/new_habit_box.dart';

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
  void createaNewHabit(){
    //Mostrar un AlertBox al usuario para introducir un nuevo habito
    showDialog(
      context: context, 
      builder: (context){
        return EnterNewHabitBox();
      },
    );
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
            onChanged: (value) => checkBoxTapped(value, index)
          );
        }
        )
    );
  }
}