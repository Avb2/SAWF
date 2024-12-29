import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sawf/src/constants/APIKEYS.dart';
import '../drawer/AppDrawer.dart';
import '../priceScreen/PriceScreen.dart';



// HOMEPAGE
class Homepage extends StatefulWidget{
  final FirebaseFirestore firestore;

  const Homepage(this.firestore, {super.key});

  @override
  HomepageState createState() => HomepageState();
}

class HomepageState extends State<Homepage> {

  TextEditingController stockInputFieldController = TextEditingController();

  var stockInfo = [];

  var randomStock1;
  var randomStock2;
  var randomStock3;

  late int quickTickerCount;

  late List<String> quickTickerList;

  late var quickTickerTextStyle;
  late var quickTickerBoxDeco;

  @override
  void initState(){
    super.initState();

    quickTickerCount = 0;

    quickTickerTextStyle = const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.green
    );

    quickTickerList = ["TSLA", "F", "O", "SYF", "PG", "PP"];
    quickTickerList.shuffle();


    quickTickerBoxDeco = BoxDecoration(
        border: Border.all(
            color: Colors.black,
            width: 2)
    );

    if (quickTickerCount == 0) {
      randomStock1 = quickTickerList[0];
      randomStock2 = quickTickerList[1];
      randomStock3 = quickTickerList[2];
    }

