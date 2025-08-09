import 'package:mobile/common/TaskEnum.dart';

class TaskDto {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime createdAt;
  final DailyTaskDto dailyTasks;

  TaskDto({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.createdAt,
    required this.dailyTasks,
  });

  factory TaskDto.fromJson(Map<String, dynamic> json) {
    return TaskDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      dailyTasks: (json['dailyTasks'] != null && json['dailyTasks'].isNotEmpty)
          ? DailyTaskDto.fromJson(json['dailyTasks'][0])
          : DailyTaskDto(
        id: '',
        status: TaskEnum.PENDING.name,
        date: DateTime.now(),
        taskId: '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
      'dailyTasks': dailyTasks.toJson(),
    };
  }
}

class DailyTaskDto {
  final String id;
  final String status;
  final DateTime date;
  final String taskId;

  DailyTaskDto({
    required this.id,
    required this.status,
    required this.date,
    required this.taskId,
  });

  factory DailyTaskDto.fromJson(Map<String, dynamic> json) {
    return DailyTaskDto(
      id: json['id'] ?? '',
      status: json['status'] ?? TaskEnum.PENDING.name,
      date: DateTime.parse(json['date']),
      taskId: json['taskId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'date': date.toIso8601String(),
      'taskId': taskId,
    };
  }
}
