


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sawf/homepage/newHomepage.dart';
import 'package:sawf/priceScreen/PriceScreen.dart';

class Routing{
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;

    switch(settings.name){
      case "/":
      return MaterialPageRoute(
        builder: (context) => const Homepage()
        );

        case "/price-screen":
        if(args is PriceScreenArgs) {
          return MaterialPageRoute(
            builder: (context) => PriceScreen(args.stockName, args.stockInfo, args.retrievePriceHistoryCallback)
            );
        } else {
          return
         MaterialPageRoute(builder: (context) => Text("Error"));
        }
        default: 
        return
         MaterialPageRoute(builder: (context) => Text("Error"));
  }
}
}