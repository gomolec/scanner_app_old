import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/history_action_model.dart';
import '../../models/product_model.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  List<HistoryAction> history = [];
  List<HistoryAction> undoHistory = [];

  HistoryCubit() : super(const HistoryLoaded(history: []));

  void addActivity({
    required Product oldProduct,
    required Product updatedProduct,
  }) {
    List<HistoryAction> updatedHistory = history.toList();
    updatedHistory.add(HistoryAction(
      oldProduct: oldProduct,
      updatedProduct: updatedProduct,
    ));
    if (updatedHistory.length > 10) {
      updatedHistory.removeAt(0);
    }
    emit(HistoryLoaded(history: updatedHistory));
    history = updatedHistory;
    undoHistory = [];
  }

  void undo() {
    List<HistoryAction> updatedHistory = history.toList();
    undoHistory.add(updatedHistory.removeLast());
    emit(HistoryLoaded(
      history: updatedHistory,
      undoAction: undoHistory.last,
    ));
    history = updatedHistory;
  }

  void redo() {
    List<HistoryAction> updatedHistory = history.toList();
    updatedHistory.add(undoHistory.removeLast());
    emit(HistoryLoaded(
      history: updatedHistory,
      redoAction: updatedHistory.last,
      undoAction: (undoHistory.isNotEmpty) ? undoHistory.last : null,
    ));
    history = updatedHistory;
  }

  void restoreHistory({
    required List<HistoryAction> restoredHistory,
    required List<HistoryAction> restoredUndoHistory,
  }) {
    history = restoredHistory;
    undoHistory = restoredUndoHistory;

    emit(HistoryLoaded(
      history: history,
      undoAction: (undoHistory.isNotEmpty) ? undoHistory.last : null,
    ));
  }

  void finish() {
    history = [];
    undoHistory = [];
    emit(const HistoryLoaded(history: []));
  }
}
