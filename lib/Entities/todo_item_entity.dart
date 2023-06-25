import 'package:creiden_task/enums.dart';
import 'package:flutter/material.dart';

class TodoItem {
  int? id;
  Color color;
  String name;
  TODO_STATUS status;
  String description;
  DateTime date;

  TodoItem({
    this.id,
    required this.color,
    required this.name,
    required this.status,
    required this.description,
    required this.date,
  });
  factory TodoItem.fromJson(Map<String, dynamic> json) {
    TodoItem todoItem = TodoItem(
      id: json['id'],
      color: Color(json['color']),
      name: json['name'],
      status: TODO_STATUS.values.byName(json['status']),
      description: json['description'],
      date: DateTime.parse(json['date']),
    );
    return todoItem;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'color': color.value,
      'name': name,
      'status': status.name,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'TodoItem(id: $id, color: $color, status: $status, name :$name,  description: $description, date: $date,';
  }
}
