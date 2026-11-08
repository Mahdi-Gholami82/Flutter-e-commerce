import 'package:digi_meh/features/home/domain/entities/product_entity.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

final class ProductsPagingState extends PagingStateBase<int, Product?> {
  ProductsPagingState({
    super.pages,
    super.keys,
    super.hasNextPage,
    super.isLoading,
    super.error,
  }) {}

  @override
  ProductsPagingState copyWith({
    Defaulted<List<List<Product?>>?>? pages = const Omit(),
    Defaulted<List<int>?>? keys = const Omit(),
    Defaulted<Object?>? error = const Omit(),
    Defaulted<bool>? hasNextPage = const Omit(),
    Defaulted<bool>? isLoading = const Omit(),
  }) {
    return ProductsPagingState(
      pages: pages is Omit ? this.pages : pages as List<List<Product?>>?,
      keys: keys is Omit ? this.keys : keys as List<int>?,
      error: error is Omit ? this.error : error,
      hasNextPage: hasNextPage is Omit ? this.hasNextPage : hasNextPage as bool,
      isLoading: isLoading is Omit ? this.isLoading : isLoading as bool,
    );
  }

  @override
  ProductsPagingState reset() => ProductsPagingState(
    pages: null,
    keys: null,
    error: null,
    hasNextPage: true,
    isLoading: false,
  );
}
