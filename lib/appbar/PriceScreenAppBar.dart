import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sawf/src/constants/constants_colors.dart';

class PriceScreenAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String stockName;
  final List<dynamic> stockInfo;
  final dynamic priceList;
  final double maxPrice;
  final Function makeAPIget;
  final Function retrievePriceHistory;
  final Function setState;

  const PriceScreenAppBar(
      this.stockName,
      this.stockInfo,
      this.priceList,
      this.maxPrice,
      this.makeAPIget,
      this.retrievePriceHistory,
      this.setState,
      {super.key}
      );

  


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context){
    return AppBar(
        backgroundColor: Colors.black,
        title: Text(
          stockName,
          style: const TextStyle(
              color: NormalTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 25
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {

                makeAPIget(stockName);

                Map<String, double> si = stockInfo.last;

                var priceHistory = retrievePriceHistory(stockName);

                var timestamp = Timestamp.now().toDate();

                setState(() {
                  priceList.add({
                    "price" : priceList.last,
                    "timestamp" : 0
                  });
                });

              },
              icon: const Icon(Icons.autorenew)
          )
        ],

        leading: Text(
          "MAX PRICE: $maxPrice",
          style: const TextStyle(
              color: NormalTheme.secondaryColor
          ),

        )
    );
  }
}