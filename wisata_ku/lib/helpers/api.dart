import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:wisata_ku/helpers/user_info.dart';
import 'app_exception.dart';

class Api {
  Future<dynamic> post(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = {HttpHeaders.authorizationHeader: "Bearer $token"};

      String body;
      // Decide content type based on data shape
      if (data is String) {
        body = data;
        headers[HttpHeaders.contentTypeHeader] = 'text/plain';
      } else if (data is Map<String, String>) {
        body = Uri(queryParameters: data).query; // form encoded
        headers[HttpHeaders.contentTypeHeader] =
            'application/x-www-form-urlencoded';
      } else {
        body = json.encode(data);
        headers[HttpHeaders.contentTypeHeader] = 'application/json';
      }
      // lightweight debug logging to help trace what's sent
      print('API POST -> url: $url');
      print('API POST -> headers: $headers');
      print('API POST -> body: $body');

      final response = await http.post(
        Uri.parse(url),
        body: body,
        headers: headers,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> get(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> delete(dynamic url) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final response = await http.delete(
        Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: "Bearer $token"},
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(dynamic url, dynamic data) async {
    var token = await UserInfo().getToken();
    var responseJson;
    try {
      final headers = {HttpHeaders.authorizationHeader: "Bearer $token"};

      String body;
      if (data is String) {
        body = data;
        headers[HttpHeaders.contentTypeHeader] = 'text/plain';
      } else if (data is Map<String, String>) {
        body = Uri(queryParameters: data).query;
        headers[HttpHeaders.contentTypeHeader] =
            'application/x-www-form-urlencoded';
      } else {
        body = json.encode(data);
        headers[HttpHeaders.contentTypeHeader] = 'application/json';
      }
      final response = await http.put(
        Uri.parse(url),
        body: body,
        headers: headers,
      );
      responseJson = _returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response;
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorisedException(response.body.toString());
      case 422:
        throw InvalidInputException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
          'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
        );
    }
  }
}
