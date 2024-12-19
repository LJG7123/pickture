String formatMessageDate(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays == 0) {
    // 오늘
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  } else if (difference.inDays == 1) {
    // 어제
    return '어제';
  } else if (difference.inDays < 7) {
    // 이번 주
    const weekdays = ['월', '화', '수', '목', '금', '토', '일'];
    return weekdays[date.weekday - 1];
  } else {
    // 그 이전
    return '${date.month}월 ${date.day}일';
  }
} 