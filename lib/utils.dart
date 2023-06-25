import 'dart:math';

class AppUtils {
  int generateUniqueId() {
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    return random.nextInt(999999);
  }
}
