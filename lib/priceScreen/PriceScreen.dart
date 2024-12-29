import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sawf/appbar/PriceScreenAppBar.dart';
import 'package:sawf/homepage/newHomepage.dart';
import 'package:sawf/src/constants/constants_colors.dart';



// Price screen arguments
class PriceScreenArgs{
  String stockName;
  List<dynamic> stockInfo;
  dynamic retrievePriceHistoryCallback;

  PriceScreenArgs(this.stockName, this.stockInfo, this.retrievePriceHistoryCallback);
}


// PRICE LIST SCREEN
class PriceScreen extends StatefulWidget{
  final String stockName;
  final List<dynamic> stockInfo;
  final Function retrievePriceHistoryCallback;

  const PriceScreen(this.stockName, this.stockInfo, this.retrievePriceHistoryCallback, {super.key});

  static const routeName = "/price_screen";
  
  @override
  PriceScreenState createState() => PriceScreenState();
}


class PriceScreenState extends State<PriceScreen> {
  var priceList;
  late List<Map<dynamic, dynamic>> points = [];
  var maxPrice = 0.0;
  var minPrice = 0.0;
  var dateList = [];

  HomeProvider homeProvider = HomeProvider();


  void createGraphPoints(List<dynamic> list){
    for (var index = 1; index < list.length+1; index++) {
      // Price point
      var val = list[index-1];

      // Add the x and y value to the graph, with x being the index and y being the stock price
      points.add({"x": index, "y": val});

      // If the price is less than the max price of the stock sets a new mnax price as the current price
      if (val > maxPrice){
        maxPrice = val;
      }
      // If the minPrice is 0, the current price is the new minimum price
      if (minPrice == 0){
        minPrice = val;
      // If the minimum price is greater than the current price, the minimum price is the current price
      } else if (val < minPrice){
        minPrice = val;
      }
    }
  }


  // PARAM USE: stockName: searches the database for an equal value
  // RETURNS: a timestamped price list of all price history from the database
  Future<List<Map<String, dynamic>>> retrievePriceHistory(String stockName) async {
    QuerySnapshot retrievedData = await FirebaseFirestore.instance
        .collection("stockData")
        .where("name", isEqualTo: stockName)
        .get();

    // List of DocumentSnapshot objects
    List<DocumentSnapshot<Object?>> retrievedDataList = retrievedData.docs;

    List<Map<String, dynamic>> timestampedPricelist = [];

    for (var dataSet in retrievedDataList) {
      var price = dataSet["price"];

      var timestamp = dataSet["timestamp"];

      // Add dictionary containing price and timestamp to the timestampedPricelist
      timestampedPricelist.add({
        "price": price.toString(),
        "timestamp": timestamp
      }
      );
    }
    return timestampedPricelist;
  }


  


  // Init state
  @override
  void initState(){
    super.initState();

    // Create a list of prices in double form
    List<dynamic> priceOnly = createPriceOnlyList();

    // Creates x,y pairs to be plotted on the price history graph
    createGraphPoints(priceOnly);
    var homeProvider = HomeProvider();

     priceList = homeProvider.retrievePriceHistory(widget.stockName);
  }


  List<dynamic> createPriceOnlyList (){
    // List where the price goes
    List<dynamic> priceOnly = [];

    // Sort the price list and put it in chronological order
    priceList.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));

    // Iterate through the price list
    for (var val in priceList){
      // Add the price to the priceOnly list
      priceOnly.add(double.parse(val["price"]));
    }

    return priceOnly;
  }


  void makeAPIget(String? userSearch) async {
    
    if (userSearch != null) {
      homeProvider.callAPIget(userSearch);
    }
  }


  void addData(String name, double price) async{
    homeProvider.addValueToDisplayedStocksList(name, price);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PriceScreenAppBar(
            widget.stockName,
            widget.stockInfo,
            priceList,
            maxPrice,
            makeAPIget,
            retrievePriceHistory,
            setState
        ),
        body: Column(
            children: [
              Expanded(
                  child: LineChart(
                    LineChartData(
                      titlesData: const FlTitlesData(
                          leftTitles: AxisTitles(
                              axisNameWidget: Text("Price"),
                              sideTitles: SideTitles(
                                  showTitles: false,
                                  reservedSize: 22,
                                  interval: 1
                              )
                          ),
                          topTitles: AxisTitles(
                              axisNameWidget: Text("Index")
                          )
                      ),
                      minX: 0,
                      maxX: points.length.toDouble()+ 5,
                      minY: minPrice-1,
                      maxY: maxPrice+3,
                      lineBarsData: [
                        LineChartBarData(
                            spots: points.map((point) => FlSpot(point["x"].toDouble(), point["y"].toDouble())).toList(),
                            isCurved: true,
                            show: true,
                            barWidth: 5,
                            curveSmoothness: .3,
                            preventCurveOverShooting: true,
                            preventCurveOvershootingThreshold: 5,
                            color: NormalTheme.secondaryColor
                        ),
                      ],
                    ),
                  )
              )
              ,Expanded(
                  child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black
                      ),
                      child: ListView.builder(
                          itemCount: priceList.length,
                          itemBuilder: (BuildContext context, int index) {

                            print("pricelist ${priceList}");
                            // Sort the timestamp in order based on time
                            priceList.sort((a, b) => a["timestamp"].compareTo(b["timestamp"]));

                            // Reverse the list of priceData and create a new list
                            var priceListReversed = priceList.reversed.toList();

                            // Get the timestamp object from the Map pair
                            var timestamp = priceListReversed[index]["timestamp"];

                            // Create a substring of the date to be displayed to the user
                            var timestampDate = (timestamp.toDate().toString().substring(
                                0, 16)).toString();

                            // Get the price from the map pair
                            var price = priceListReversed[index]["price"].toString();

                            const TextStyle priceHistoryTextStyle = TextStyle(
                                color: NormalTheme.secondaryColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            );

                            if (index == 0) {
                              return Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: NormalTheme.secondaryColor,
                                          width: 3
                                      )
                                  ),
                                  child: ListTile(
                                      title: Text(
                                          "Most Recent: \n \n \$ $price",
                                          style: priceHistoryTextStyle
                                      ),
                                      subtitle: Text(
                                          timestampDate,
                                          style: priceHistoryTextStyle
                                      ),
                                      tileColor: Colors.black
                                  ));
                            } else {
                              return Container(
                                  child: ListTile(
                                      title: Text(
                                          "\$ $price",
                                          style: priceHistoryTextStyle
                                      ),
                                      subtitle: Text(
                                          timestampDate,
                                          style: priceHistoryTextStyle
                                      ),
                                      tileColor: Colors.black
                                  )
                              );
                            }
                          }
                      ))
              )
            ]
        )
    );
  }

}
