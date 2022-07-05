import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

const String _baseUrl = 'https://external.whooonewstack.com/appcaletas/wp-json/wp/v2/';

class Apis{
  Future<String> getRegions() async {
    final response =
    await http.get(Uri.parse(_baseUrl + "categories?per_page=100")).timeout(Duration(seconds: 10));
    return response.body;
  }
  Future<String> getPosts(int id) async {
    final response =
    await http.get(Uri.parse(_baseUrl + "posts?categories=$id")).timeout(Duration(seconds: 10));
    return response.body;
  }
  Future<String> getPostsall() async {
    try {
      final response =
      await http.get(Uri.parse(_baseUrl + "posts?per_page=100")).timeout(Duration(seconds: 10));
      return response.body;
    }on SocketException{
      return "";
    }on TimeoutException{
      return "";
    }
  }
}