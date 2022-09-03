import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:scanner_app/models/product_model.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:diacritic/diacritic.dart';

part 'product_list_state.dart';

class ProductListCubit extends Cubit<ProductListState> {
  ProductListCubit() : super(ProductListInitial());

  List<Product> products = [];
  String searchQuery = "";

  void getProductList() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'],
    );

    if (result != null) {
      File file = File(result.files.single.path.toString());
      String fileString = await file.readAsString();
      List<List<String>> csvList = const CsvToListConverter().convert(
        fileString,
        shouldParseNumbers: false,
      );
      csvList.removeAt(0);
      products = [];
      for (var product in csvList) {
        products.add(Product(
          name: product[0],
          code: product[1],
          delivered: int.parse(product[2]),
        ));
      }
      emit(ProductListLoaded(products: products));
    } else {
      // User canceled the picker
    }
  }

  void restoreProductList({required List<Product> restoredProducts}) {
    products = restoredProducts;

    emit(ProductListLoaded(products: products));
  }

  void updateProduct(Product updatedProduct,
      {bool updatedFromHistory = false}) {
    int index =
        products.indexWhere((element) => element.code == updatedProduct.code);
    if (products[index] != updatedProduct) {
      List<Product> newList = products.toList();
      newList.replaceRange(index, index + 1, [updatedProduct]);
      emit(ProductListLoaded(
        products: _querryList(newList),
        oldProduct: products[index],
        updatedProduct: newList[index],
        updatedFromHistory: updatedFromHistory,
      ));
      products = newList;
    }
  }

  void getQueriedProductList(String query) {
    searchQuery = query;
    if (products.isNotEmpty) {
      List<Product> newList = _querryList(products).toList();
      emit(ProductListLoaded(products: newList));
    }
  }

  List<Product> _querryList(List<Product> list) {
    if (searchQuery.isNotEmpty) {
      return list
          .where((element) =>
              removeDiacritics(element.name.toLowerCase())
                  .contains(removeDiacritics(searchQuery).toLowerCase()) ||
              element.code.contains(searchQuery.toLowerCase()))
          .toList();
    } else {
      return list;
    }
  }

  void finish() {
    products = [];
    searchQuery = "";
    emit(ProductListInitial());
  }
}
