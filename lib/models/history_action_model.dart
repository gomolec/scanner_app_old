import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:scanner_app/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'history_action_model.g.dart';

@HiveType(typeId: 2)
class HistoryAction extends Equatable {
  @HiveField(0)
  final Product oldProduct;
  @HiveField(1)
  final Product updatedProduct;

  const HistoryAction({
    required this.oldProduct,
    required this.updatedProduct,
  });

  HistoryAction copyWith({
    Product? oldProduct,
    Product? updatedProduct,
  }) {
    return HistoryAction(
      oldProduct: oldProduct ?? this.oldProduct,
      updatedProduct: updatedProduct ?? this.updatedProduct,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'oldProduct': oldProduct.toMap(),
      'updatedProduct': updatedProduct.toMap(),
    };
  }

  factory HistoryAction.fromMap(Map<String, dynamic> map) {
    return HistoryAction(
      oldProduct: Product.fromMap(map['oldProduct']),
      updatedProduct: Product.fromMap(map['updatedProduct']),
    );
  }

  String toJson() => json.encode(toMap());

  factory HistoryAction.fromJson(String source) =>
      HistoryAction.fromMap(json.decode(source));

  @override
  String toString() =>
      'HistoryAction(oldProduct: $oldProduct, updatedProduct: $updatedProduct)';

  @override
  List<Object> get props => [oldProduct, updatedProduct];
}
