

import 'package:ecom/resturant/resturant_screen_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data_classes.dart';

class RestaurantListPage extends StatefulWidget {
  RestaurantListPage({Key key}) : super(key: key);

  @override
  _RestaurantListPageState createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  RestaurantBloc _bloc = RestaurantBloc();

  List<Restaurant> _restaurantList = new List();
  TableMenuList firstMenu= new TableMenuList();

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
        if (state is RestaurantLoadingState) {

        } else if (state is RestaurantLoadErrorState) {

        } else if (state is RestaurantLoadedState) {
          _restaurantList.addAll(state.restaurantList.restaurantList);
          _tempRestaurantList.addAll(state.restaurantList.restaurantList);
firstMenu=state.restaurantList.restaurantList.first.tableMenuList.first;
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, RestaurantScreenState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text("List"),
            ),
            body: Column(
              children: <Widget>[

                Expanded(
                  child: (null != firstMenu.categoryDishes && firstMenu.categoryDishes.isNotEmpty)
                      ? ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: firstMenu.categoryDishes.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                        child: InkWell(
                          onTap: () {
//                            Navigator.push(context, new MaterialPageRoute(builder: (context) => new DetailScreenPage(restaurant: _tempRestaurantList[i])));
                          },
                          child: Card(
                            child: (Container(
                              height: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  (null != firstMenu.categoryDishes[i] && null != firstMenu.categoryDishes[i].dishImage)
                                      ? Container(
                                    width: 55.0,
                                    height: 55.0,
                                    decoration: new BoxDecoration(
                                      borderRadius: BorderRadius.circular(55),
                                      color: Colors.transparent,
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
                                    child: Center(child: Text(firstMenu.categoryDishes[i]?.dishImage?.substring(0, 1) ?? "A")),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(firstMenu.categoryDishes[i]?.dishName ?? "name"),
                                      Text(firstMenu.categoryDishes[i]?.dishPrice ?? "user name"),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                          ),
                        ),
                      );
                    },
                  )
                      : Center(
                    child: Text("Empty data"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
