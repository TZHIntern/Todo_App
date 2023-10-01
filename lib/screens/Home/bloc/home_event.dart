part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class LogoutButtonPressedEvent extends HomeEvent {}

class AddTaskButtonClickEvent extends HomeEvent {
  final Task task;

  const AddTaskButtonClickEvent(this.task);
  @override
  List<Object> get props => [task];
}

class DeleteTaskButtonClickEvent extends HomeEvent {
  //final Task task;
  final String taskId;

  const DeleteTaskButtonClickEvent(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class DeleteFromRecycleBinEvent extends HomeEvent {
  // final Task task;
  final String taskId;
  const DeleteFromRecycleBinEvent(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class UpdateCompleteCheckBoxClickEvent extends HomeEvent {
  final String taskId;
  final bool isDone;
  // final Task task;

  const UpdateCompleteCheckBoxClickEvent(this.taskId, this.isDone);
  @override
  List<Object> get props => [taskId, isDone];
}

class AddtoFavouriteBookMark extends HomeEvent {
  // final Task task;
  final String taskId;
  final bool isFav;

  const AddtoFavouriteBookMark(this.taskId, this.isFav);
  @override
  List<Object> get props => [taskId, isFav];
}

class EditTask extends HomeEvent {
  final String taskId;
  final String title;
  final String description;

  const EditTask(
    this.taskId,
    this.title,
    this.description,
  );
  @override
  List<Object> get props => [taskId, title, description];
}

class RestoreDeletedItem extends HomeEvent {
  // final Task task;
  final String taskId;
  const RestoreDeletedItem(this.taskId);
  @override
  List<Object> get props => [taskId];
}

class DeleteAllFromRestoreItems extends HomeEvent {
  final List allTaskId;

  const DeleteAllFromRestoreItems(this.allTaskId);
  @override
  List<Object> get props => [allTaskId];
}

class UpdateProfile extends HomeEvent {
  final String userId;
  final String userName;
  final String bio;

  const UpdateProfile(this.userId, this.userName, this.bio);
  @override
  List<Object> get props => [userId, userName, bio];
}
