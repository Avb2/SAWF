import 'package:flutter/material.dart';
import 'package:sawf/src/constants/constants_colors.dart';

// COMPLETE

// APPBAR
class HomeAppBar extends StatefulWidget implements PreferredSizeWidget{
  // MyAppBar instances take a title argument that will be displayed as the title of the AppBar()
  final String title;
  final Function shuffleRandomStockList;

  const HomeAppBar(this.title, this.shuffleRandomStockList, {super.key});


  @override
  HomeAppBarState createState() => HomeAppBarState();


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}



class HomeAppBarState extends State<HomeAppBar>{

  final TextStyle titleTextStyle =  const TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.bold,
      color: NormalTheme.primaryColor
  );


  @override
  Widget build(BuildContext context) {
    return AppBar(
        title: Text(
          widget.title,
          style: titleTextStyle,
        ),
        backgroundColor: NormalTheme.backgroundColor,
        elevation: 0,
      actions: [
        IconButton(
            onPressed: () => widget.shuffleRandomStockList(),
            icon: const Icon(Icons.autorenew_sharp)
        )
      ],
    );
  }

}
