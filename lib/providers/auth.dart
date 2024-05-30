import 'dart:async';
import 'dart:convert' as converter;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';
import '../method/sheradPrefefrancesManger.dart';
import '../models/User.dart';

class Auth extends ChangeNotifier {
  bool _authenticated = false;
  User? _user;
  String? _errorMessage;
  User? get user => _user;
  bool get authenticated => _authenticated;
  String? get errorMessge => _errorMessage;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  void resetErrorMessage() {
    _errorMessage = null;
  }

  Future register({name, email, password}) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/auth/register');
    try {
      var response = await http.post(url, body: {
        'name': '$name',
        'email': '$email',
        'password': '$password',
        'device_name': 'AuthToken'
      });
      if (response.statusCode == 200) {
        print(response.statusCode);
        var body = await converter.jsonDecode(response.body);
        String token = body['token'];
        await attempt(token);
        await storToken(token);
      } else {
        var body = await converter.jsonDecode(response.body);
        Map<String, dynamic> message = body['message'];
        List<dynamic> errors = message['email'];
        _errorMessage = errors[0];
        log(response.body);
      }
    } catch (e) {
      log('error logg ${e.toString()}');
      throw Exception('An Unxpected Error Occurred');
    }
  }

  Future login({email, password}) async {
    var url = Uri.parse('http://127.0.0.1:8000/api/auth/login');
    try {
      var response = await http.post(url, body: {
        'email': '$email',
        'password': '$password',
        'device_name': 'AuthToken'
      });
      if (response.statusCode == 200) {
        var body = await converter.jsonDecode(response.body);
        String token = body['token'];
        await attempt(token);
        await storToken(token);
      } else {
        var body = await converter.jsonDecode(response.body);
        _errorMessage = body['message'];
        log(response.body);
      }
    } catch (e) {
      log('error log ${e.toString()}');
      throw Exception('An Unxpected Error Occurred');
    }
  }

  Future logout() async {
    _isLoading = true;
    notifyListeners();
    var url = Uri.parse('http://127.0.0.1:8000/api/auth/logout');
    String token = await getToken();
    _authenticated = false;
    await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    });
    await deleteToken();
    _isLoading = false;
    notifyListeners();
  }

  Future attempt(String? token) async {
    _isLoading = true;
    notifyListeners();
    var url = Uri.parse('http://127.0.0.1:8000/api/auth/user');
    try {
      var response =
          await http.get(url, headers: {'Authorization': 'Bearer $token'});
      if (response.statusCode == 200) {
        var data = await converter.jsonDecode(response.body);
        _user = User.fromJson(data);
        _authenticated = true;
      } else {
        _authenticated = false;
      }
    } catch (e) {
      log('error log ${e.toString()}');
      _authenticated = false;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future storToken(token) async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    prfs.setString('auth', token);
  }

  Future getToken() async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    return prfs.getString('auth');
  }

  Future deleteToken() async {
    SharedPreferences prfs = await SharedPreferencesManager.getInstance();
    prfs.clear();
  }
}
