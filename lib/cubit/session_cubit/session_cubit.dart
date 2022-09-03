import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/history_action_model.dart';
import '../../models/product_model.dart';
import '../../models/session_model.dart';

part 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial()) {
    initialize();
  }

  Session? actualSession;

  int? actualSessionIndex;

  //TODOsavedSessions powinny być w map<key, value>,
  /*bo gdy usuniemy 1 klucz to bedzie dziura, 
  której indeksy listy nie uwzględnią,
  bedzie to sprawialo problem przy usuwaniu elementow */
  Box<Session> savedSessions = Hive.box<Session>("saved_sessions");

  List<Session> sessionsHistory = [];

  void initialize() async {
    //await savedSessions.clear();
    sessionsHistory = savedSessions.values.toList();
    emit(SessionLoaded(sessionsHistory: sessionsHistory));
  }

  void createNewSession() async {
    //TODO maksymalna ilosc zapisanych sesji do 10
    actualSession = Session(
      startTime: DateTime.now(),
      savedProducts: const [],
      savedHistory: const [],
      savedUndoHistory: const [],
    );
    actualSessionIndex = await savedSessions.add(actualSession!);
    emit(SessionLoaded(
      sessionsHistory: sessionsHistory.toList(),
      actualSession: actualSession,
    ));
  }

  void updateActualSession({
    List<Product>? savedProducts,
    List<HistoryAction>? savedHistory,
    List<HistoryAction>? savedUndoHistory,
  }) async {
    if (actualSession != null) {
      Session updatedSession = actualSession!.copyWith(
        savedProducts: savedProducts,
        savedHistory: savedHistory,
        savedUndoHistory: savedUndoHistory,
      );
      savedSessions.put(actualSessionIndex!.toInt(), actualSession!);
      //emit(SessionLoaded(actualSession: actualSession, sessionsHistory: sessionsHistory));
      emit((state as SessionLoaded).copyWith(actualSession: updatedSession));
      actualSession = updatedSession;
    }
  }

  void restoreSession({required int sessionIndex}) {
    actualSession = sessionsHistory.removeAt(sessionIndex);
    actualSessionIndex = sessionIndex;

    emit(SessionLoaded(
      sessionsHistory: sessionsHistory.toList(),
      actualSession: actualSession,
      isRestored: true,
    ));
  }

  void finishSession() async {
    if (actualSession != null) {
      actualSession = actualSession!.copyWith(endTime: DateTime.now());
      savedSessions.put(actualSessionIndex!.toInt(), actualSession!);
      actualSession = null;
      actualSessionIndex = null;
      initialize();
    }
  }
}
