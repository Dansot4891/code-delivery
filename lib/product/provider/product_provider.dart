import 'package:authentication/common/model/cursor_pagination_model.dart';
import 'package:authentication/common/provider/pagination_provider.dart';
import 'package:authentication/product/model/product_model.dart';
import 'package:authentication/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final productProvider = StateNotifierProvider<ProductStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(ProductRepositoryProvider);

  return ProductStateNotifier(repository: repo);
});

class ProductStateNotifier extends PaginationProvider<ProductModel, ProductRepository>{
  ProductStateNotifier({
    required super.repository,
  });
}