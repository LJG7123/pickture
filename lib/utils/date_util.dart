extension DateExtensions on DateTime {
  String dateOnly() {
    return "$year-$month-$day";
  }

  String formatMessageDate() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays == 0) {
      // 오늘
      return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      // 어제
      return '어제';
    } else if (difference.inDays < 7) {
      // 이번 주
      const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
      return weekdays[weekday - 1];
    } else {
      // 그 이전
      return '$month월 $day일';
    }
  }
}
