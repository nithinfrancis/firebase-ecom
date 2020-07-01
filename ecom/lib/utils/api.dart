import "dart:async";
import "dart:convert";
import "dart:io";



import 'package:ecom/resturant/data_classes.dart';

import 'network_manager.dart';
class API {
  NetworkManager _networkManager = new NetworkManager();

  static final String apiUrl = "https://www.mocky.io/v2/5dfccffc310000efc8d2c1ad";

  Future<RestaurantList> getListFromServer() async {
    try {
      var headers = Map<String, String>();
      headers["Content-Type"] = "application/json";

      ParsedResponse result = await _networkManager.post(apiUrl, headers: headers);
      print("pwoliiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii");
      print(result?.response ?? "NULL RESPONSE");
      if (result?.isOk() ?? false) {
        final modelClassResponse = RestaurantList.fromJsonMap(json.decode(result.response));
        return modelClassResponse;
      } else if (result?.response?.isNotEmpty ?? false) {
        final errorApiResponse = ErrorApiResponse.fromJson(json.decode(result.response));
        if (errorApiResponse?.error?.message?.isNotEmpty ?? false) {
          throw Exception(errorApiResponse.error.message);
        } else {
          throw Exception();
        }
      } else {
        throw Exception("Unexpected error in Report API [${result?.code ?? "null"}]");
      }
    } catch (e) {
      //print(e);
      throwProperException(e);
      return null;
    }
  }


}


void throwProperException(e) {
  if (e is SocketException) {
    throw Exception("Unable to communicate with server at the moment");
  } else if (e is TimeoutException) {
    throw Exception(("Unable to communicate with server at the moment"));
  } else if (e is FormatException) {
    throw Exception(("Invalid File Format"));
  } else {
    throw e;
  }
}

class ParsedResponse {
  dynamic code;
  String response;

  ParsedResponse(this.code, this.response);

  bool isOk() {
    return code == 200;
  }
}

class ParsedStringResponse {
  String code;
  String response;

  ParsedStringResponse(this.code, this.response);

  bool isOk() {
    return code == "Success";
  }
}

class ErrorApiResponse {
  Error error;

  ErrorApiResponse({this.error});

  factory ErrorApiResponse.fromJson(Map<String, dynamic> json) {
    return ErrorApiResponse(
      error: json["error"] != null ? Error.fromJson(json["error"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.error != null) {
      data["error"] = this.error.toJson();
    }
    return data;
  }
}

class Error {
  double code;
  String key;
  String message;

  Error({this.code, this.key, this.message});

  factory Error.fromJson(Map<String, dynamic> json) {
    return Error(
      code: json["code"],
      key: json["key"],
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    data["key"] = this.key;
    data["message"] = this.message;
    return data;
  }
}

errorMessage(String message) {
  if (message?.isEmpty ?? true) {
    message = "Something went wrong";
  } else if (message.contains("Exception:")) {
    message = message.replaceFirst("Exception:", "");
  }
  return message;
}