import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cubit/product_list_cubit/product_list_cubit.dart';
import '../../../models/product_model.dart';
import '../../../products_sort_comparator.dart';

class UnscannedPage extends StatelessWidget {
  const UnscannedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state is ProductListLoaded) {
          List<Product> unscannedProducts = state.products
              .where((element) => element.stock < element.delivered)
              .toList();
          unscannedProducts.sort(firstFlaggedComparison);
          return ListView.builder(
            itemCount: unscannedProducts.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = unscannedProducts[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text(product.code.toString()),
                trailing: Text("${product.stock} / ${product.delivered}"),
                minLeadingWidth: 0,
                leading: product.isFlagged
                    ? const SizedBox(
                        height: double.infinity,
                        child: Icon(
                          Icons.flag_rounded,
                          color: Color(0xFFFF4444),
                        ),
                      )
                    : null,
                onTap: () {
                  Navigator.pushNamed(context, '/product', arguments: product);
                },
              );
            },
          );
        } else {
          return const Center(
            child: Text("Pobierz listę!"),
          );
        }
      },
    );
  }
}
