import 'package:ecom/order/order_list_screen.dart';
import 'package:ecom/resturant/resturant_screen_bloc.dart';
import 'package:ecom/slide_screen/slide_screen.dart';
import 'package:ecom/utils/globals.dart' as globals;
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'data_classes.dart';

class RestaurantListPage extends StatefulWidget {
  RestaurantListPage({Key key}) : super(key: key);

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  RestaurantBloc _bloc = RestaurantBloc();
  ProgressDialog pr;

  List<Restaurant> _restaurantList = new List();
  TableMenuList firstMenu = new TableMenuList();

  List<Restaurant> _tempRestaurantList = new List();

  @override
  void initState() {
    super.initState();
    _bloc.add(LoadRestaurantEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RestaurantBloc, RestaurantScreenState>(
      bloc: _bloc,
      listener: (context, state) {
        print(state);
        if (pr?.isShowing() ?? false) {
          pr.hide();
        }
        if (state is RestaurantLoadingState) {
          pr = ProgressDialog(context, type: ProgressDialogType.Normal, isDismissible: false);
          pr.style(
              message: "Loading",
              progressWidget: FlareActor("assets/flares/loading.flr", alignment: Alignment.center, fit: BoxFit.contain, animation: "Alarm"),
              progressTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w300),
              messageTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w400));
          pr.show();
        } else if (state is RestaurantLoadErrorState) {
          ///can handle error state here
        } else if (state is RestaurantLoadedState) {
          _restaurantList.addAll(state.restaurantList.restaurantList);
          _tempRestaurantList.addAll(state.restaurantList.restaurantList);
          firstMenu = state.restaurantList.restaurantList.first.tableMenuList.first;
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, RestaurantScreenState state) {
          return (state is RestaurantLoadedState)///this only throw the widget tree if it is in loaded state
              ? MaterialApp(
                  home: DefaultTabController(
                    length: _restaurantList.first.tableMenuList.length,
                    child: Scaffold(
                      drawer: NavDrawer(),///Sidebar
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        iconTheme: IconThemeData(color: Colors.black),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                ///Navigate to Cart Screen
                                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPage()));
                              },
                              child: Container(
                                child: Stack(
                                  children: <Widget>[
                                    Icon(
                                      Icons.shopping_cart,
                                      color: Colors.black54,
                                      size: 40,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.red),
                                      child: Text(
                                        " ${globals.orderList?.length ?? 0} ",
                                        style: TextStyle(color: Colors.white,fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        bottom: TabBar(
                          labelColor: Colors.redAccent,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.redAccent,
                          isScrollable: true,
                          tabs: _restaurantList.first.tableMenuList.map((TableMenuList menuList) {
                            return Tab(
                              text: menuList.menuCategory,
                            );
                          }).toList(),
                        ),
                      ),
                      body: TabBarView(
                        children: _restaurantList.first.tableMenuList.map((TableMenuList menuList) {
                          return (null != menuList.categoryDishes && firstMenu.categoryDishes.isNotEmpty)
                              ? ListView.builder(
                            physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: menuList.categoryDishes.length,
                                itemBuilder: (context, i) {
                                  return Column(
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.all(10.0),
                                        child: (Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        menuList.categoryDishes[i]?.dishName ?? "Food Name",
                                                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
                                                      ),
                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: <Widget>[
                                                          Text("INR ${menuList.categoryDishes[i]?.dishPrice.toString() ?? "100"}",
                                                            style: TextStyle(color: Colors.black, fontSize: 15,height: 2, fontWeight: FontWeight.w500),
                                                          ),
                                                          Text("${menuList.categoryDishes[i]?.dishCalories.toString() ?? "100"} calories",
                                                            style: TextStyle(color: Colors.black, fontSize: 15,height: 2, fontWeight: FontWeight.w500),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(height: 8,),
                                                      Text(menuList.categoryDishes[i]?.dishDescription ?? "Food Name",
                                                        style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w300),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                (null != menuList.categoryDishes[i] && null != menuList.categoryDishes[i].dishImage)
                                                    ? Container(
                                                        width: 60.0,
                                                        height: 70.0,
                                                        decoration: new BoxDecoration(
                                                          borderRadius: BorderRadius.circular(3),
                                                          color: Colors.transparent,
                                                          image: DecorationImage(
                                                            image: NetworkImage(menuList.categoryDishes[i].dishImage),
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
                                                        child: Center(child: Text(menuList.categoryDishes[i]?.dishImage?.substring(0, 1) ?? "A")),
                                                      ),
                                              ],
                                            ),
                                            SizedBox(height: 8,),
                                            Container(
                                              height: 40,
                                              width: 120,
                                              decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.green),
                                              padding: EdgeInsets.all(6),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  ///Used to remove from Cart Screen
                                                  InkWell(
                                                      onTap: () {
                                                        ///if quantity of  dish is null it initialized as 0
                                                        if (menuList.categoryDishes[i].qty == null) {
                                                          menuList.categoryDishes[i].qty = 0;
                                                        }
                                                        ///if quantity is zero then there is no need to be remove
                                                        if (menuList.categoryDishes[i].qty != 0) {
                                                          setState(() {
                                                            ///here remove one quantity from current object
                                                            menuList.categoryDishes[i].qty--;
                                                            if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                                              ///if quantity is reduced to zero then need to remove the data from cart
                                                              if (menuList.categoryDishes[i].qty == 0) {
                                                                globals.orderList.remove(menuList.categoryDishes[i]);
                                                              } else {
                                                                ///if quantity is not zero the we need to replace the value from the cart
                                                                globals.orderList.forEach((element) {
                                                                  ///search for the current dish
                                                                  if (element.dishId == menuList.categoryDishes[i].dishId) {
                                                                    ///if current dish founded then replace the cart with the new quantity
                                                                    element.qty = menuList.categoryDishes[i].qty;
                                                                  }
                                                                });
                                                              }
                                                            }
                                                          });
                                                        }
                                                      },
                                                      child: Icon(Icons.remove, color: Colors.white)),
                                                  Text("${menuList.categoryDishes[i]?.qty ?? 0}",
                                                    style: TextStyle(color: Colors.white, fontSize: 15),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        ///if quantity of  dish is null it initialized as 0
                                                        if (menuList.categoryDishes[i].qty == null) {
                                                          menuList.categoryDishes[i].qty = 0;
                                                        }
                                                        setState(() {
                                                          ///here add one more quantity from current object
                                                          menuList.categoryDishes[i]?.qty++;
                                                          ///Here there is two conditions
                                                          /// => item may be already present in the cart
                                                          ///         if item is already present in the list add one more quantity to the item
                                                          /// => item may not be present in the cart
                                                          ///         then add the dish to the cart with quantity

                                                          bool isInCartFlag = false;
                                                          ///flag used to check whether it is already in the cart
                                                          if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                                            globals.orderList.forEach((element) {
                                                              if (element.dishId == menuList.categoryDishes[i].dishId) {
                                                                ///if dish is found in the cart then change the quantity
                                                                ///set flag as true
                                                                element.qty = menuList.categoryDishes[i].qty;
                                                                isInCartFlag = true;
                                                              }
                                                            });
                                                          }
                                                          if (!isInCartFlag) {
                                                           ///if the element not in the cart then add the current dish object to the cart
                                                            globals.orderList.add(menuList.categoryDishes[i]);
                                                          }
                                                        });
                                                      },
                                                      child: Icon(Icons.add, color: Colors.white)),
                                                ],
                                              ),
                                            ),
                                            (menuList.categoryDishes[i].addonCat != null && menuList.categoryDishes[i].addonCat.isNotEmpty)
                                                ? Padding(
                                                  padding: const EdgeInsets.only(top:4.0,bottom: 4),
                                                  child: Text(
                                                      "Customizations available",
                                                      style: TextStyle(color: Colors.red),
                                                    ),
                                                )
                                                : Text(""),
                                          ],
                                        )),
                                      ),
                                      Divider(
                                        height: 2,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  );
                                },
                              )
                              : Center(
                                  child: Text("Empty data"),
                                );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: Text("Empty Data"),
                  ),
                );
        },
      ),
    );
  }
}
