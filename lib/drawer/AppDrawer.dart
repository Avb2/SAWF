import 'package:flutter/material.dart';
import 'package:sawf/portfolios/Portfolios.dart';
import 'package:sawf/homepage/newHomepage.dart';
import 'package:sawf/src/constants/constants_colors.dart';




// // DRAWER
// class AppDrawer extends StatefulWidget{
//   const AppDrawer({super.key});

//   @override
//   AppDrawerState createState() => AppDrawerState();
// }

// class AppDrawerState extends State<AppDrawer> {
//   String? customMsg;
//   late bool customMsgTextField;
//   TextEditingController customMsgController = TextEditingController();

//   @override
//   void initState(){
//     super.initState();

//     setState(() {
//       customMsg = "Welcome!";

//       customMsgTextField = false;
//     });
//   }

//   void loadStockpage(BuildContext context) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(builder:
//             (context) => const Portfolios()
//         )
//     );
//   }

//   Widget createMsgTextField(BuildContext context){
//     return TextField(
//       controller: customMsgController,
//       onSubmitted: (String value){
//         setState(() {
//           customMsg = customMsgController.text;
//         });
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context){
//     return Drawer(
//       child: ListView(
//         children: <Widget>[
//           DrawerHeader(
//               decoration: const BoxDecoration(
//                   color: NormalTheme.primaryColor,
//                   shape: BoxShape.circle
//               ),
//               child: TextButton(

//                 onPressed: () {
//                   setState(() {
//                     customMsgTextField = !customMsgTextField;
//                   });
//                 },
//                 child: Text(
//                   customMsg!,
//                   style: const TextStyle(
//                       fontSize: 30.0,
//                       fontWeight: FontWeight.bold
//                   ),
//                 ),
//               )
//           ),
//           if (customMsgTextField)
//             createMsgTextField(context),

//           ListTile(
//               leading: const Icon(
//                   Icons.home
//               ),
//               title: const Text(
//                   "Home"
//               ),
//               onTap: ()=>
//                   HomepageState().loadHomepage(context)
//           ),
//           ListTile(
//               leading: const Icon(
//                   Icons.ad_units_sharp
//               ),
//               title: const Text(
//                   "View Portfolios"
//               ),
//               onTap: () => Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => const Portfolios(),
//               ))
//           ),
//           ListTile(
//               leading: const Icon(
//                   Icons.call_made
//               ),
//               title: const Text(
//                   "Find Stocks"
//               ),
//               onTap: () => print("Take user to Find Stocks page")
//           ),
//           ListTile(
//             leading: const Icon(
//                 Icons.account_tree_rounded
//             ),
//             title: const Text(
//                 "Company Info"
//             ),
//             onTap: () => print("Take user to Company Info page"),
//           ),
//           ListTile(
//             leading: const Icon(
//                 Icons.settings
//             ),
//             title: const Text(
//                 "Settings"
//             ),
//             onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const Portfolios())),
//           ),
//           ListTile(
//             leading: const Icon(
//                 Icons.account_box_outlined
//             ),
//             title: const Text(
//                 "Close Drawer"
//             ),
//             onTap: ()=>Navigator.pop(context),
//           )
//         ],
//       ),
//     );
//   }

// }