    quickTickerCount++;

  }


  void loadHomepage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Homepage(FirebaseFirestore.instance)
    )
    );
  }


  Future<List<Map<String, dynamic>>> retrievePriceHistory(String stockName) async{
    QuerySnapshot retievedData = await FirebaseFirestore.instance
        .collection("stockData")
        .where("name", isEqualTo: stockName)
        .get();

    // List of DocumentSnapshot Objects
    List<DocumentSnapshot<Object?>> retrievedDataList = retievedData.docs;

    // List of Map<String, dynamic>
    List<Map<String, dynamic>> priceList = [];

    // Iterate through retrievedDataList
    for (var dataSet in retrievedDataList){

      var dataPrice = dataSet["price"];


      var timestamp = dataSet["timestamp"];

      // Add Map<String, dynamic> to the priceList
      priceList.add(
          {
            "price": dataPrice.toString(),
            "timestamp" : timestamp
          }
      );

    }

    // Returns a list of Map<String, String>
    return priceList;
  }

  String? collectUserInput(){
    final userSearch = stockInputFieldController.text;

    stockInputFieldController.clear();
    return userSearch;
  }

  void makeAPIget(String? userSearch) async {
    // IF the user search is not empty:
    if (userSearch != null){
      // API url
      final url = Uri.parse('https://twelve-data1.p.rapidapi.com/price');

      // Parameters passed to the API
      final queryParams = {
        "symbol" : userSearch
      };

      // Pass the parameters to the url
      final uri = url.replace(queryParameters: queryParams);

      // Wait for a response from the API
      final response = await http.get(uri, headers: headers);

      // Decode the jsonResponse
      final jsonResponse = json.decode(response.body);

      // If no error code
      if (jsonResponse["code"] != 400){

        // If the value does not exist:
        bool alreadyExists = false;
        int count = 0;

        // Checks for repeating keys within stockInfo and replaces value if true
        for (var dictionaries in stockInfo){
          // Gets the current key
          var key = dictionaries.keys;

          // Removes the parenthesis from the key
          for (var keyNoParenthesis in key){
            key = keyNoParenthesis;
          }

          // If the userSearch value already exists within the stockInfo list, the price value will be updated
          if (userSearch.toUpperCase() == key){

            // Get price from API
            double responseDoubleForm = double.parse(jsonResponse["price"]);

            // Convert price into the proper format and turn it back into a double
            double formattedPrice = double.parse(responseDoubleForm.toStringAsFixed(2));

            // Change the value of alreadyExists to true
            alreadyExists = true;

            setState(() {
              stockInfo[count][key] = formattedPrice;
            });

            addData(userSearch.toUpperCase(), formattedPrice);
          }
          count ++;
        }

        if (!alreadyExists){
          // Get price from API
          double responseDoubleForm = double.parse(jsonResponse["price"]);

          // Convert price into the proper format and turn it back into a double
          double formattedPrice = double.parse(responseDoubleForm.toStringAsFixed(2));

          alreadyExists = true;

          setState(() {
            stockInfo += [{userSearch.toUpperCase() : formattedPrice}];
          });

          addData(userSearch.toUpperCase(), formattedPrice);
        }
      }
    }
  }


  void addData(String name, double price) async{
    CollectionReference stockData = FirebaseFirestore.instance.collection("stockData");
    DocumentReference newDocRef = await stockData.add(
        {
          "name" : name,
          "price" : price,
          "timestamp": DateTime.now()
        });
  }


  @override
  Widget build(BuildContext context){

    return Scaffold(
      appBar: AppBar(
        title: const Text("Stocker"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.w800,
            color: Colors.red
        ),
        actions: [
          IconButton(
              onPressed: () {
                quickTickerList.shuffle();
                setState(() {
                  randomStock1 = quickTickerList[0];
                  randomStock2 = quickTickerList[1];
                  randomStock3 = quickTickerList[2];
                });
              },
              icon: const Icon(Icons.autorenew)
          )
        ],
        backgroundColor: Colors.,
      ),
      drawer: Builder(
        builder: (BuildContext context){
          return const AppDrawer();
        },
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                          decoration: quickTickerBoxDeco,
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: TextButton(
                              child: Text(
                                  "$randomStock1",
                                  style: quickTickerTextStyle),
                              onPressed: () {
                                makeAPIget(randomStock1);
                              },
                            ),
                          ))
                  ),
                  Expanded(
                    child: Container(
                        decoration: quickTickerBoxDeco,
                        padding: const EdgeInsets.all(5),
                        child: Center(
                            child: TextButton(
                              onPressed: () {makeAPIget(randomStock2);},
                              child:Text(
                                "$randomStock2",
                                style: quickTickerTextStyle,
                              ),
                            )
                        )
                    ),
                  ),
                  Expanded(
                      child: Container(
                          decoration: quickTickerBoxDeco,
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: TextButton(
                                onPressed: () {makeAPIget(randomStock3);},
                                child: Text(
                                  "$randomStock3",
                                  style: quickTickerTextStyle,
                                )
                            ),
                          )
                      )
                  )
                ],
              )
          ),

          const Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: Text(
                  "Search Name or Ticker",
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white60
                  ),
                ),
              )
          ),
          Center(
              child: TextFormField(
                controller: stockInputFieldController,
                decoration: const InputDecoration(
                    icon: Icon(
                        Icons.call_made
                    ),
                    iconColor: Colors.red,
                    labelText: "Stock Name",
                    labelStyle: TextStyle(
                        fontSize: 20,
                        color: Colors.white60
                    )
                ),
              )
          ),
          Center(
            child: TextButton(
              onPressed: (){
                var userSearch = collectUserInput();
                makeAPIget(userSearch);
              },
              child: const Text(
                "Enter",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.red
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: stockInfo.length,
                itemBuilder: (BuildContext context, int index){
                  Map<String, double> info = stockInfo[index];

                  String name;
                  double price;

                  info.forEach((key, value) {
                    name = key;
                    price = value;
                  });

                  return ListTile(
                    title: TextButton(
                        onLongPress: () {
                          var currentStock = stockInfo[index];
                          setState(() {
                            stockInfo.remove(currentStock);
                          });
                        },
                        onPressed: () {
                          var priceHistory = (name);
                          var priceHistoryList = [];

                          priceHistory.then((priceHistoryList) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => PriceScreen(name, makeAPIget, addData, stockInfo, retrievePriceHistory)
                            )
                            );
                          });
                        },
                        child: Text(
                          name,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold
                          ),
                        )
                    ),
                    subtitle: Center(
                      child: Text(
                        "\$$price",
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 15
                        ),
                      ),
                    ),
                  );

                }
            ),
          )
        ],
      ),
    );
  }

}

