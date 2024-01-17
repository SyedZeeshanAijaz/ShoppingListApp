import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shopping_list_app/Constants/constants.dart';

import '../models/grocery_item_model.dart';

class ApiService {
  // Private constructor to prevent instantiation from outside
  final Dio _dio;
  ApiService._privateConstructor(this._dio);
  // The single instance of ApiService
  static ApiService? _instance;

  // Factory constructor to provide access to the instance
  factory ApiService() {
    if (_instance == null) {
      throw Exception("ApiService must be initialized using init method.");
    }
    return _instance!;
  }

  // Initialize ApiService for the first time
  static void init() {
    if (_instance == null) {
      Dio dio = Dio(
        BaseOptions(baseUrl: Constants.apiUrl, contentType: 'application/json'),
      );
      _instance = ApiService._privateConstructor(dio);
    }
  }

  Future<String> saveNewItem(Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post("shopping-list.json", data: data);
      log('${response.data.toString()} saveNewItem');
      return response.data['name'];
    } catch (e) {
      log('Error on SaveNewItem: ${e.toString()}');
      rethrow;
    }
  }

  Future<List<GroceryItem>> getAllItems() async {
    try {
      Response response = await _dio.get('shopping-list.json');
      log(response.data.toString());
      return GroceryItem.listFromJson(response.data);
    } catch (e) {
      log('Error at getting all items: ${e.toString()}');
      rethrow;
    }
  }

  Future<int> deleteItem(String id) async {
    try {
      Response response = await _dio.delete('shopping-list/$id.json');
      return response.statusCode ?? 400;
    } catch (e) {
      log('Delete error: ${e.toString()}');
      return 501;
    }
  }
}
