import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../history_cubit/history_cubit.dart';
import '../product_list_cubit/product_list_cubit.dart';
import '../session_cubit/session_cubit.dart';

class SessionListener extends StatelessWidget {
  final Widget child;

  const SessionListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionCubit, SessionState>(
      listener: (context, state) {
        if (state is SessionLoaded) {
          if (state.isRestored == true) {
            context.read<HistoryCubit>().restoreHistory(
                  restoredHistory: state.actualSession!.savedHistory,
                  restoredUndoHistory: state.actualSession!.savedUndoHistory,
                );
            context.read<ProductListCubit>().restoreProductList(
                  restoredProducts: state.actualSession!.savedProducts,
                );
          } else if (state.actualSession == null) {
            context.read<HistoryCubit>().finish();
            context.read<ProductListCubit>().finish();
          }
        }
      },
      child: child,
    );
  }
}
