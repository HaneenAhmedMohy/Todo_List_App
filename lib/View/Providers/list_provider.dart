import 'package:creiden_task/Controllers/notification_controller.dart';
import 'package:creiden_task/Entities/todo_item_entity.dart';
import 'package:creiden_task/Controllers/todo_storage_controller.dart';
import 'package:creiden_task/enums.dart';
import 'package:creiden_task/utils.dart';
import 'package:flutter/material.dart';

class ListProvider with ChangeNotifier {
  TodoStorageController todoProvider = TodoStorageController();

  // STATES
  List<TodoItem> todoList = [];

  bool showErrorMessage = false;

  List<String> selectedStatus = [];
  List<Color> selectedColors = [];
  DateTime? fromDate;
  DateTime? toDate;

  Future<void> getTodoList() async {
    final todoItems = await todoProvider.fetchTodoItems();
    todoList = todoItems;
    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await todoProvider.deleteTodoItem(id);
    await getTodoList();
    await NotificationController().deleteScheduledNotification(id);
  }

  Future<void> addItem(TodoItem item) async {
    setErrorMessage(false);
    notifyListeners();
    final newItem = TodoItem(
      id: AppUtils().generateUniqueId(),
      color: item.color,
      name: item.name,
      status: item.status,
      description: item.description,
      date: item.date,
    );
    await todoProvider.addTodoItem(newItem);
    await getTodoList();
    await NotificationController().scheduleNotification(item: newItem);
  }

  Future<void> updateItem(TodoItem todoItem) async {
    await todoProvider.updateTodoItem(todoItem);
    await getTodoList();
    await NotificationController().updateNotification(item: todoItem);
  }

  void setErrorMessage(bool value) {
    showErrorMessage = value;
    notifyListeners();
  }

  void setStatusFilterValues(List<String> values) {
    selectedStatus = values;
  }

  void setColorsFilterValues(List<Color> values) {
    selectedColors = values;
  }

  void setStartDateFilterValues(DateTime? value) {
    fromDate = value;
  }

  void setToDateFilterValues(DateTime? value) {
    toDate = value;
  }

  void applyFilter(
      {List<String>? selectedStatus,
      List<Color>? selectedColors,
      DateTime? fromDate,
      DateTime? toDate}) async {
    final todoItems = await todoProvider.fetchTodoItems();

    List<TODO_STATUS> selectedStatusEnums = [];
    List<Color> selectedColorsValues = [];
    for (var i = 0; i < selectedStatus!.length; i++) {
      selectedStatusEnums.add(getEnumValueFromString(selectedStatus[i]));
    }
    for (var i = 0; i < selectedColors!.length; i++) {
      selectedColorsValues.add(Color(selectedColors[i].value));
    }
    setColorsFilterValues(selectedColors);
    setStatusFilterValues(selectedStatus);
    setStartDateFilterValues(fromDate);
    setToDateFilterValues(toDate);

    // Filter the todo list based on the selected criteria

    List<TodoItem> filteredList = todoItems.where((todo) {
      // Filter by status
      if (selectedStatusEnums.isNotEmpty &&
          !selectedStatusEnums.contains(todo.status)) {
        return false;
      }

      // Filter by color
      if (selectedColorsValues.isNotEmpty &&
          !selectedColorsValues.contains(todo.color)) {
        return false;
      }

      // Filter by date range
      if (fromDate != null && todo.date.isBefore(fromDate)) {
        return false;
      }

      if (toDate != null && todo.date.isAfter(toDate)) {
        return false;
      }

      // All filter criteria matched, include the todo item in the filtered list
      return true;
    }).toList();

    // Update the displayed todos with the filtered list
    todoList = filteredList;
    notifyListeners();
  }

  void clearFilters() {
    applyFilter(
        selectedColors: [], selectedStatus: [], fromDate: null, toDate: null);
  }
}
