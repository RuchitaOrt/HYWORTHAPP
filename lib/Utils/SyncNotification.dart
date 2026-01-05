import 'dart:ui';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class SyncNotification {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// Update notification
static Future<void> update({
  required int id,
  required String title,
  required String body,
  int progress = 0,
  bool completed = false,
}) async {
  AndroidNotificationDetails androidDetails;

  if (completed) {
    // Completed: remove progress bar, mark ongoing = false
    androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'Data Sync',
      channelDescription: 'Background data synchronization',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: false,        // very important
      showProgress: false,   // remove progress bar
      color: const Color(0xFF4CAF50), // green
    );
  } else {
    // Sync in progress
    androidDetails = AndroidNotificationDetails(
      'sync_channel',
      'Data Sync',
      channelDescription: 'Background data synchronization',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
    );
  }

  final details = NotificationDetails(android: androidDetails);

  // await _plugin.show(
  //   id,
  //   title,
  //   completed ? "$body completed successfully" : "$body: $progress%",
  //   details,
  // );
 if (completed) {
  await _plugin.cancel(id); // remove old progress bar
  await _plugin.show(
    id,
    title,
    "$body completed successfully",
    NotificationDetails(
      android: AndroidNotificationDetails(
        'sync_channel',
        'Data Sync',
        channelDescription: 'Background data synchronization',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: false,
        showProgress: false,
        color: const Color(0xFF4CAF50),
      ),
    ),
  );
} else {
  await _plugin.show(
    id,
    title,
    "$body: $progress%",
    NotificationDetails(
      android: AndroidNotificationDetails(
        'sync_channel',
        'Data Sync',
        channelDescription: 'Background data synchronization',
        importance: Importance.low,
        priority: Priority.low,
        ongoing: true,
        showProgress: true,
        maxProgress: 100,
        progress: progress,
      ),
    ),
  );
}


}

}
