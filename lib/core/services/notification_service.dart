import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _notificationChannelId = 'study_reminder';
  static const String _notificationChannelName = 'Study Reminders';
  static const String _notificationChannelDescription =
      'Notifications for study reminders';

  static const String _prefsKeyNotifications = 'study_notifications';

  Future<void> init() async {
    tz_data.initializeTimeZones();

    // Thiết lập múi giờ địa phương
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        // Handle notification tap
        print('Notification tapped: ${response.payload}');
      },
    );

    // Yêu cầu quyền thông báo
    await requestNotificationPermissions();
  }

  Future<bool> requestNotificationPermissions() async {
    // Yêu cầu quyền thông báo trên iOS
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    // Yêu cầu quyền thông báo trên Android 13 trở lên (API level 33+)
    else if (Platform.isAndroid) {
      try {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                    AndroidFlutterLocalNotificationsPlugin>();

        if (androidImplementation != null) {
          // Kiểm tra xem phương thức có tồn tại không
          final bool? granted =
              await androidImplementation.requestNotificationsPermission();
          return granted ?? false;
        }
      } catch (e) {
        print('Lỗi khi yêu cầu quyền thông báo: $e');
      }
    }

    return true;
  }

  Future<void> showTestNotification() async {
    // Kiểm tra quyền thông báo trước khi hiển thị
    final bool hasPermission = await requestNotificationPermissions();
    if (!hasPermission) {
      print('Không có quyền hiển thị thông báo');
      return;
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      channelDescription: _notificationChannelDescription,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // await flutterLocalNotificationsPlugin.show(
    //   0,
    //   'Kiểm tra thông báo',
    //   'Đây là thông báo kiểm tra',
    //   platformChannelSpecifics,
    //   payload: 'test',
    // );

    //print('Đã gửi thông báo kiểm tra');
  }

  Future<void> scheduleStudyReminder({
    required List<bool> selectedDays,
    required TimeOfDay selectedTime,
  }) async {
    // Kiểm tra quyền thông báo trước khi lên lịch
    final bool hasPermission = await requestNotificationPermissions();
    if (!hasPermission) {
      print('Không có quyền hiển thị thông báo');
      return;
    }

    // Cancel existing notifications
    await cancelAllNotifications();

    // Create notification details
    final androidNotificationDetails = AndroidNotificationDetails(
      _notificationChannelId,
      _notificationChannelName,
      channelDescription: _notificationChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
      enableLights: true,
      color: const Color(0xFFFFC400), // Yellow color
      ledColor: const Color(0xFFFFC400),
      ledOnMs: 1000,
      ledOffMs: 500,
    );

    final iosNotificationDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // Schedule notifications for each selected day
    final now = DateTime.now();
    final List<int> notificationIds = [];

    print(
        'Lên lịch thông báo cho các ngày: $selectedDays vào lúc ${selectedTime.hour}:${selectedTime.minute}');

    for (int i = 0; i < selectedDays.length; i++) {
      if (selectedDays[i]) {
        // Calculate the next occurrence of this day of the week
        final int dayOfWeek =
            (i + 1) % 7; // Convert to DateTime day of week (0 = Sunday)
        int daysUntilNext = dayOfWeek - now.weekday;
        if (daysUntilNext <= 0) daysUntilNext += 7;

        final scheduledDate = DateTime(
          now.year,
          now.month,
          now.day + daysUntilNext,
          selectedTime.hour,
          selectedTime.minute,
        );

        final id = i + 1; // Use day index + 1 as notification ID
        notificationIds.add(id);

        final scheduledDateTime = tz.TZDateTime.from(scheduledDate, tz.local);
        print(
            'Lên lịch thông báo ID $id cho ngày ${scheduledDate.day}/${scheduledDate.month} lúc ${scheduledDate.hour}:${scheduledDate.minute}');

        try {
          await flutterLocalNotificationsPlugin.zonedSchedule(
            id,
            'Nhắc nhở học tập',
            'Đã đến giờ học tập của bạn rồi đấy!',
            scheduledDateTime,
            notificationDetails,
            androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            payload: 'study_reminder',
          );
          print('Đã lên lịch thông báo ID $id thành công');
        } catch (e) {
          print('Lỗi khi lên lịch thông báo: $e');
        }
      }
    }

    // Save notification settings
    await _saveNotificationSettings(
      selectedDays: selectedDays,
      selectedTime: selectedTime,
      notificationIds: notificationIds,
    );

    // Hiển thị thông báo ngay lập tức để kiểm tra
    await showTestNotification();
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    print('Đã hủy tất cả thông báo');
  }

  Future<void> _saveNotificationSettings({
    required List<bool> selectedDays,
    required TimeOfDay selectedTime,
    required List<int> notificationIds,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final settings = {
      'selectedDays': selectedDays,
      'selectedTime': {
        'hour': selectedTime.hour,
        'minute': selectedTime.minute,
      },
      'notificationIds': notificationIds,
      'isEnabled': true,
    };

    await prefs.setString(_prefsKeyNotifications, jsonEncode(settings));
    print('Đã lưu cài đặt thông báo: ${jsonEncode(settings)}');
  }

  Future<Map<String, dynamic>?> getNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_prefsKeyNotifications);

    if (settingsString == null) return null;

    final settings = jsonDecode(settingsString) as Map<String, dynamic>;
    print('Đã tải cài đặt thông báo: $settings');
    return settings;
  }

  Future<void> disableNotifications() async {
    await cancelAllNotifications();

    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_prefsKeyNotifications);

    if (settingsString != null) {
      final settings = jsonDecode(settingsString) as Map<String, dynamic>;
      settings['isEnabled'] = false;
      await prefs.setString(_prefsKeyNotifications, jsonEncode(settings));
      print('Đã tắt thông báo');
    }
  }

  Future<void> restoreNotificationsIfEnabled() async {
    final settings = await getNotificationSettings();

    if (settings != null && settings['isEnabled'] == true) {
      final selectedDays = List<bool>.from(settings['selectedDays']);
      final timeMap = settings['selectedTime'] as Map<String, dynamic>;
      final selectedTime = TimeOfDay(
        hour: timeMap['hour'],
        minute: timeMap['minute'],
      );

      print('Khôi phục thông báo với cài đặt: ${jsonEncode(settings)}');
      await scheduleStudyReminder(
        selectedDays: selectedDays,
        selectedTime: selectedTime,
      );
    }
  }
}
