part of 'product_list_cubit.dart';

abstract class ProductListState extends Equatable {
  const ProductListState();

  @override
  List<Object?> get props => [];
}

class ProductListInitial extends ProductListState {}

class ProductListLoaded extends ProductListState {
  final List<Product> products;
  final Product? oldProduct;
  final Product? updatedProduct;
  final bool updatedFromHistory;

  const ProductListLoaded({
    required this.products,
    this.oldProduct,
    this.updatedProduct,
    this.updatedFromHistory = false,
  });

  @override
  List<Object?> get props => [products, oldProduct, updatedProduct];
}
