import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/history_cubit/history_cubit.dart';
import 'package:scanner_app/cubit/product_list_cubit/product_list_cubit.dart';

class HistoryListener extends StatelessWidget {
  final Widget child;

  const HistoryListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<HistoryCubit, HistoryState>(
      listener: (context, state) {
        if (state is HistoryLoaded && state.isRestored == false) {
          if (state.undoAction != null && state.redoAction == null) {
            context.read<ProductListCubit>().updateProduct(
                  state.undoAction!.oldProduct,
                  updatedFromHistory: true,
                );
          } else if (state.redoAction != null) {
            context.read<ProductListCubit>().updateProduct(
                  state.redoAction!.updatedProduct,
                  updatedFromHistory: true,
                );
          }
        }
      },
      child: child,
    );
  }
}
