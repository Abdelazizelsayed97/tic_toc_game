class Task {
  final String id;
  final String title;
  final DateTime endTime;
  final int duration; // Duration in seconds
  final bool isCompleted;
  final int remainingTime; // Remaining time in seconds

  Task({
    required this.id,
    required this.title,
    required this.endTime,
    required this.duration,
    this.isCompleted = false,
    this.remainingTime = 0,
  });

  Task copyWith({
    String? id,
    String? title,
    DateTime? endTime,
    int? duration,
    bool? isCompleted,
    int? remainingTime,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      remainingTime: remainingTime ?? this.remainingTime,
    );
  }
}
