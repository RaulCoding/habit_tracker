import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  
  const MyAlertBox({
    super.key, 
    required this.controller,
    required this.hintText, 
    required this.onSave, 
    required this.onCancel
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white) ,
          enabledBorder:
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder: 
            const OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        ),
      ),
      actions: [
        MaterialButton(
          onPressed: onSave,
          color: Colors.black,
          child: const Text(
            "Guardar",
            style: TextStyle(color: Colors.white),
          ),
        ),
        MaterialButton(
          onPressed: onCancel,
          color: Colors.black,
          child: const Text(
            "Cancelar",
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
      
    );
  }
}