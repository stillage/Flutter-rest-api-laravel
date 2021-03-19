import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kegiatanapp/models/todomodel.dart';
import 'package:kegiatanapp/models/usermodel.dart';
import 'dart:convert';

class TodoController extends ChangeNotifier {
  List<Todo> _data = [];
  List<Todo> get dataTodo => _data;

  Future<List<Todo>> getTodo() async {
    final url = 'http://powerful-falls-43038.herokuapp.com/api/post';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final result =
          json.decode(response.body)['data'].cast<Map<String, dynamic>>();
      _data = result.map<Todo>((json) => Todo.fromJson(json)).toList();
      return _data;
    } else {
      throw Exception();
    }
  }
}
