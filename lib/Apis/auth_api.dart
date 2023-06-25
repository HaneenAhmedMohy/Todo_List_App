import 'dart:async';

import 'package:creiden_task/Apis/urls_generators.dart';
import 'package:creiden_task/Controllers/auth_controller.dart';
import 'package:creiden_task/Helpers/auth_helper.dart';
import 'package:dio/dio.dart';

class AuthApi {
  final Dio _dio = Dio();

  Future<bool> loginUser({String? email, String? password}) async {
    try {
      final response = await _dio.post(
        UrlGenerators.LOGIN_API,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        AuthController()
            .saveUserID(response.data['data']['user']['id'].toString());
        final savedToken = await AuthHelper.getToken();
        if (savedToken != token) {
          AuthHelper.saveToken(token);
        }
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }

  Future<String> refreshToken() async {
    final savedToken = await AuthHelper.getToken();
    try {
      final response = await _dio
          .post(UrlGenerators.REFRESH_TOKEN_API, data: {'token': savedToken});
      if (response.statusCode == 200) {
        final token = response.data['data']['token'];
        final savedToken = await AuthHelper.getToken();
        if (savedToken != token) {
          AuthHelper.saveToken(token);
        }
        return savedToken;
      } else {
        return '';
      }
    } catch (error) {
      return '';
    }
  }
}
