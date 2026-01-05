import 'dart:async';
import 'dart:io';

Future<void> retry(
  Future<void> Function() action, {
  Duration delay = const Duration(seconds: 5),
}) async {
  while (true) {
    try {
      await action();
      return;
    } on SocketException catch (_) {
      await Future.delayed(delay);
    } catch (_) {
      rethrow;
    }
  }
}
