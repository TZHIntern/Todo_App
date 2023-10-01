import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc_application/data/models/tasks.dart';

import 'package:flutter_bloc_application/data/repos/auth_repositories.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends HydratedBloc<HomeEvent, HomeState> {
  final AuthRepository authRepository;

  HomeBloc(
    this.authRepository,
  ) : super(const HomeInitial()) {
    on<LogoutButtonPressedEvent>(logoutButtonPressedEvent);
    on<AddTaskButtonClickEvent>(addTaskButtonClickEvent);
    on<DeleteTaskButtonClickEvent>(deleteTaskButtonClickEvent);
    on<UpdateCompleteCheckBoxClickEvent>(updateCompleteCheckBoxClickEvent);
    on<DeleteFromRecycleBinEvent>(deleteFromRecycleBinEvent);
    on<AddtoFavouriteBookMark>(addtoFavouriteBookMark);
    on<EditTask>(editTask);
    on<RestoreDeletedItem>(restoreDeletedItem);
    on<DeleteAllFromRestoreItems>(deleteAllFromRestoreItems);
    on<UpdateProfile>(updateProfile);
  }

  FutureOr<void> logoutButtonPressedEvent(
      LogoutButtonPressedEvent event, Emitter<HomeState> emit) {
    authRepository.signOut();
    var state = this.state;
    if (state is HomeInitial) {
      emit(HomeInitial(
          allTaskList: state.allTaskList,
          removedTaskList: state.removedTaskList,
          completedTaskList: state.completedTaskList,
          favouriteTaskList: state.favouriteTaskList));
    }
  }

  FutureOr<void> addTaskButtonClickEvent(
      AddTaskButtonClickEvent event, Emitter<HomeState> emit) {
    var state = this.state;
    final user = FirebaseAuth.instance.currentUser;
    List<Task> allTasks = [];
    Task task = event.task;
    if (state is HomeInitial) {
      allTasks = List.from(state.allTaskList)..add(task);
      emit(
        HomeInitial(
            allTaskList: allTasks,
            removedTaskList: state.removedTaskList,
            completedTaskList: state.completedTaskList,
            favouriteTaskList: state.favouriteTaskList),
      );
      FirebaseFirestore.instance.collection("All User Tasks").add({
        'userEmail': user!.email,
        'taskTitle': task.title,
        'taskDescription': task.description,
        'isDone': task.isDone,
        'isFav': task.isFav,
        'isDelete': task.isDelete,
        'TimeStamp': DateTime.now().toString(),
      });
    }
  }

  FutureOr<void> deleteTaskButtonClickEvent(
      DeleteTaskButtonClickEvent event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("All User Tasks")
          .doc(event.taskId);
      docRef.update({'isDelete': true});
      emit(const HomeInitial());
    }
  }

  FutureOr<void> deleteFromRecycleBinEvent(
      DeleteFromRecycleBinEvent event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("All User Tasks")
          .doc(event.taskId);
      docRef.delete();
      emit(const HomeInitial());
      // emit(
      //   HomeInitial(
      //   allTaskList: List.from(state.allTaskList)..remove(event.task),
      //   removedTaskList: List.from(state.removedTaskList)..remove(event.task),
      //   completedTaskList: List.from(state.completedTaskList)
      //     ..removeWhere((element) => element.id == event.task.id),
      //   favouriteTaskList: List.from(state.favouriteTaskList)
      //     ..removeWhere((element) => element.id == event.task.id),
      // ));
    }
  }

  @override
  HomeState? fromJson(Map<String, dynamic> json) {
    return HomeInitial.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(HomeState state) {
    if (state is HomeInitial) {
      return state.toMap();
    } else {
      return null;
    }
  }

  FutureOr<void> updateCompleteCheckBoxClickEvent(
      UpdateCompleteCheckBoxClickEvent event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("All User Tasks")
          .doc(event.taskId);

      if (event.isDone == false) {
        docRef.update({'isDone': true});
      } else {
        docRef.update({'isDone': false});
      }

      emit(const HomeInitial());
    }
    // var state = this.state;
    // final task = event.task;
    // List<Task> alltasks = [];
    // List<Task> removedtaks = [];
    // List<Task> completedTasks = [];
    // List<Task> favouriteTasks = [];

    // if (state is HomeInitial) {
    //   removedtaks = state.removedTaskList;
    //   favouriteTasks = state.favouriteTaskList;
    //   completedTasks = state.completedTaskList;
    //   alltasks = state.allTaskList;

    //   alltasks = List.from(state.allTaskList)..remove(task);
    //   task.isDone == false
    //       ? {
    //           alltasks = List.from(alltasks)
    //             ..insert(0, task.copyWith(isDone: true)),
    //           completedTasks = List.from(completedTasks)
    //             ..insert(0, task.copyWith(isDone: true)),
    //           task.isFav == true
    //               ? {
    //                   favouriteTasks = List.from(favouriteTasks)
    //                     ..remove(event.task)
    //                     ..insert(0, task.copyWith(isDone: true)),
    //                 }
    //               : favouriteTasks = state.favouriteTaskList
    //         }
    //       : {
    //           alltasks = List.from(alltasks)
    //             ..insert(0, task.copyWith(isDone: false)),
    //           completedTasks = List.from(completedTasks)..remove(task),
    //           task.isFav == true
    //               ? {
    //                   favouriteTasks = List.from(favouriteTasks)
    //                     ..remove(event.task)
    //                     ..insert(0, task.copyWith(isDone: false)),
    //                 }
    //               : favouriteTasks = state.favouriteTaskList
    //         };
    // }
    // emit(HomeInitial(
    //     allTaskList: alltasks,
    //     removedTaskList: removedtaks,
    //     completedTaskList: completedTasks,
    //     favouriteTaskList: favouriteTasks));
  }

  FutureOr<void> addtoFavouriteBookMark(
      AddtoFavouriteBookMark event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("All User Tasks")
          .doc(event.taskId);

      if (event.isFav == false) {
        docRef.update({'isFav': true});
      } else {
        docRef.update({'isFav': false});
      }

      emit(const HomeInitial());
    }
    // var state = this.state;
    // List<Task> alltasks = [];
    // List<Task> completedTasks = [];
    // List<Task> favTasks = [];
    // List<Task> removedTask = [];
    // if (state is HomeInitial) {
    //   alltasks = state.allTaskList;
    //   completedTasks = state.completedTaskList;
    //   favTasks = state.favouriteTaskList;
    //   removedTask = state.removedTaskList;
    //   if (event.task.isDone == false) {
    //     if (event.task.isFav == false) {
    //       var taskIndex = alltasks.indexOf(event.task);
    //       alltasks = List.from(alltasks)
    //         ..remove(event.task)
    //         ..insert(
    //           taskIndex,
    //           event.task.copyWith(isFav: true),
    //         );
    //       favTasks.insert(0, event.task.copyWith(isFav: true));
    //     } else {
    //       var taskIndex = alltasks.indexOf(event.task);
    //       alltasks = List.from(alltasks)
    //         ..remove(event.task)
    //         ..insert(
    //           taskIndex,
    //           event.task.copyWith(isFav: false),
    //         );
    //       favTasks.remove(event.task);
    //     }
    //   } else {
    //     if (event.task.isFav == false) {
    //       var taskIndex = completedTasks.indexOf(event.task);
    //       var alltaskIndex = alltasks.indexOf(event.task);
    //       completedTasks = List.from(completedTasks)
    //         ..remove(event.task)
    //         ..insert(
    //           taskIndex,
    //           event.task.copyWith(isFav: true),
    //         );
    //       alltasks = List.from(alltasks)
    //         ..remove(event.task)
    //         ..insert(
    //           alltaskIndex,
    //           event.task.copyWith(isFav: true),
    //         );
    //       favTasks.insert(0, event.task.copyWith(isFav: true));
    //     } else {
    //       var taskIndex = completedTasks.indexOf(event.task);
    //       var alltaskIndex = alltasks.indexOf(event.task);
    //       completedTasks = List.from(completedTasks)
    //         ..remove(event.task)
    //         ..insert(
    //           taskIndex,
    //           event.task.copyWith(isFav: false),
    //         );
    //       alltasks = List.from(alltasks)
    //         ..remove(event.task)
    //         ..insert(
    //           alltaskIndex,
    //           event.task.copyWith(isFav: false),
    //         );
    //       favTasks.remove(event.task);
    //     }
    //   }
    // }
    // emit(HomeInitial(
    //     allTaskList: alltasks,
    //     completedTaskList: completedTasks,
    //     favouriteTaskList: favTasks,
    //     removedTaskList: removedTask));
  }

  FutureOr<void> editTask(EditTask event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("All User Tasks")
          .doc(event.taskId);
      docRef.update(
          {'taskTitle': event.title, 'taskDescription': event.description});
      emit(const HomeInitial());
    }
    // var state = this.state;
    // List<Task> favList = [];
    // List<Task> allList = [];
    // List<Task> completedList = [];
    // List<Task> removedList = [];
    // if (state is HomeInitial) {
    //   favList = state.favouriteTaskList;
    //   allList = state.allTaskList;
    //   completedList = state.completedTaskList;
    //   removedList = state.removedTaskList;
    //   if (event.oldTask.isFav == true) {
    //     favList
    //       ..removeWhere(
    //         (element) => element.id == event.oldTask.id,
    //       )
    //       ..insert(0, event.newTask);
    //   }
    // }
    // emit(HomeInitial(
    //     allTaskList: List.from(allList)
    //       ..remove(event.oldTask)
    //       ..insert(0, event.newTask),
    //     completedTaskList: List.from(completedList)..remove(event.oldTask),
    //     favouriteTaskList: favList,
    //     removedTaskList: removedList));
  }

  FutureOr<void> restoreDeletedItem(
      RestoreDeletedItem event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("All User Tasks")
          .doc(event.taskId);
      docRef.update({'isDelete': false, 'isDone': false, 'isFav': false});
      emit(const HomeInitial());
    }
    // var state = this.state;
    // List<Task> alltask = [];
    // List<Task> removedTasks = [];
    // List<Task> completedTasks = [];
    // List<Task> favTasks = [];
    // if (state is HomeInitial) {
    //   removedTasks = state.removedTaskList;
    //   alltask = state.allTaskList;
    //   completedTasks = state.completedTaskList;
    //   favTasks = state.favouriteTaskList;
    //   removedTasks = List.from(removedTasks)..remove(event.task);
    //   alltask = List.from(alltask)
    //     ..insert(0,
    //         event.task.copyWith(isDelete: false, isDone: false, isFav: false));
    //   completedTasks = List.from(completedTasks)
    //     ..removeWhere((element) => element.id == event.task.id);
    //   favTasks = List.from(favTasks)
    //     ..removeWhere((element) => element.id == event.task.id);
    //   emit(HomeInitial(
    //       allTaskList: alltask,
    //       removedTaskList: removedTasks,
    //       completedTaskList: completedTasks,
    //       favouriteTaskList: favTasks));
    // }
  }

  FutureOr<void> deleteAllFromRestoreItems(
      DeleteAllFromRestoreItems event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      for (var i in event.allTaskId) {
        DocumentReference docRef =
            FirebaseFirestore.instance.collection("All User Tasks").doc(i);
        docRef.delete();
      }

      emit(const HomeInitial());
    }

    // var state = this.state;
    // List<Task> completedTask = [];
    // List<Task> favTask = [];
    // if (state is HomeInitial) {
    //   completedTask = state.completedTaskList;
    //   favTask = state.favouriteTaskList;
    //   for (var i in state.removedTaskList) {
    //     completedTask = List.from(completedTask)
    //       ..removeWhere((element) => element.id == i.id);
    //     favTask = List.from(favTask)
    //       ..removeWhere((element) => element.id == i.id);
    //   }
    //   emit(HomeInitial(
    //       allTaskList: state.allTaskList,
    //       removedTaskList: List.from(state.removedTaskList)..clear(),
    //       completedTaskList: completedTask,
    //       favouriteTaskList: favTask));
    // }
  }

  FutureOr<void> updateProfile(UpdateProfile event, Emitter<HomeState> emit) {
    var state = this.state;
    if (state is HomeInitial) {
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Users").doc(event.userId);
      docRef.update({'userName': event.userName, 'Bio': event.bio});
      emit(const HomeInitial());
    }
  }
}
