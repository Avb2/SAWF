import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sawf/appbar/HomeAppBar.dart';
import 'package:sawf/src/constants/constants_colors.dart';
import 'package:sawf/src/constants/APIKEYS.dart';
import 'package:sawf/src/constants/constants_styles.dart';
import 'package:sawf/src/constants/constants_styles.dart';
import '../drawer/AppDrawer.dart';
import '../priceScreen/PriceScreen.dart';



class HomeProvider extends ChangeNotifier{
  var   displayedStocks = [];

  late List<String> randomStockList= [
    "TSLA",
    "F",
    "O",
    "SYF",
    "PG",
    "PP",
    "GME",
    "QQQ",
    "ABNB",
    "QCOM",
    "AXP"
  ];


  late String randomStock1;
  late String randomStock2;
  late String randomStock3;



  // PARAM USE: count: stops the generation of new random stock values
  // PARAM USE: stockList:  List of random stocks to bFe generated and displayed at the top of the homepage
  void generateRandomStocks(int count, List<String> stockList) {
    stockList.shuffle();

    if (count == 0) {
        randomStock1 = stockList[0];
        randomStock2 = stockList[1];
        randomStock3 = stockList[2];
        count++;
        notifyListeners();
      }
    }

  void loadHomepage(BuildContext context){
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => Homepage()
    )
    );
  }

  // PARAM USE: userSearch: User text collected from the stock input field
  void callAPIget(String? userSearch) async {
    // If the user search is not empty:
    if (userSearch != null) {

      // Make API call and get json response
      Uri uri = buildPriceApiUrl(userSearch);
      var jsonResponse = await awaitResponseAndDecode(uri);
      print(jsonResponse);
      print(jsonResponse.keys);

      // If theres no error  
      if (jsonResponse["error"] == null) {
        // format the json response price to a double
        double formattedPrice = formatPriceToDouble(jsonResponse);

        if (displayedStocks.isEmpty){
          addValueToDisplayedStocksList(userSearch, formattedPrice);
        }
        else{
          var duplicate = false;

          for (var x in displayedStocks) {
            if (x["name"] == userSearch.toUpperCase()){
              duplicate = true;
                x["price"] = formattedPrice;
              addValueToDisplayedStocksList(userSearch.toUpperCase(), formattedPrice);
            }
          }
          if (duplicate != true){
            addValueToDisplayedStocksList(userSearch, formattedPrice);
            addValueToDisplayedStocksList(userSearch.toUpperCase(), formattedPrice);
          }
        }
      }
    }
    notifyListeners();
  }

  void addValueToDisplayedStocksList(userSearch, formattedPrice){
    
      displayedStocks.add(
          {"name": userSearch.toUpperCase(),
            "price" : formattedPrice}
      );
notifyListeners();
  }

  // PARAM USE: controller: TextEditingController of the text field that a value should be collected from
  // RETURNS: Value from the text field controlled by the TextEditingController
  String? collectUserInput(TextEditingController controller){
    var text = controller.text;
    controller.clear();
    notifyListeners();
    return text;

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
  

  // PARAM USE: userSearch: Ticker symbol value user is searching
  Uri buildPriceApiUrl(String? userSearch){
    // API url
    final url = Uri.parse('https://twelve-data1.p.rapidapi.com/price');

    // Parameters passed to the API
    final queryParams = {
      "symbol" : userSearch
    };

    // Pass the parameters to the url
    final uri = url.replace(queryParameters: queryParams);
    notifyListeners();
    return uri;
  }


  // PARAM USE: uri: Uri containing the symbol parameter
  // RETURNS: Decoded JSON response body
  Future<Map<String, dynamic>> awaitResponseAndDecode(Uri uri) async{
    // Wait for a response from the API
    final response = await http.get(uri, headers: headers);

    // Decode the jsonResponse
    final jsonResponse = json.decode(response.body);

    if (jsonResponse["code"] == null) {
      notifyListeners();
      return jsonResponse;
    }
    else {
      notifyListeners();
      return {"error":"error"};
    }
  }


  // PARAM USE: jsonResponse: jsonResponse from API get reuqest containing stock data
  // RETURNS: correctly formatted price
  double formatPriceToDouble(dynamic jsonResponse) {
    // Get price from jsonResponse
    double responseDoubleForm = double.parse(jsonResponse["price"]);

    // Convert price into the proper format and turn it back into a double
    double formattedPrice = double.parse(responseDoubleForm.toStringAsFixed(2));
    notifyListeners();
    return formattedPrice;
  }


  void updateStockInfoIfExists(bool alreadyExists, double formattedPrice, int count, String key, Function addData, String userSearch){

    
      // Change the value of alreadyExists to true
      alreadyExists = true;

      displayedStocks[count][key] = formattedPrice;

    addData(userSearch.toUpperCase(), formattedPrice);

    notifyListeners();
  }


  void shuffleRandomStockList(){
      randomStockList.shuffle();
      randomStock1 = randomStockList[0];
      randomStock2 = randomStockList[1];
      randomStock3 = randomStockList[2];

      notifyListeners();
  }


  Widget buildRandomStockTickers(BuildContext context) {
    return Center(
            child: Row(
              children: [
                Expanded(
                    child: Container(
                      decoration: randomStockBoxDeco,
                      padding: const EdgeInsets.all(5),
                      child: Center(
                        child: TextButton(
                          child: Text(
                            randomStock1,
                            style: randomStockTextStyle),
                          onPressed: (){
                            callAPIget(randomStock1);

                          },
                          ),
                        ),
                      ),
                    ),
                Expanded(
                  child: Container(
                    decoration: randomStockBoxDeco,
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: TextButton(
                        child: Text(
                            randomStock2,
                            style: randomStockTextStyle),
                        onPressed: (){
                          callAPIget(randomStock2);
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: randomStockBoxDeco,
                    padding: const EdgeInsets.all(5),
                    child: Center(
                      child: TextButton(
                        child: Text(
                            randomStock3,
                            style: randomStockTextStyle),
                        onPressed: (){
                          callAPIget(randomStock3);
                        },
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }


  Widget buildStockSearchForm(BuildContext context, TextEditingController stockInputFieldController){
    return Column(
      children: [
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
                decoration: InputDecoration(
                    icon: const Icon(
                        Icons.call_made
                    ),
                    iconColor: NormalTheme.primaryColor,
                    labelText: "Stock Name",
                    labelStyle: stockInputFieldTextStyle
                ),
              )
          ),
          Center(
            child: TextButton(
              onPressed: (){
                String? userSearch = collectUserInput(stockInputFieldController);
                callAPIget(userSearch);
              },
              child: Text(
                "Enter",
                style: enterButtonTextStyle,
              ),
            ),
          )
      ],
    );
  }

  Widget buildStockOutput(BuildContext context){
    return Expanded(
            child: ListView.builder(
                itemCount: displayedStocks.length,
                itemBuilder: (BuildContext context, int index){
                  print(index);
                  print("displayedstocks type: ${displayedStocks.runtimeType}");
                  var info = displayedStocks[index];

                  print(info);
                  print("info runtimeType: ${info.runtimeType}");


                  var name = info["name"];
                  var price = info["price"];


                  return ListTile(
                    title: TextButton(
                        onLongPress: () {
                          var currentStock = displayedStocks[index];
                          
                            displayedStocks.remove(currentStock);
                        },
                        onPressed: () async {

                          var priceHistory = (name);
                          var priceHistoryList = [];

                          PriceScreenArgs priceScreenArgs = await PriceScreenArgs(name, info, retrievePriceHistory(name));

                          priceHistory.then((priceHistoryList) {
                            Navigator.pushNamed(context, '/price-screen', arguments: priceScreenArgs);
                            
                          });
                        },
                        child: Text(
                          "$name",
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
                            color: NormalTheme.secondaryColor,
                            fontSize: 15
                        ),
                      ),
                    ),
                  );

                }
            ),
          );
  }

}
  

// Homepage

class Homepage extends StatefulWidget{
  const Homepage({super.key});

  // Create State
  @override
  HomepageState createState() => HomepageState();

  
}


class HomepageState extends State<Homepage>{
  TextEditingController stockInputFieldController = TextEditingController();

  

  // init state
  @override
  void initState() {
    super.initState();
    }


  void initializeData(provider) {
    int stopRandomStock = 0;

    provider.randomStockList.shuffle();

    provider.generateRandomStocks(stopRandomStock, provider.randomStockList);
  
  }




  @override
  Widget build(BuildContext context) {
    // Home provider instance and generate stock tickers for the random stock tickers
    HomeProvider homeProvider = Provider.of<HomeProvider>(context);
    initializeData(homeProvider);
      

    return Scaffold(
      appBar: HomeAppBar("Stockr", homeProvider.shuffleRandomStockList),
      body: Column(
        children: <Widget> [
          homeProvider.buildRandomStockTickers(context),
          homeProvider.buildStockSearchForm(context, stockInputFieldController),
          homeProvider.buildStockOutput(context)
          
        ],
      ),
      backgroundColor: NormalTheme.backgroundColor
    );
  }
}