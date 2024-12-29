import 'package:flutter/material.dart';
import 'package:new_stock_tracker/src/constants/constants_colors.dart';

class CustomWidgets{
  
  Widget customTextField(BuildContext context, TextEditingController controller, IconData icon, String hintText){
    return Container(
      margin: const EdgeInsets.only(right: 40, left: 10),
      child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        icon: Icon(icon,
        color: NormalTheme.primaryColor,),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: NormalTheme.primaryColor)
            )
      ),
      cursorColor: NormalTheme.primaryColor,
    ));
  }

  Widget navButton(BuildContext context, onPressed, dynamic text){
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => const Color.fromARGB(253, 40, 41, 48))
      ),
      onPressed: onPressed, 
      child: Text(text,
      style: const TextStyle(
        color: NormalTheme.primaryColor,
        fontSize: 19
      ),)
      );
  }
}