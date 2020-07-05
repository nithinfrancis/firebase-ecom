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

  final _searchController = TextEditingController();

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
        } else if (state is RestaurantLoadedState) {
          _restaurantList.addAll(state.restaurantList.restaurantList);
          _tempRestaurantList.addAll(state.restaurantList.restaurantList);
          firstMenu = state.restaurantList.restaurantList.first.tableMenuList.first;
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, RestaurantScreenState state) {
          return (state is RestaurantLoadedState)
              ? MaterialApp(
//            color: Colors.white,
                  home: DefaultTabController(
                    length: _restaurantList.first.tableMenuList.length,
                    child: Scaffold(
                      drawer: NavDrawer(),
                      appBar: AppBar(
                        backgroundColor: Colors.white,
                        iconTheme: IconThemeData(color: Colors.black),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
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
                                        "${globals.orderList?.length ?? 0}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        bottom: TabBar(
                          labelColor: Colors.purple,
                          unselectedLabelColor: Colors.grey,
                          indicatorColor: Colors.purple,
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
                          return SingleChildScrollView(
                            child: (null != menuList.categoryDishes && firstMenu.categoryDishes.isNotEmpty)
                                ? Container(
                                    height: 500,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: menuList.categoryDishes.length,
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
                                                        Text(menuList.categoryDishes[i]?.dishName ?? "Food Name"),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: <Widget>[
                                                            Text("INR ${menuList.categoryDishes[i]?.dishPrice.toString() ?? "100"}"),
                                                            Text("${menuList.categoryDishes[i]?.dishCalories.toString() ?? "100"} calories"),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  (null != menuList.categoryDishes[i] && null != menuList.categoryDishes[i].dishImage)
                                                      ? Container(
                                                          width: 55.0,
                                                          height: 55.0,
                                                          decoration: new BoxDecoration(
                                                            borderRadius: BorderRadius.circular(5),
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
                                              Text(menuList.categoryDishes[i]?.dishDescription ?? "Food Name"),
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
                                                          if (menuList.categoryDishes[i].qty == null) {
                                                            menuList.categoryDishes[i].qty = 0;
                                                          }
                                                          if (menuList.categoryDishes[i].qty != 0) {
                                                            setState(() {
                                                              menuList.categoryDishes[i].qty--;
                                                              if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                                                if (menuList.categoryDishes[i].qty == 0) {
                                                                  globals.orderList.remove(menuList.categoryDishes[i]);
                                                                } else {
                                                                  globals.orderList.forEach((element) {
                                                                    if (element.dishId == menuList.categoryDishes[i].dishId) {
                                                                      element.qty = menuList.categoryDishes[i].qty;
                                                                    }
                                                                  });
                                                                }
                                                              }
                                                            });
                                                          }
                                                        },
                                                        child: Icon(Icons.remove, color: Colors.white)),
                                                    Text("${menuList.categoryDishes[i]?.qty ?? 0}"),
                                                    InkWell(
                                                        onTap: () {
                                                          if (menuList.categoryDishes[i].qty == null) {
                                                            menuList.categoryDishes[i].qty = 0;
                                                          }
                                                          setState(() {
                                                            menuList.categoryDishes[i]?.qty++;
                                                            bool isInCartFlag = false;
                                                            if (globals.orderList != null && globals.orderList.isNotEmpty) {
                                                              globals.orderList.forEach((element) {
                                                                if (element.dishId == menuList.categoryDishes[i].dishId) {
                                                                  element.qty = menuList.categoryDishes[i].qty;
                                                                  isInCartFlag = true;
                                                                }
                                                              });
                                                            }
                                                            if (!isInCartFlag) {
                                                              globals.orderList.add(menuList.categoryDishes[i]);
                                                            }
                                                          });
                                                        },
                                                        child: Icon(Icons.add, color: Colors.white)),
                                                  ],
                                                ),
                                              ),
                                              (menuList.categoryDishes[i].addonCat != null && menuList.categoryDishes[i].addonCat.isNotEmpty)
                                                  ? Text(
                                                      "Customizations available",
                                                      style: TextStyle(color: Colors.red),
                                                    )
                                                  : Text(""),
                                            ],
                                          )),
                                        );
                                      },
                                    ),
                                  )
                                : Center(
                                    child: Text("Empty data"),
                                  ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: Text("Emplty Data"),
                  ),
                );
        },
      ),
    );
  }
}
