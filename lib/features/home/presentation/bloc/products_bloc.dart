import 'package:digi_meh/features/home/domain/entities/product_list_entity.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_paging_event.dart';
import 'package:digi_meh/features/home/presentation/bloc/products_paging_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:digi_meh/features/home/domain/use_cases/get_products_use_case.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProductsPagingBloc
    extends Bloc<ProductsPagingEvent, ProductsPagingState> {
  ProductsPagingBloc() : super(ProductsPagingState()) {
    on<ProductsPagingFetchNext>((event, emit) async {
      final current = state;
      if (current.isLoading || !current.hasNextPage) return;

      final pageKey = current.lastPageIsEmpty ? null : current.nextIntPageKey;
      if (pageKey == null) {
        emit(current.copyWith(hasNextPage: false));
        return;
      }

      emit(current.copyWith(isLoading: true, error: null));

      try {
        ProductsList result = await GetIt.instance<GetProductsUseCase>()
            .execute(pageNumber: pageKey - 1);
        final isLastPage = result.page.totalPages == result.page.number + 1;
        emit(
          state.copyWith(
            isLoading: false,
            error: null,
            hasNextPage: !isLastPage,
            pages: [...?state.pages, result.products],
            keys: [...?state.keys, pageKey],
          ),
        );
      } catch (e) {
        emit(state.copyWith(isLoading: false, error: e));
      }
    });
    on<ProductsPagingRefresh>((event, emit) {
      emit(state.reset());
      add(ProductsPagingFetchNext());
    });
  }
}
