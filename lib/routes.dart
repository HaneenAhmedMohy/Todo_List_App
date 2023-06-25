import 'package:creiden_task/View/Screens/filter_screen.dart';
import 'package:creiden_task/View/Screens/list_screen.dart';
import 'package:creiden_task/View/Screens/login_screen.dart';
import 'package:flutter/material.dart';

class Routes {
  static const loginScreen = '/loginScreen';
  static const listScreen = '/listScreen';
  static const filterScreen = '/filterScreen';

  static MaterialPageRoute? onGenerateRoute(RouteSettings settings) {
    var routes = <String, WidgetBuilder>{
      loginScreen: (context) => const LoginScreen(),
      listScreen: (context) => const TodoListScreen(),
      filterScreen: (context) => const FilterScreen()
    };
    WidgetBuilder? builder = routes[settings.name!];
    if (builder == null) {
      return null;
    }
    return MaterialPageRoute(builder: (context) => builder(context));
  }

  static void navigateToScreen(String? screenName, String navigateType,
      dynamic arguments, BuildContext? context) async {
    switch (navigateType) {
      case NavigateType.PUSH_NAMED:
        Navigator.of(context!).pushNamed(screenName!, arguments: arguments);
        break;
      case NavigateType.PUSH_REPLACEMENT_NAMED:
        Navigator.of(context!)
            .pushReplacementNamed(screenName!, arguments: arguments);

        break;
      case NavigateType.POP:
        Navigator.of(context!).pop();
        break;

      default:
        break;
    }
  }
}

class NavigateType {
  static const PUSH_NAMED = 'pushNamed';
  static const POP = 'pop';
  static const PUSH_REPLACEMENT_NAMED = 'pushReplacementNamed';
}
