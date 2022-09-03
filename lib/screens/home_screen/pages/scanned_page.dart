import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scanner_app/products_sort_comparator.dart';

import '../../../cubit/product_list_cubit/product_list_cubit.dart';
import '../../../models/product_model.dart';

class ScannedPage extends StatelessWidget {
  const ScannedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state is ProductListLoaded) {
          List<Product> scannedProducts = state.products
              .where((element) => element.stock >= element.delivered)
              .toList();
          scannedProducts.sort(firstFlaggedComparison);
          return ListView.builder(
            itemCount: scannedProducts.length,
            itemBuilder: (BuildContext context, int index) {
              Product product = scannedProducts[index];
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
