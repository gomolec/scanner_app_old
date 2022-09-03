import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/history_cubit/history_cubit.dart';
import '../../../models/history_action_model.dart';

class HistoryDrawer extends StatelessWidget {
  const HistoryDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(child: BlocBuilder<HistoryCubit, HistoryState>(
      builder: (context, state) {
        if (state is HistoryLoaded) {
          final List<HistoryAction> historyList =
              state.history.reversed.toList();
          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  elevation: 5.0,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 2,
                          color: Color(0xEEA4C422),
                        ),
                      ),
                    ),
                    child: Text(
                      "Historia zmian",
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ),
                Expanded(
                  child: (state.history.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          itemCount: historyList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final HistoryAction historyAction =
                                historyList[index];
                            final int trailingValue =
                                historyAction.updatedProduct.stock -
                                    historyAction.oldProduct.stock;
                            return ListTile(
                              title: Text(historyAction.updatedProduct.name),
                              trailing: (() {
                                if (trailingValue > 0) {
                                  return Text(
                                    "+$trailingValue",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            color: const Color(0xEEA4C422)),
                                  );
                                }
                                return Text(
                                  "$trailingValue",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6!
                                      .copyWith(color: const Color(0xFFFF4444)),
                                );
                              }()),
                              subtitle: RichText(
                                text: TextSpan(
                                  style: const TextStyle(color: Colors.black),
                                  children: [
                                    TextSpan(
                                      text:
                                          "${historyAction.oldProduct.stock} / ${historyAction.oldProduct.delivered}",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: " ➔ ",
                                    ),
                                    TextSpan(
                                      text:
                                          "${historyAction.updatedProduct.stock} / ${historyAction.updatedProduct.delivered}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text("Brak historii"),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<HistoryCubit, HistoryState>(
                    builder: (context, state) {
                      bool disableUndo = true;
                      bool disableRedo = true;
                      if (state is HistoryLoaded) {
                        if (state.history.isNotEmpty) disableUndo = false;
                        if (state.undoAction != null) disableRedo = false;
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: (disableUndo)
                                ? null
                                : () {
                                    context.read<HistoryCubit>().undo();
                                  },
                            icon: const Icon(Icons.undo_rounded),
                            label: const Text("Cofnij"),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xEEA4C422),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: (disableRedo)
                                ? null
                                : () {
                                    context.read<HistoryCubit>().redo();
                                  },
                            icon: const Icon(Icons.redo_rounded),
                            label: const Text("Ponów"),
                            style: ElevatedButton.styleFrom(
                              primary: const Color(0xEEA4C422),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xEEA4C422),
            ),
          );
        }
      },
    ));
  }
}
