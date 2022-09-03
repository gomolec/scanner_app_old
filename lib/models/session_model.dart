import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'history_action_model.dart';
import 'product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'session_model.g.dart';

@HiveType(typeId: 3)
class Session extends Equatable {
  @HiveField(0)
  final DateTime startTime;
  @HiveField(1)
  final DateTime? endTime;
  @HiveField(2)
  final List<Product> savedProducts;
  @HiveField(3)
  final List<HistoryAction> savedHistory;
  @HiveField(4)
  final List<HistoryAction> savedUndoHistory;

  const Session({
    required this.startTime,
    this.endTime,
    required this.savedProducts,
    required this.savedHistory,
    required this.savedUndoHistory,
  });

  Session copyWith({
    DateTime? startTime,
    DateTime? endTime,
    List<Product>? savedProducts,
    List<HistoryAction>? savedHistory,
    List<HistoryAction>? savedUndoHistory,
  }) {
    return Session(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      savedProducts: savedProducts ?? this.savedProducts,
      savedHistory: savedHistory ?? this.savedHistory,
      savedUndoHistory: savedUndoHistory ?? this.savedUndoHistory,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startTime': startTime.millisecondsSinceEpoch,
      'endTime': endTime?.millisecondsSinceEpoch,
      'savedProducts': savedProducts.map((x) => x.toMap()).toList(),
      'savedHistory': savedHistory.map((x) => x.toMap()).toList(),
      'savedUndoHistory': savedUndoHistory.map((x) => x.toMap()).toList(),
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      startTime: DateTime.fromMillisecondsSinceEpoch(map['startTime']),
      endTime: map['endTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['endTime'])
          : null,
      savedProducts: List<Product>.from(
          map['savedProducts']?.map((x) => Product.fromMap(x))),
      savedHistory: List<HistoryAction>.from(
          map['savedHistory']?.map((x) => HistoryAction.fromMap(x))),
      savedUndoHistory: List<HistoryAction>.from(
          map['savedUndoHistory']?.map((x) => HistoryAction.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) =>
      Session.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Session(startTime: $startTime, endTime: $endTime, savedProducts: $savedProducts, savedHistory: $savedHistory, savedUndoHistory: $savedUndoHistory)';
  }

  @override
  List<Object?> get props {
    return [
      startTime,
      endTime,
      savedProducts,
      savedHistory,
      savedUndoHistory,
    ];
  }
}
