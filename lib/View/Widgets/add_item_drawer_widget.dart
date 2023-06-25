import 'package:creiden_task/Entities/todo_item_entity.dart';
import 'package:creiden_task/View/Providers/list_provider.dart';
import 'package:creiden_task/View/Widgets/common_gradient_button.dart';
import 'package:creiden_task/View/Widgets/common_lable_widget.dart';
import 'package:creiden_task/View/Widgets/delete_item_button.dart';
import 'package:creiden_task/app_constants.dart';
import 'package:creiden_task/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AddItemDrawerWidget extends StatefulWidget {
  final TodoItem? updateItem;
  const AddItemDrawerWidget({Key? key, this.updateItem}) : super(key: key);

  @override
  State<AddItemDrawerWidget> createState() => _AddItemDrawerWidgetState();
}

class _AddItemDrawerWidgetState extends State<AddItemDrawerWidget> {
  Color? selectedColor;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String? selectedStatusValue;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _decriptionFocusNode = FocusNode();
  bool updateView = false;
  TodoItem? itemToBeUpdated;

  @override
  void initState() {
    super.initState();

    setState(() {
      updateView = widget.updateItem != null;
      itemToBeUpdated = widget.updateItem;
    });

    _nameController = TextEditingController();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _nameFocusNode.unfocus();
      }
    });
    _descriptionController = TextEditingController();
    _decriptionFocusNode.addListener(() {
      if (!_decriptionFocusNode.hasFocus) {
        _decriptionFocusNode.unfocus();
      }
    });
    if (itemToBeUpdated != null) {
      selectedColor = itemToBeUpdated!.color;
      _nameController.text = itemToBeUpdated!.name;
      _descriptionController.text = itemToBeUpdated!.description;
      selectedDate = itemToBeUpdated!.date;
      selectedTime = TimeOfDay.fromDateTime(itemToBeUpdated!.date);
      selectedStatusValue = itemToBeUpdated!.status.name;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();

    _nameFocusNode.dispose();
    _decriptionFocusNode.dispose();

    super.dispose();
  }

  void onPressAddItem() async {
    if (_nameController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        selectedColor == null) {
      Provider.of<ListProvider>(context, listen: false).setErrorMessage(true);
    } else {
      await Provider.of<ListProvider>(context, listen: false).addItem(TodoItem(
          color: selectedColor!,
          name: _nameController.text,
          status: TODO_STATUS.values.byName(selectedStatusValue!),
          description: _descriptionController.text,
          date: DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            selectedTime!.hour,
            selectedTime!.minute,
          )));
      Navigator.pop(context);
    }
  }

  void _updateItem() async {
    if (_nameController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null ||
        selectedColor == null ||
        selectedStatusValue == null) {
      Provider.of<ListProvider>(context, listen: false).setErrorMessage(true);
    } else {
      await Provider.of<ListProvider>(context, listen: false)
          .updateItem(TodoItem(
              id: itemToBeUpdated!.id,
              color: selectedColor!,
              name: _nameController.text,
              status: TODO_STATUS.values.byName(selectedStatusValue!),
              description: _descriptionController.text,
              date: DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime!.hour,
                selectedTime!.minute,
              )));
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    FocusScope.of(context).unfocus();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50.0),
            bottomLeft: Radius.circular(50.0),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(updateView ? 'UPDATE TASK' : 'NEW TASK',
                          style: TextStyle(fontSize: 24.sp)),
                      SizedBox(height: 20.h),
                      _buildColorSelectorWidget(),
                      const SizedBox(height: 16),
                      _buildNameTextField(),
                      const SizedBox(height: 16),
                      _buildDescriptionTextField(),
                      const SizedBox(height: 16),
                      _buildStatusSelectionWidget(),
                      const SizedBox(height: 16),
                      _buildDateSelectorWidget(),
                      const SizedBox(height: 16),
                      _buildTimeSelectorWidget(),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Selector<ListProvider, bool>(
                      selector: (_, provider) => provider.showErrorMessage,
                      builder: (_, showErrorMessage, __) {
                        if (showErrorMessage) {
                          return Padding(
                            padding: EdgeInsets.only(top: 30.h),
                            child: Text(
                              'All fields must be filled',
                              style:
                                  TextStyle(color: Colors.red, fontSize: 20.sp),
                            ),
                          );
                        }
                        return Container();
                      }),
                  _buildBottomsView()
                ],
              )
            ],
          ),
        ));
  }

  _buildColorSelectorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Color'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: colorsConstants.map((color) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedColor = color;
                });
              },
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                  border: Border.all(
                    color: selectedColor == color ||
                            selectedColor?.value == color.value
                        ? Colors.black
                        : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  _buildNameTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Name'),
        TextField(
          controller: _nameController,
          focusNode: _nameFocusNode,
          decoration: InputDecoration(
            hintText: 'Enter name',
            hintStyle: const TextStyle(color: Colors.grey),
            contentPadding:
                EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          ),
        ),
      ],
    );
  }

  _buildDescriptionTextField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Description'),
        TextField(
          maxLines: null,
          controller: _descriptionController,
          focusNode: _decriptionFocusNode,
          minLines: 5,
          decoration: InputDecoration(
            filled: true,
            hintText: "Enter description",
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black38, width: 2)),
          ),
        ),
      ],
    );
  }

  _buildDateSelectorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Date'),
        InkWell(
          onTap: () => _selectDate(context),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.arrow_drop_down),
              hintText: selectedDate != null
                  ? '${selectedDate?.day}/${selectedDate?.month}/${selectedDate?.year}'
                  : 'Not selected',
              hintStyle: const TextStyle(color: Colors.black54),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  _buildTimeSelectorWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Time'),
        InkWell(
          onTap: () => _selectTime(context),
          child: TextField(
            enabled: false,
            decoration: InputDecoration(
              suffixIcon: const Icon(Icons.arrow_drop_down),
              hintText: selectedTime != null
                  ? selectedTime?.format(context)
                  : 'Not selected',
              hintStyle: const TextStyle(color: Colors.black54),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }

  _buildStatusSelectionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Status'),
        DropdownButtonFormField<String>(
          value: selectedStatusValue,
          items: [
            DropdownMenuItem(
              value: TODO_STATUS.NOT_STARTED.name,
              child: Text(getEnumNameString(TODO_STATUS.NOT_STARTED)),
            ),
            DropdownMenuItem(
              value: TODO_STATUS.IN_PROGRESS.name,
              child: Text(getEnumNameString(TODO_STATUS.IN_PROGRESS)),
            ),
            DropdownMenuItem(
              value: TODO_STATUS.COMPLETED.name,
              child: Text(getEnumNameString(TODO_STATUS.COMPLETED)),
            ),
          ],
          onChanged: (value) {
            setState(() {
              selectedStatusValue = value!;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Select a value',
            border: OutlineInputBorder(),
          ),
        )
      ],
    );
  }

  _buildBottomsView() {
    if (updateView) {
      return Padding(
        padding: EdgeInsets.only(bottom: 32.h, top: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DeleteItemButton(itemToBeUpdated: itemToBeUpdated),
            CommonGradientButtonWidget(
              onPressFunction: () => _updateItem(),
              title: 'Update',
              width: 100,
              radius: 50,
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(bottom: 32.h, top: 8.h),
        child: CommonGradientButtonWidget(
          onPressFunction: () => onPressAddItem(),
          title: 'Add',
          width: 150,
          radius: 50,
        ),
      );
    }
  }
}
