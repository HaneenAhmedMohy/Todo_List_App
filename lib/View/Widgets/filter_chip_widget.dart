import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterChipList<T> extends StatefulWidget {
  final List<T> options;
  final List<T> selectedOptions;
  final ValueChanged<List<T>> onChanged;
  final Widget Function(T)? optionBuilder;

  const FilterChipList({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onChanged,
    this.optionBuilder,
  }) : super(key: key);

  @override
  FilterChipListState<T> createState() => FilterChipListState<T>();
}

class FilterChipListState<T> extends State<FilterChipList<T>> {
  List<T> selectedOptions = [];

  @override
  void initState() {
    super.initState();
    selectedOptions = widget.selectedOptions;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 4.h,
      children: widget.options.map((option) {
        final isSelected = selectedOptions.contains(option);
        final optionWidget = widget.optionBuilder != null
            ? widget.optionBuilder!(option)
            : Text(option.toString());

        return FilterChip(
          backgroundColor: Colors.white,
          selectedColor: Colors.white,
          label: optionWidget,
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                selectedOptions.add(option);
              } else {
                selectedOptions.remove(option);
              }
              widget.onChanged(selectedOptions);
            });
          },
        );
      }).toList(),
    );
  }
}
