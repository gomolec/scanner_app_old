import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:equatable/equatable.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class Product extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String code;
  @HiveField(2)
  final int delivered;
  @HiveField(3)
  final int stock;
  @HiveField(4)
  final bool isFlagged;

  const Product({
    required this.name,
    required this.code,
    required this.delivered,
    this.stock = 0,
    this.isFlagged = false,
  });

  Product copyWith({
    String? name,
    String? code,
    int? delivered,
    int? stock,
    bool? isFlagged,
  }) {
    return Product(
      name: name ?? this.name,
      code: code ?? this.code,
      delivered: delivered ?? this.delivered,
      stock: stock ?? this.stock,
      isFlagged: isFlagged ?? this.isFlagged,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'delivered': delivered,
      'stock': stock,
      'isFlagged': isFlagged,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      delivered: map['delivered']?.toInt() ?? 0,
      stock: map['stock']?.toInt() ?? 0,
      isFlagged: map['isFlagged'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(name: $name, code: $code, delivered: $delivered, stock: $stock, isFlagged: $isFlagged)';
  }

  @override
  List<Object> get props {
    return [
      name,
      code,
      delivered,
      stock,
      isFlagged,
    ];
  }
}
