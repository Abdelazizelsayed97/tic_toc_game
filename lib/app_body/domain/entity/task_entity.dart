class Task {
  final String id;
  final int taskCount;
  final DateTime endTime;
  final int duration;
  final int remainingTime;
  final bool isCompleted;

  Task({
    this.isCompleted = false,
    required this.id,
    required this.taskCount,
    required this.endTime,
    required this.duration,
    this.remainingTime = 0,
  });

  Task copyWith(
      {int? taskCount,
      DateTime? endTime,
      int? duration,
      int? remainingTime,
      bool? isCompleted}) {
    return Task(
      id: id,
      taskCount: taskCount ?? this.taskCount,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
      remainingTime: remainingTime ?? this.remainingTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
