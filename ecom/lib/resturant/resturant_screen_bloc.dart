import 'dart:async';
import 'package:ecom/utils/api.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import 'data_classes.dart';

class RestaurantBloc extends Bloc<RestaurantScreenEvent, RestaurantScreenState> {
  @override
  RestaurantScreenState get initialState => InitialRestaurantScreenState();

  @override
  Stream<RestaurantScreenState> mapEventToState(RestaurantScreenEvent event) async* {
    if (event is LoadRestaurantEvent) {
      try {
        yield RestaurantLoadingState();
        RestaurantList listOfRestaurant = new RestaurantList();
        listOfRestaurant = await API().getListFromServer();///API CALL Starts and wait for the response
        yield RestaurantLoadedState(listOfRestaurant);
      } catch (e) {
        print(e);
        await Future.delayed(Duration(milliseconds: 1000));
        yield RestaurantLoadErrorState(errorMessage(e.toString()));
      }
    }
  }
}

@immutable
abstract class RestaurantScreenEvent {}

class LoadRestaurantEvent extends RestaurantScreenEvent {
  LoadRestaurantEvent();
}

@immutable
abstract class RestaurantScreenState {}

class InitialRestaurantScreenState extends RestaurantScreenState {}

class RestaurantLoadingState extends RestaurantScreenState {}

class RestaurantLoadedState extends RestaurantScreenState {
  final RestaurantList restaurantList;

  RestaurantLoadedState(this.restaurantList);
}

class RestaurantLoadErrorState extends RestaurantScreenState {
  final String errorMessage;

  RestaurantLoadErrorState(this.errorMessage);
}
