part of 'session_cubit.dart';

abstract class SessionState extends Equatable {
  const SessionState();

  @override
  List<Object?> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoaded extends SessionState {
  final List<Session> sessionsHistory;
  final Session? actualSession;
  final bool isRestored;

  const SessionLoaded({
    required this.sessionsHistory,
    this.actualSession,
    this.isRestored = false,
  });

  SessionLoaded copyWith({
    List<Session>? sessionsHistory,
    Session? actualSession,
    bool? isRestored,
  }) {
    return SessionLoaded(
      sessionsHistory: sessionsHistory ?? this.sessionsHistory,
      actualSession: actualSession ?? this.actualSession,
      isRestored: isRestored ?? this.isRestored,
    );
  }

  @override
  List<Object?> get props => [sessionsHistory, actualSession, isRestored];
}
