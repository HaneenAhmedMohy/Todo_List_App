import 'package:creiden_task/Entities/todo_item_entity.dart';
import 'package:creiden_task/View/Providers/list_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteItemButton extends StatelessWidget {
  final TodoItem? itemToBeUpdated;
  const DeleteItemButton({super.key, this.itemToBeUpdated});
  void _deleteItem(context) async {
    await Provider.of<ListProvider>(context, listen: false)
        .deleteItem(itemToBeUpdated!.id!);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void showPopUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete item'),
          actions: [
            TextButton(
              onPressed: () {
                _deleteItem(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 100.w,
        height: 50.h,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.red),
        child: MaterialButton(
          onPressed: () => showPopUpDialog(context),
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ));
  }
}
