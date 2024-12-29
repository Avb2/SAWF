import 'package:flutter/material.dart';
import 'package:sawf/login/account_registration_form.dart';
import 'package:sawf/login/log_in_form.dart';
import 'package:sawf/login/src/constants/custom_widgets.dart';
import 'package:sawf/src/constants/constants_colors.dart';




class LoggedOutPage extends StatefulWidget{
  static const routeName = "/logged-out-page";
  LoggedOutPage({super.key});

  // Create state
  LoggedOutPageState createState() => LoggedOutPageState();
}


class LoggedOutPageState extends State<LoggedOutPage>{

  CustomWidgets customWidgets = CustomWidgets();



  Widget createLoggedOutPage(BuildContext context){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: customWidgets.navButton(
            context,
             (){
              Navigator.pushReplacementNamed(context, LoginForm.routeName);
          }, 
          'Login'
          )),
          Center(
            child: customWidgets.navButton(
              context,
               (){
                Navigator.pushReplacementNamed(context, AccountRegistry.routeName);
               }, 
               'Create Account'
               ))
        ]
        ),
    );
  }

  @override 
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: NormalTheme.backgroundColor,
      body: createLoggedOutPage(context),
    );
  }
}