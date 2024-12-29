import 'package:flutter/material.dart';
import 'package:new_stock_tracker/logged_out_page.dart';
import 'package:new_stock_tracker/src/constants/constants_colors.dart';
import 'package:new_stock_tracker/src/constants/custom_widgets.dart';

class AccountRegistry extends StatelessWidget{
  static const routeName = "/account-registry-form";
  final customWidgets = CustomWidgets();

  final _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();



  AccountRegistry({super.key});


  Widget createAcctRegistryForm(BuildContext context){
    return Column(
        children: [
          Padding(
          padding: const EdgeInsets.only(top: 100),
          child: TextButton(
            onPressed: () {},
            child: const Text("Create Account", 
            style: TextStyle(
            color: NormalTheme.primaryColor,
            fontSize: 30
          ))),
        ),
        customWidgets.customTextField(
          context, 
          _displayNameController,
          Icons.person_2, "Display Name"),
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
      ]);
  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: NormalTheme.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: NormalTheme.backgroundColor,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.pushReplacementNamed(context, LoggedOutPage.routeName);
            },
             icon: Icon(Icons.exit_to_app)
             )
      ]
      ),
      body: createAcctRegistryForm(context),
    );
  }
}