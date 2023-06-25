import 'package:creiden_task/Entities/todo_item_entity.dart';
import 'package:creiden_task/View/Providers/list_provider.dart';
import 'package:creiden_task/View/Widgets/add_item_drawer_widget.dart';
import 'package:creiden_task/View/Widgets/gardient_floating_button.dart';
import 'package:creiden_task/View/Widgets/signout_button_widget.dart';
import 'package:creiden_task/app_assets.dart';
import 'package:creiden_task/enums.dart';
import 'package:creiden_task/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});
  final bool? isLoading = true;

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  TodoItem? updateItem;
  bool isLoading = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchTodoItems().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
    super.initState();
  }

  Future<void> _fetchTodoItems() async {
    await Provider.of<ListProvider>(context, listen: false).getTodoList();
  }

  onPressEditIcon(TodoItem item, context) {
    setState(() {
      updateItem = item;
    });
    Provider.of<ListProvider>(context, listen: false).setErrorMessage(false);
    Scaffold.of(context).openEndDrawer();
  }

  onPressAddButton(context) {
    setState(() {
      updateItem = null;
    });
    Provider.of<ListProvider>(context, listen: false).setErrorMessage(false);
    Scaffold.of(context).openEndDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      endDrawer: AddItemDrawerWidget(updateItem: updateItem),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.main_background_image),
                fit: BoxFit.cover)),
        child: Column(children: [
          _buildHeader(),
          Builder(
            builder: (BuildContext context) {
              return _buildTodosList(context);
            },
          ),
        ]),
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return GradientFloatingButton(
              onPressed: () => onPressAddButton(context));
        },
      ),
    );
  }

  _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenUtil().statusBarHeight + 12.h),
      child: SizedBox(
        width: double.infinity,
        height: 50.h,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SignoutButtonWidget(),
              Center(
                child: Text(
                  'TODO',
                  style: TextStyle(fontSize: 20.sp),
                ),
              ),
              InkWell(
                onTap: () => Routes.navigateToScreen(
                    Routes.filterScreen, NavigateType.PUSH_NAMED, {}, context),
                child: const Icon(
                  Icons.filter_list_sharp,
                  color: Colors.pink,
                  size: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildTodosList(parentContext) {
    return Selector<ListProvider, List<TodoItem>>(
        selector: (_, provider) => provider.todoList,
        builder: (_, data, __) {
          if (isLoading) {
            return SizedBox(
                height: 50.h,
                width: 50.w,
                child: const CircularProgressIndicator());
          } else {
            if (data.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 50.h),
                child: Text(
                  'No Todos Found',
                  style: TextStyle(fontSize: 20.sp, color: Colors.black54),
                ),
              );
            }
            return SizedBox(
              height: 700.h,
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final todoItem = data[index];

                  return _buildListItem(parentContext, todoItem: todoItem);
                },
              ),
            );
          }
        });
  }

  _buildListItem(context, {required TodoItem todoItem}) {
    DateFormat format = DateFormat("dd MMM");
    var todoDateString = format.format(todoItem.date);
    DateFormat formatTime = DateFormat("HH:mm");
    var todoTimeString = formatTime.format(todoItem.date);
    return InkWell(
      onTap: () => onPressEditIcon(todoItem, context),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Container(
          height: 80.h,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(8)),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                        height: 20.h,
                        width: 20.w,
                        decoration: BoxDecoration(
                            color: todoItem.color,
                            borderRadius: BorderRadius.circular(10))),
                    SizedBox(
                      width: 8.w,
                    ),
                    SizedBox(
                      width: 200.w,
                      child: Text(
                        '${getEnumNameString(todoItem.status)}: ${todoItem.name}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          todoDateString,
                          style: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          todoTimeString,
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    Center(
                      child: InkWell(
                        onTap: () => onPressEditIcon(todoItem, context),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
