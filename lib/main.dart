
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:sawf/priceScreen/PriceScreen.dart';
import 'package:sawf/routing.dart';
import 'src/constants/firebase_options.dart';
import 'homepage/newHomepage.dart';



void main() async {
  // Firebase initialization
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Run App
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HomeProvider())
      ],
      child: 
        MaterialApp(
        initialRoute: "/",
        onGenerateRoute: Routing.generateRoute,
          
    )));
}
