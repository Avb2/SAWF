import 'package:flutter/material.dart';
import 'package:new_stock_tracker/logged_out_page.dart';
import 'package:new_stock_tracker/src/constants/constants_colors.dart';
import 'package:new_stock_tracker/src/constants/custom_widgets.dart';


class LoginForm extends StatefulWidget {  
  static const routeName = "/-form";

 const LoginForm({super.key});

 @override
 LoginFormState createState() => LoginFormState();
}



class LoginFormState extends State<LoginForm>{
  CustomWidgets customWidgets = CustomWidgets();

  final _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Widget createLoginScreen(BuildContext context){
    return Column(
      
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 35),
          child: TextButton(
            onPressed: () {
              print("Eventually firebase auth");
            },
            child: const Text("Login", 
            style: TextStyle(
            color: NormalTheme.primaryColor,
            fontSize: 30
          ))),
        ),
        customWidgets.customTextField(
          context, 
          _emailController,
          Icons.email,
          "Email"
        ),
        customWidgets.customTextField(
          context,
           _passwordController,
          Icons.password,
          "Password"
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: NormalTheme.backgroundColor,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.pushReplacementNamed(context, LoggedOutPage.routeName);
            },
          )
        ],
        backgroundColor: NormalTheme.backgroundColor,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 230),
          child: Container(
            child: createLoginScreen(context),
          ),
        )
      ],
    )
    );
  }
}