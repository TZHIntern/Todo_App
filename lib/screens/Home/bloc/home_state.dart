// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

abstract class HomeActionState extends HomeState {
  const HomeActionState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  final List<Task> allTaskList;
  final List<Task> removedTaskList;
  final List<Task> completedTaskList;
  final List<Task> favouriteTaskList;

  const HomeInitial(
      {this.allTaskList = const <Task>[],
      this.removedTaskList = const <Task>[],
      this.completedTaskList = const <Task>[],
      this.favouriteTaskList = const <Task>[]});
  @override
  List<Object> get props =>
      [allTaskList, removedTaskList, completedTaskList, favouriteTaskList];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allTaskList': allTaskList.map((x) => x.toMap()).toList(),
      'removedTaskList': removedTaskList.map((x) => x.toMap()).toList(),
      'completedTaskList': completedTaskList.map((x) => x.toMap()).toList(),
      'favouriteTaskList': completedTaskList.map((x) => x.toMap()).toList(),
    };
  }

  factory HomeInitial.fromMap(Map<String, dynamic> map) {
    return HomeInitial(
        allTaskList:
            List<Task>.from(map["allTaskList"]?.map((x) => Task.fromMap(x))),
        removedTaskList: List<Task>.from(
            map["removedTaskList"]?.map((x) => Task.fromMap(x))),
        completedTaskList: List<Task>.from(
            map["completedTaskList"]?.map((x) => Task.fromMap(x))),
        favouriteTaskList: List<Task>.from(
            map["favouriteTaskList"]?.map((x) => Task.fromMap(x))));
  }
}

class LoadingState extends HomeState {}

class NavigateToLogInPageState extends HomeState {}
