import 'dart:async';

import 'package:creiden_task/Apis/auth_api.dart';
import 'package:creiden_task/Helpers/auth_helper.dart';
import 'package:creiden_task/View/Providers/auth_provider.dart';
import 'package:creiden_task/View/Providers/list_provider.dart';
import 'package:creiden_task/View/Screens/landing_screen.dart';
import 'package:creiden_task/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    // init timeZone
    tz.initializeTimeZones();

    //Refresh token automatically logic
    final dio = Dio();
    var token = await AuthHelper.getToken();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['Authorization'] = 'Bearer $token';
          return handler.next(options);
        },
        onError: (DioError e, handler) async {
          if (e.response?.statusCode == 401) {
            String newAccessToken = await AuthApi().refreshToken();
            e.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            return handler.resolve(await dio.fetch(e.requestOptions));
          }
          return handler.next(e);
        },
      ),
    );

    // Local Notifications setup
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    // print('ERROR $error');
    // log errors
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ListProvider()),
      ],
      child: MaterialApp(
        title: 'TODO List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: (ctx, child) {
          ScreenUtil.init(ctx, designSize: const Size(375, 812));
          return MediaQuery(
            data: MediaQuery.of(ctx).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        home: const LandingScreen(),
        onGenerateRoute: Routes.onGenerateRoute,
      ),
    );
  }
}
