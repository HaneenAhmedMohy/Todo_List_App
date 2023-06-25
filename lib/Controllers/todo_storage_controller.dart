import 'dart:convert';
import 'package:creiden_task/Entities/todo_item_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoStorageController {
  static const String _storageKey = 'todo_items';

  Future<List<TodoItem>> fetchTodoItems() async {
    final prefs = await SharedPreferences.getInstance();
    final todoData = prefs.getString(_storageKey);
    if (todoData != null) {
      final List<dynamic> decodedData = jsonDecode(todoData);

      final todoItems =
          decodedData.map((item) => TodoItem.fromJson(item)).toList();

      return todoItems;
    } else {
      return [];
    }
  }

  Future<void> saveTodoItems(List<TodoItem> todoItems) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = json.encode(todoItems);
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> addTodoItem(TodoItem todoItem) async {
    final todoItems = await fetchTodoItems();
    todoItems.add(todoItem);
    await saveTodoItems(todoItems);
  }

  Future<void> updateTodoItem(TodoItem updatedTodoItem) async {
    final todoItems = await fetchTodoItems();
    final index = todoItems.indexWhere((item) => item.id == updatedTodoItem.id);

    if (index != -1) {
      todoItems[index] = updatedTodoItem;
      await saveTodoItems(todoItems);
    }
  }

  Future<void> deleteTodoItem(int id) async {
    final todoItems = await fetchTodoItems();
    todoItems.removeWhere((item) => item.id == id);
    await saveTodoItems(todoItems);
  }

  Future<void> deleteAllTodosItem() async {
    final todoItems = await fetchTodoItems();
    todoItems.clear();
    await saveTodoItems(todoItems);
  }
}
