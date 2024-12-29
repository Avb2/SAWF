import 'package:flutter/material.dart';
import '../drawer/AppDrawer.dart';





// Portfolios
class Portfolios extends StatefulWidget{
  const Portfolios({super.key});

  @override
  PortfoliosState createState() => PortfoliosState();
}

class PortfoliosState extends State<Portfolios>{
  final title = "Portfolios";

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text(
              "Hello"
          ),
          const TextField(
          ),
          TextButton(
              onPressed: ()=> print("deez"),
              child: const Text(
                  "Deez"
              )
          )
        ],
      ),
      backgroundColor: Colors.white30,
    );
  }
}
