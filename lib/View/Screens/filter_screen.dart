import 'package:creiden_task/View/Providers/list_provider.dart';
import 'package:creiden_task/View/Widgets/common_gradient_button.dart';
import 'package:creiden_task/View/Widgets/common_lable_widget.dart';
import 'package:creiden_task/View/Widgets/filter_chip_widget.dart';
import 'package:creiden_task/app_assets.dart';
import 'package:creiden_task/app_constants.dart';
import 'package:creiden_task/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

  @override
  FilterScreenState createState() => FilterScreenState();
}

class FilterScreenState extends State<FilterScreen> {
  List<String> selectedStatus = [];
  List<Color> selectedColors = [];
  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();

    setState(() {
      selectedStatus =
          Provider.of<ListProvider>(context, listen: false).selectedStatus;
      selectedColors =
          Provider.of<ListProvider>(context, listen: false).selectedColors;
      fromDate = Provider.of<ListProvider>(context, listen: false).fromDate;
      toDate = Provider.of<ListProvider>(context, listen: false).toDate;
    });
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        fromDate = selectedDate;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: toDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        toDate = selectedDate;
      });
    }
  }

  onPressApplyFilter() {
    Provider.of<ListProvider>(context, listen: false).applyFilter(
        selectedColors: selectedColors,
        selectedStatus: selectedStatus,
        fromDate: fromDate,
        toDate: toDate);
    Navigator.pop(context);
  }

  onPressClearFilters() {
    Provider.of<ListProvider>(context, listen: false).clearFilters();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppAssets.main_background_image),
                  fit: BoxFit.cover)),
          child: _buildBody()),
    );
  }

  _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight + 12.h),
            child: Text(
              'Filter',
              style: TextStyle(fontSize: 20.sp),
            ),
          ),
        ),
        SizedBox(height: 40.h),
        SizedBox(
          height: 650.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusFilterSection(),
                  _buildColorFilterSection(),
                  _buildStartDateFilterSection(),
                  _buildEndDateFilterSection(),
                ],
              ),
              Column(
                children: [
                  CommonGradientButtonWidget(
                      onPressFunction: () => onPressApplyFilter(),
                      radius: 50,
                      width: 350,
                      title: 'Apply Filter'),
                  SizedBox(height: 16.h),
                  InkWell(
                    onTap: () => onPressClearFilters(),
                    child: Text(
                      'Clear Filter',
                      style: TextStyle(fontSize: 12.sp, color: Colors.blue),
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      ]),
    );
  }

  _buildStatusFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Status'),
        Wrap(
          children: [
            FilterChipList(
              options: [
                getEnumNameString(TODO_STATUS.NOT_STARTED),
                getEnumNameString(TODO_STATUS.IN_PROGRESS),
                getEnumNameString(TODO_STATUS.COMPLETED)
              ],
              selectedOptions: selectedStatus,
              onChanged: (selectedOptions) {
                setState(() {
                  selectedStatus = selectedOptions;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  _buildColorFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Color'),
        Wrap(
          children: [
            FilterChipList(
              options: colorsConstants,
              selectedOptions: selectedColors,
              onChanged: (selectedOptions) {
                setState(() {
                  selectedColors = selectedOptions;
                });
              },
              optionBuilder: (color) => Container(
                width: 25.0,
                height: 25.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  _buildStartDateFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Select From Date'),
        TextButton(
          onPressed: () => _selectFromDate(context),
          child: Text(
            fromDate != null
                ? 'From: ${DateFormat('dd/MM/yyyy').format(fromDate!)}'
                : 'Select From Date',
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }

  _buildEndDateFilterSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CommonLabelWidget(title: 'Select To Date'),
        TextButton(
          onPressed: () => _selectToDate(context),
          child: Text(
            toDate != null
                ? 'To: ${DateFormat('dd/MM/yyyy').format(toDate!)}'
                : 'Select To Date',
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
