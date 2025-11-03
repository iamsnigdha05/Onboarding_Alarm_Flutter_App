import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/alarm.dart';
import '../models/alarm.dart';
import '../services/notification_service.dart';

class AlarmProvider with ChangeNotifier {
  List<Alarm> _alarms = [];
  List<Alarm> get alarms => _alarms;
  Future<void> addAlarm(Alarm a) async {
    _alarms.add(a);
    await NotificationService().scheduleNotification(a);
    await _saveToStorage();
    notifyListeners();
  }
  Future<void> removeAlarm(int id) async {
    _alarms.removeWhere((x) => x.id == id);
    await NotificationService().cancelNotification(id);
    await _saveToStorage();
    notifyListeners();
  }
  Future<void> scheduleNotificationForAlarm(Alarm a) async {
    await NotificationService().scheduleNotification(a);
  }


  Future<void> _saveToStorage() async {
    final sp = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_alarms.map((e) => e.toJson()).toList());
    await sp.setString('alarms', encoded);
  }

  Future<void> loadFromStorage() async {
    final sp = await SharedPreferences.getInstance();
    final str = sp.getString('alarms');
    if (str == null) return;
    try {
      final list = jsonDecode(str) as List<dynamic>;
      _alarms = list.map((e) => Alarm.fromJson(Map<String, dynamic>.from(e))).toList();
      notifyListeners();
    } catch (_) {}
  }
}