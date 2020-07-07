import 'package:ecom/resturant/resturent_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ecom/utils/globals.dart' as globals;

class OrderPage extends StatefulWidget {
  OrderPage({Key key}) : super(key: key);

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  int items = 0;
  double total = 0.0;

  @override
  void initState() {
    if (globals.orderList != null && globals.orderList.isNotEmpty) {
      globals.orderList.forEach((element) {
        if (element != null && element.qty != null) {
          items += element.qty;
          if (element.qty != 0) {
            total += element.qty * element.dishPrice;
          }
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
            color: Color(0xff193F14),
            child: Center(child: Text("${globals.orderList.length} Dishes - $items items", style: TextStyle(color: Colors.white))),
          ),
          Expanded(
            child: Card(
              child:(globals.orderList.isNotEmpty)?ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: globals.orderList.length,
                itemBuilder: (context, i) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    child: (Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    globals.orderList[i]?.dishName ?? "Food Name",
                                    style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "INR ${globals.orderList[i]?.dishPrice.toString() ?? "100"}",
                                    style: TextStyle(color: Colors.black, fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(
                                    "${globals.orderList[i]?.dishCalories.toString() ?? "100"} calories",
                                    style: TextStyle(color: Colors.black, fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(50)),
                                color: Color(0xff193F14),
                              ),
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
                                          total = 0;
                                          if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                            globals.orderList.forEach((element) {
                                              if (element != null && element.qty != null) {
                                                items += element.qty;
                                                if (element.qty != 0) {
                                                  total += element.qty * element.dishPrice;
                                                }
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(Icons.remove, color: Colors.white)),
                                  Text(
                                    "${globals.orderList[i]?.qty ?? 0}",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  InkWell(
                                      onTap: () {
                                        setState(() {
                                          globals.orderList[i]?.qty++;
                                          items = 0;
                                          total = 0;
                                          if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                            globals.orderList.forEach((element) {
                                              if (element != null && element.qty != null) {
                                                ///used to show how many items are present in cart
                                                items += element.qty;
                                                if (element.qty != 0) {
                                                  ///used to show the total amount
                                                  total += element.qty * element.dishPrice;
                                                }
                                              }
                                            });
                                          }
                                        });
                                      },
                                      child: Icon(Icons.add, color: Colors.white)),
                                ],
                              ),
                            ),
                            Container(
                              width: 100,
                              child: Center(
                                child: Text(
                                  "INR ${(globals.orderList[i].qty) * globals.orderList[i].dishPrice}",
                                  style: TextStyle(color: Colors.black, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 1,
                          color: Colors.grey,
                        ),
                        ((i + 1) == globals.orderList.length)
                            ? Container(
                                margin: EdgeInsets.all(10),
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Total Amount",
                                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
                                    ),
                                    Text(
                                      "INR $total",
                                      style: TextStyle(color: Colors.green, fontSize: 18),
                                    ),
                                  ],
                                ),
                              )
                            : Container()
                      ],
                    )),
                  );
                },
              ):Center(child: Text("Sorry you have no items in the list"),),
            ),
          ),
          InkWell(
            onTap: () async {
              if (globals.orderList.isNotEmpty) {
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
              }
              globals.orderList.clear();
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => RestaurantListPage()), (Route<dynamic> route) => false);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              height: 50,
              color: Color(0xff193F14),
              child: Center(child: Text("Place Order", style: TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }
}
