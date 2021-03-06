import 'package:flutter_trip/model/common_model.dart';

class GridNavModel {
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    return GridNavModel(
        hotel: GridNavItem.fromJson(json['hotel']),
        flight: GridNavItem.fromJson(json['flight']),
        travel: GridNavItem.fromJson(json['travel']));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hotel'] = hotel.toJson();
    data['flight'] = flight.toJson();
    data['travel'] = travel.toJson();
    return data;
  }
}

class GridNavItem {
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItem(
      {this.startColor,
      this.endColor,
      this.mainItem,
      this.item1,
      this.item2,
      this.item3,
      this.item4});

  factory GridNavItem.fromJson(Map<String, dynamic> json) {
    return GridNavItem(
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem: CommonModel.fromJson(json['mainItem']),
      item1: CommonModel.fromJson(json['mainItem']),
      item2: CommonModel.fromJson(json['mainItem']),
      item3: CommonModel.fromJson(json['mainItem']),
      item4: CommonModel.fromJson(json['mainItem']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startColor'] = startColor;
    data['endColor'] = endColor;
    data['mainItem'] = mainItem.toJson();
    data['item1'] = item1.toJson();
    data['item2'] = item2.toJson();
    data['item3'] = item3.toJson();
    data['item4'] = item4.toJson();
    return data;
  }
}
