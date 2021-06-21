import 'package:flutter_trip/model/home_model.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

const HomeURL = 'https://www.devio.org/io/flutter_app/json/home_page.json';

class HomeDao {
  static Future<HomeModel> fetch() async {
    final url = Uri.parse(HomeURL);
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //fixed 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    } else {
      throw Exception('加载 Home 数据时报');
    }
  }
}
