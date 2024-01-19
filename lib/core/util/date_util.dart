class DateUtil {
  static String getFormattedDate(DateTime dateTime) {
    return '${dateTime.day}.${dateTime.month}.${dateTime.year}';
  }

  static String getFormattedTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute}';
  }

  bool isDateBeforeThisWeek(DateTime date) {
    final now = DateTime.now();
    final firstDayOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    return date.isBefore(firstDayOfThisWeek);
  }

  bool isDateInThisWeek(DateTime date) {
    final now = DateTime.now();
    final firstDayOfThisWeek = now.subtract(Duration(days: now.weekday - 1));
    final lastDayOfThisWeek = firstDayOfThisWeek.add(Duration(days: 6));
    return date.isAfter(firstDayOfThisWeek) && date.isBefore(lastDayOfThisWeek);
  }

  bool isDateAfterThisWeek(DateTime date) {
    final now = DateTime.now();
    final lastDayOfThisWeek = now.add(Duration(days: 7 - now.weekday));
    return date.isAfter(lastDayOfThisWeek);
  }
}