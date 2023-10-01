import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Task extends Equatable {
  final String id;
  final String title;
  final String description;
  final String dateTime;
  bool? isDone;
  bool? isDelete;
  bool? isFav;

  Task(
      {required this.title,
      this.isDone,
      this.isDelete,
      required this.id,
      required this.description,
      required this.dateTime,
      this.isFav}) {
    {
      isDone = isDone ?? false;
      isDelete = isDelete ?? false;
      isFav = isFav ?? false;
    }
  }

  Task copyWith(
      {String? title,
      String? id,
      String? description,
      String? dateTime,
      bool? isDone,
      bool? isDelete,
      bool? isFav}) {
    return Task(
        title: title ?? this.title,
        isDone: isDone ?? this.isDone,
        isDelete: isDelete ?? this.isDelete,
        id: id ?? this.id,
        description: description ?? this.description,
        dateTime: dateTime ?? this.dateTime,
        isFav: isFav ?? this.isFav);
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "description": description,
      "dateTime": dateTime,
      'id': id,
      "isDone": isDone,
      "isDelete": isDelete,
      "isFav": isFav
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
        title: map['title'] ?? '',
        isDone: map['isDone'],
        isDelete: map['isDelete'],
        id: map['id'] ?? '',
        description: map['description'] ?? '',
        dateTime: map['dateTime'] ?? '',
        isFav: map['isFav'] ?? '');
  }

  @override
  List<Object?> get props =>
      [title, description, dateTime, id, isDone, isDelete, isFav];

  toJson() {}
}
