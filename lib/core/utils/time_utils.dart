import 'package:intl/intl.dart';

class TimeUtils {
  static String formatDuration(Duration duration) {
    if (duration.isNegative) return "00:00:00";

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));

    return "$hours:$minutes:$seconds";
  }

  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return "--:--:--";
    return DateFormat('HH:mm:ss').format(dateTime);
  }
}
