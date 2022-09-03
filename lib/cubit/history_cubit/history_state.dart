part of 'history_cubit.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryLoaded extends HistoryState {
  final List<HistoryAction> history;
  final HistoryAction? undoAction;
  final HistoryAction? redoAction;
  final bool isRestored;

  const HistoryLoaded({
    required this.history,
    this.undoAction,
    this.redoAction,
    this.isRestored = false,
  });

  @override
  List<Object?> get props => [history, undoAction, redoAction];
}
