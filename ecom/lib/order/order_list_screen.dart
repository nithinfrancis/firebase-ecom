import 'package:ecom/resturant/resturent_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecom/utils/globals.dart' as globals;

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int items = 0;

  @override
  void initState() {
    if (globals.orderList != null && globals.orderList.isNotEmpty) {
      globals.orderList.forEach((element) {
        if (element != null && element.qty != null) {
          items += element.qty;
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Order Summery",
          style: TextStyle(color: Colors.black54),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            height: 50,
            color: Colors.green,
            child: Center(child: Text("${globals.orderList.length} Dishes - $items items", style: TextStyle(color: Colors.white))),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: globals.orderList.length,
              itemBuilder: (context, i) {
                return Container(
                  child: (Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(globals.orderList[i]?.dishName ?? "Food Name"),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text("INR ${globals.orderList[i]?.dishPrice.toString() ?? "100"}"),
                                    Text("${globals.orderList[i]?.dishCalories.toString() ?? "100"} calories"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          (null != globals.orderList[i] && null != globals.orderList[i].dishImage)
                              ? Container(
                                  width: 55.0,
                                  height: 55.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.transparent,
                                    image: DecorationImage(
                                      image: NetworkImage(globals.orderList[i].dishImage),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                )
                              : Container(
                                  width: 55.0,
                                  height: 55.0,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(55),
                                    color: Colors.transparent,
                                  ),
                                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Center(child: Text(globals.orderList[i]?.dishImage?.substring(0, 1) ?? "A")),
                                ),
                        ],
                      ),
                      Text(globals.orderList[i]?.dishDescription ?? "Food Name"),
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.green),
                        padding: EdgeInsets.all(6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    globals.orderList[i].qty--;
                                    if (globals.orderList[i].qty == 0) {
                                      globals.orderList.remove(globals.orderList[i]);
                                    }
                                    items = 0;
                                    if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                      globals.orderList.forEach((element) {
                                        if (element != null && element.qty != null) {
                                          items += element.qty;
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Icon(Icons.remove, color: Colors.white)),
                            Text("${globals.orderList[i]?.qty ?? 0}"),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    globals.orderList[i]?.qty++;
                                    items = 0;
                                    if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                      globals.orderList.forEach((element) {
                                        if (element != null && element.qty != null) {
                                          items += element.qty;
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Icon(Icons.add, color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  )),
                );
              },
            ),
          ),
          InkWell(
            onTap: () async {
              await showDialog(
                context: context,
                child: AlertDialog(
                  title: Text("Success"),
                  content: Text("Order successfully placed"),
                  actions: <Widget>[
                    InkWell(
                      onTap: () async {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5),
                          ),
                        ),
                        width: 70.0,
                        child: Center(
                            child: Text(
                          "OK",
                          style: TextStyle(color: Colors.black),
                        )),
                      ),
                    ),
                  ],
                ),
              );
              globals.orderList.clear();
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => RestaurantListPage()), (Route<dynamic> route) => false);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              height: 50,
              color: Colors.green,
              child: Center(child: Text("Place Order", style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}
