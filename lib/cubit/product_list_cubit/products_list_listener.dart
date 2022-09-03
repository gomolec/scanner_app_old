import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/cubit/history_cubit/history_cubit.dart';
import 'package:scanner_app/cubit/product_list_cubit/product_list_cubit.dart';

import '../../models/product_model.dart';
import '../session_cubit/session_cubit.dart';

class ProductListListener extends StatelessWidget {
  final Widget child;

  const ProductListListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListCubit, ProductListState>(
      listener: (context, state) {
        if (state is ProductListLoaded) {
          if (state.updatedFromHistory == false) {
            final Product? oldProduct = state.oldProduct;
            final Product? updatedProduct = state.updatedProduct;
            if (oldProduct != null && updatedProduct != null) {
              context.read<HistoryCubit>().addActivity(
                    oldProduct: oldProduct,
                    updatedProduct: updatedProduct,
                  );
            }
          }
          context.read<SessionCubit>().updateActualSession(
                savedHistory: context.read<HistoryCubit>().history,
                savedUndoHistory: context.read<HistoryCubit>().undoHistory,
                savedProducts: context.read<ProductListCubit>().products,
              );
        }
      },
      child: child,
    );
  }
}
